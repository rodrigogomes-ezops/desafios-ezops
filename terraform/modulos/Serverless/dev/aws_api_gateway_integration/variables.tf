variable "rest_api_id" {
  description = "ID do API REST (aws_api_gateway_rest_api.id)."
  type        = string
}

variable "resource_id" {
  description = "ID do recurso alvo (ex.: data.aws_api_gateway_resource.<name>.id)."
  type        = string
}

variable "uri" {
  description = "URI do backend (ex.: http://host:port/path)."
  type        = string
}

variable "connection_id" {
  description = "ID do VPC Link (aws_api_gateway_vpc_link.id)."
  type        = string
}

variable "http_method" {
  description = "Método HTTP do método do API."
  type        = string
  default     = "POST"
}

variable "integration_http_method" {
  description = "Método HTTP usado pela integração."
  type        = string
  default     = "POST"
}

variable "authorizer_headers" {
  description = "Lista de headers para repassar do authorizer (gera integration.request.header.* = context.authorizer.*)."
  type        = list(string)
  default     = []
}
