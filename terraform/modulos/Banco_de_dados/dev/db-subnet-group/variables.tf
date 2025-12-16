variable "tags" {
  description = "Tags adicionais para o Db - SubnetGroup"
  type        = map(string)
}

variable "name" {
  type        = string
  description = "Nome Subnet Group"
}

variable "subnet_ids" {
  description = "Subnets do DB - SubnetGroup"
  type        = list(string)
}