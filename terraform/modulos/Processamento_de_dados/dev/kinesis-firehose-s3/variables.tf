variable "firehose_name" {
  type        = string
  description = "Kinesis Firehose Name"
}

variable "role_arn" {
  type        = string
  description = "ARN da role"
}

variable "bucket_arn" {
  type        = string
  description = "ARN do bucket S3"
}

variable "prefix" {
  type        = string
  description = "Prefixo da partições dinâmicas"
}

variable "error_output_prefix" {
  type        = string
  description = "Prefixo de erro da partições dinâmicas"
}

variable "buffering_size" {
  type        = string
  description = "Buffering size"
}

variable "buffering_interval" {
  type        = string
  description = "Buffering interval"
}

variable "compression_format" {
  type        = string
  description = "Compression format"
}

variable "dynamic_partitioning_enabled" {
  type        = bool
  description = "Ativar dynamic partitioning"
}

variable "processing_configuration_enabled" {
  type        = bool
  description = "Ativar processing configuration"
}

variable "processors_type" {
  type        = string
  description = "Processors type"
}


variable "parameter_json" {
  description = "JSON com as parameter (mapa nome_logico => objeto)."
  type        = string
}


variable "tags" {
  type        = map(string)
  description = "Tags do Kinesis Firehose para o S3"
}
