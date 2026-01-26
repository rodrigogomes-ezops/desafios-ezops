variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}

variable "environment" {
  description = "Ambiente do bucket (ex: dev, prod)"
  type        = string
}

variable "tags" {
  description = "Tags adicionais para o bucket"
  type        = map(string)
  default     = {}
}

variable "enable_versioning" {
  description = "Habilita versionamento no bucket"
  type        = bool
  default     = false
}

variable "enable_encryption" {
  type = bool
}

variable "bucket_policy_json" {
  type        = string
  default     = null
  description = "Optional JSON-formatted bucket policy to attach to the bucket"
}