variable "subnet_ids" {
  description = "Lista de subnets públicas (ex: uma por AZ)."
  type        = list(string)
}

variable "route_table_ids" {
  description = "Lista de route tables correspondentes"
  type        = list(string)
}
