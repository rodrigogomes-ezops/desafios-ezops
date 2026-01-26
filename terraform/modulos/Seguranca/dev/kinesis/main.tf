# resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
#   name        = "aws-waf-logs-s3-wazuh"
#   destination = "extended_s3"
#    
#   extended_s3_configuration {
#     custom_time_zone   = "UTC"
#     role_arn = "arn:aws:iam::986523078570:role/ph-prod-eu-firehose-wazuh"
#     bucket_arn = "arn:aws:s3:::s3-ph-prod-eu-wazuh-waf"
#     prefix = "waf/"
#
#   }
#   tags = var.tags
# }
