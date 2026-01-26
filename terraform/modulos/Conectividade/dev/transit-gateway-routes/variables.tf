variable "transit_gateway_route_table_id" {
  description = "ID da TGW route table onde criar as rotas."
  type        = string
}

variable "routes_json" {
  description = "JSON com rotas para a TGW route table."
  type        = string
}
