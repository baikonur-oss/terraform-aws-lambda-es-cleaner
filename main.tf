locals {
  package_filename = "${path.module}/package.zip"
}

data "external" "package" {
  program = ["bash", "-c", "curl -s -L -o ${local.package_filename} ${var.lambda_package_url} && echo {}"]
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/aws/lambda/${var.name}"

  retention_in_days = "${var.log_retention_in_days}"
}

resource "aws_lambda_function" "function" {
  function_name = "${var.name}"
  handler       = "${var.handler}"
  role          = "${module.iam.arn}"
  runtime       = "${var.runtime}"
  memory_size   = "${var.memory}"
  timeout       = "${var.timeout}"

  filename = "${local.package_filename}"

  # Below is a very dirty hack to force base64sha256 to wait until 
  # package download in data.external.package finishes.
  #
  # WARNING: explicit depends_on from this resource to data.external.package 
  # does not help

  source_code_hash = "${base64sha256(file("${jsonencode(data.external.package.result) == "{}" ? local.package_filename : ""}"))}"
  tracing_config {
    mode = "${var.tracing_mode}"
  }
  environment {
    variables = {
      TZ = "${var.timezone}"

      ES_HOST      = "${var.elasticsearch_host}"
      MAX_AGE_DAYS = "${var.max_age_days}"
      DRY_RUN_ONLY = "${var.dry_run_only}"
    }
  }
  tags = "${var.tags}"
}

resource "aws_cloudwatch_event_rule" "rule" {
  name                = "${var.name}"
  schedule_expression = "${var.schedule_expression}"
}

resource "aws_cloudwatch_event_target" "target" {
  arn  = "${aws_lambda_function.function.arn}"
  rule = "${aws_cloudwatch_event_rule.rule.name}"
}

resource "aws_lambda_permission" "allow_cloudwatch_invocation" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.rule.arn}"
}

module "iam" {
  source  = "baikonur-oss/iam-nofile/aws"
  version = "v1.0.1"

  type = "lambda"
  name = "${var.name}"

  policy_json = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "es:*"
            ],
            "Resource": [
                "${var.elasticsearch_arn}/*"
            ]
        }
    ]
}
EOF
}
