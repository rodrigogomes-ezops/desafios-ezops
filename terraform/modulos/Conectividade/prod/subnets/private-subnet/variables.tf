variable "private_subnet_names" {
  description = "Map para subrede privada."
  type        = map(string)
}
variable "subnet_cidr_blocks_private" {
  description = "List of CIDR blocks for the subnets Private."
   type = map(string)
}

variable "vpc_id" {
  description = "ID da VPC onde a subnet será criada"
  type        = string
}

variable "tags" {
  description = "Tags adicionais para o subnet"
  type        = map(string)
  default     = {}
}
variable "availability_zones" {
  description = "Zonas de disponibilidades"
    type = map(string)
}