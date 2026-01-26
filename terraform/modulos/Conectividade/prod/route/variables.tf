variable "route_table_id" {
  description = "ID da route table alvo."
  type        = string
}

variable "routes_json" {
  description = "JSON com rotas (mapa nome_logico => objeto)."
  type        = string
  default     = "{}"
}

variable "gateway_id" {
  description = "ID do Internet Gateway (opcional, substitui gateway_id do JSON se fornecido)."
  type        = string
  default     = null
}
