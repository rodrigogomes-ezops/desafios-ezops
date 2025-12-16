variable "rest_api_id" {
  description = "ID do API REST (aws_api_gateway_rest_api.id)."
  type        = string
}

variable "resource_id" {
  description = "ID do recurso alvo (ex.: data.aws_api_gateway_resource.<name>.id)."
  type        = string
}

variable "http_method" {
  description = "Método HTTP do integration (ex.: POST)."
  type        = string
  default     = "POST"
}

variable "status_code" {
  description = "Status code da integração (ex.: 200, 400, 500)."
  type        = string
}

variable "selection_pattern" {
  description = "Regex de seleção do integration response (ex.: .*200.*)."
  type        = string
}
