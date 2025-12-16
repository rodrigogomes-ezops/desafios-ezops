variable "function_name" {
  description = "Nome da CloudFront Function"
  type        = string
}

variable "function_runtime" {
  description = "Runtime da função"
  type        = string
  default     = "cloudfront-js-1.0"
}

variable "publish" {
  description = "Publicar automaticamente a função"
  type        = bool
  default     = true
}

variable "function_code" {
  description = "Conteúdo JS da função"
  type        = string
}
