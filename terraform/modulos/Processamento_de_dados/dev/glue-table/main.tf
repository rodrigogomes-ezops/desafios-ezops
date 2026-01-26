locals {
  columns = jsondecode(var.columns_json)
}


resource "aws_glue_catalog_table" "this" {
  name             = var.glue_table_name
  database_name    = var.glue_db_name
  table_type       = "EXTERNAL_TABLE"

  parameters = {
    classification = "json"
    EXTERNAL       = "TRUE"
  }

  storage_descriptor {
    location       = "s3://${var.s3_bucket_log}/${var.log_path}"
    input_format   = "org.apache.hadoop.mapred.TextInputFormat"
    output_format  = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "json"
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    dynamic "columns" {
      for_each      = local.columns

      content {
        name        = try(columns.value.name, null)
        type        = try(columns.value.type, null)
      }
    }
  }
  
  partition_keys {
    name = "year"
    type = "string"
  }

  partition_keys {
    name = "month"
    type = "string"
  }

  partition_keys {
    name = "day"
    type = "string"
  }
}
