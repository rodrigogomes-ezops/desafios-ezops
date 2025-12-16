variable "public_subnet_id" {
  description = "ID da subnet pública onde o NAT Gateway será criado"
  type        = string
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
}
