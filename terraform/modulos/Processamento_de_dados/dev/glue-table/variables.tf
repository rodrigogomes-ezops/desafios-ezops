variable "glue_table_name" {
  type        = string
  description = "Glue Table Name"
}

variable "glue_db_name" {
  type        = string
  description = "Glue Database Name"
}

variable "s3_bucket_log" {
  type        = string
  description = "S3 bucket logs"
}

variable "log_path" {
  type        = string
  description = "Path para o log no S3"
}

variable "columns_json" {
  description = "JSON com as colunas (mapa nome_logico => objeto)."
  type        = string
}
