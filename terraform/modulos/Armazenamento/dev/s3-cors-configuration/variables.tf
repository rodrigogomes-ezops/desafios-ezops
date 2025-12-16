variable "bucket_name" {
  description = "Nome/ID do bucket S3"
  type        = string
}

variable "cors_rules" {
  description = "Lista de regras CORS"
  type = list(object({
    allowed_origins = list(string)
    allowed_methods = list(string)
    allowed_headers = optional(list(string), ["*"])
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number, 3000)
  }))
  default = []
}
