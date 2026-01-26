resource "aws_wafv2_web_acl_logging_configuration" "this" {
  log_destination_configs = [var.log_destination]
  resource_arn            = var.resource_arn
}