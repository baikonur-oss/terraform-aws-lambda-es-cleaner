# AWS Elasticsearch Service index cleaner Terraform module

Terraform module for automatically deleting Elasticsearch index exceeding maximum retention period.

![terraform v0.12.x](https://img.shields.io/badge/terraform-v0.12.x-brightgreen.svg)

## Prerequisites

Index name in Elasticsearch Service must include `YYYYMMDD` timeformat key.

## Usage

```HCL
module "es_cleaner" {
  source  = "baikonur-oss/lambda-es-cleaner/aws"

  lambda_package_url = "https://github.com/baikonur-oss/terraform-aws-lambda-es-cleaner/releases/download/v1.0.0/lambda_package.zip"
  name               = "es_cleaner"

  elasticsearch_host  = "search-dev-elasticsearch-xxxxxxxx.ap-northeast-1.es.amazonaws.com"
  elasticsearch_arn   = "arn:aws:es:ap-northeast-1:0123456789:domain/elasticsearch"
  schedule_expression = "cron(0 1 * * ? *)"
}
```

Warning: use same module and package versions!

### Version pinning
#### Terraform Module Registry
Use `version` parameter to pin to a specific version, or to specify a version constraint when pulling from [Terraform Module Registry](https://registry.terraform.io) (`source = baikonur-oss/lambda-es-cleaner/aws`).
For more information, refer to [Module Versions](https://www.terraform.io/docs/configuration/modules.html#module-versions) section of Terraform Modules documentation.

#### GitHub URI
Make sure to use `?ref=` version pinning in module source URI when pulling from GitHub.
Pulling from GitHub is especially useful for development, as you can pin to a specific branch, tag or commit hash.
Example: `source = github.com/baikonur-oss/terraform-aws-lambda-es-cleaner?ref=v1.0.0`

For more information on module version pinning, see [Selecting a Revision](https://www.terraform.io/docs/modules/sources.html#selecting-a-revision) section of Terraform Modules documentation.


<!-- Documentation below is generated by pre-commit, do not overwrite manually -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dry\_run\_only | Dry run option for testing purpose | string | `"false"` | no |
| elasticsearch\_arn | Elasticsearch Service ARN | string | n/a | yes |
| elasticsearch\_host | Elasticsearch Service endpoint (without https://) | string | n/a | yes |
| handler | Lambda Function handler (entrypoint) | string | `"main.handler"` | no |
| lambda\_package\_url | Lambda package URL (see Usage in README) | string | n/a | yes |
| log\_retention\_in\_days | Lambda Function log retention in days | string | `"30"` | no |
| max\_age\_days | retention period of Elasticsearch Service index (days). Older indexes will be removed. | string | `"60"` | no |
| memory | Lambda Function memory in megabytes | string | `"256"` | no |
| name | Resource name | string | n/a | yes |
| runtime | Lambda Function runtime | string | `"python3.7"` | no |
| schedule\_expression | Lambda Schedule Expressions for Rules (https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/events/ScheduledEvents.html) | string | n/a | yes |
| tags | Tags for Lambda Function | map(string) | `{}` | no |
| timeout | Lambda Function timeout in seconds | string | `"60"` | no |
| timezone | tz database timezone name (e.g. Asia/Tokyo) | string | `"UTC"` | no |
| tracing\_mode | X-Ray tracing mode (see: https://docs.aws.amazon.com/lambda/latest/dg/API_TracingConfig.html ) | string | `"PassThrough"` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing

Make sure to have following tools installed:
- [Terraform](https://www.terraform.io/)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/)

### macOS
```bash
brew install pre-commit terraform terraform-docs

# set up pre-commit hooks by running below command in repository root
pre-commit install
```
