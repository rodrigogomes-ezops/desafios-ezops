variable "rest_api_id" {
  description = "ID do API REST já criado (aws_api_gateway_rest_api.id)."
  type        = string
}

variable "resources" {
  description = "Mapa nome=>path para lookup. Ex.: { cancel = \"/api/v2/cancel\" }"
  type        = map(string)
}
