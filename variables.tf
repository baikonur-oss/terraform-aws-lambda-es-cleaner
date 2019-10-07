variable "timezone" {
  description = "tz database timezone name (e.g. Asia/Tokyo)"
  default     = "UTC"
}

variable "memory" {
  description = "Lambda Function memory in megabytes"
  default     = 256
}

variable "timeout" {
  description = "Lambda Function timeout in seconds"
  default     = 60
}

variable "elasticsearch_host" {
  description = "Elasticsearch Service endpoint (without https://)"
}

variable "elasticsearch_arn" {
  description = "Elasticsearch Service ARN"
}

variable "lambda_package_url" {
  description = "Lambda package URL (see Usage in README)"
}

variable "handler" {
  description = "Lambda Function handler (entrypoint)"
  default     = "main.handler"
}

variable "runtime" {
  description = "Lambda Function runtime"
  default     = "python3.7"
}

variable "name" {
  description = "Resource name"
}

variable "max_age_days" {
  description = "retention period of Elasticsearch Service index (days). Older indexes will be removed."
  default     = "60"
}

variable "dry_run_only" {
  description = "Dry run option for testing purpose"
  default     = "false"
}

variable "schedule_expression" {
  description = "Lambda Schedule Expressions for Rules (https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/events/ScheduledEvents.html)"
}

variable "tracing_mode" {
  description = "X-Ray tracing mode (see: https://docs.aws.amazon.com/lambda/latest/dg/API_TracingConfig.html )"
  default     = "PassThrough"
}

variable "tags" {
  description = "Tags for Lambda Function"
  type        = map(string)
  default     = {}
}

variable "log_retention_in_days" {
  description = "Lambda Function log retention in days"
  default     = 30
}

