variable "api_name" {
  description = "Nome do API Gateway REST."
  type        = string
}

variable "swagger_file" {
  description = "Caminho do Swagger/OpenAPI (yaml/json). Se null, cria API vazia."
  type        = string
  default     = null
}

variable "disable_execute_api_endpoint" {
  description = "Desabilita o endpoint execute-api padrão."
  type        = bool
}

variable "endpoint_types" {
  description = "Tipos do endpoint (EDGE, REGIONAL, PRIVATE)."
  type        = list(string)
}

variable "stage_name" {
  description = "Nome do stage."
  type        = string
}

variable "stage_variables" {
  description = "Variáveis do stage."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
