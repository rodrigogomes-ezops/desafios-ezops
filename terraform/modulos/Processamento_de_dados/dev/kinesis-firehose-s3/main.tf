locals {
  parameters = jsondecode(var.parameter_json)
}

 resource "aws_kinesis_firehose_delivery_stream" "this" {
   name        = var.firehose_name
   destination = "extended_s3"

   extended_s3_configuration {
     role_arn   = var.role_arn
     bucket_arn = var.bucket_arn

#     # Prefixo com partições dinâmicas
     prefix = var.prefix
     error_output_prefix = var.error_output_prefix

     buffering_size     = var.buffering_size
     buffering_interval = var.buffering_interval
     compression_format = var.compression_format

#     # Habilita partição dinâmica
     dynamic_partitioning_configuration {
       enabled = var.dynamic_partitioning_enabled
     }

#     # Extrai campos do JSON (application, log_type)
     processing_configuration {
       enabled = var.processing_configuration_enabled

       processors {
         type = var.processors_type
         dynamic "parameters" {
           for_each = local.parameters

           content {
             parameter_name  = try(parameters.value.parameter_name, null)
             parameter_value = try(parameters.value.parameter_value, null)
           }
         }
       }
     }
   }
   tags = var.tags
 }
