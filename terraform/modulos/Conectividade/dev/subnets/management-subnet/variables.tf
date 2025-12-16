variable "management_subnet_names" {
  description = "Map para subrede managementa e Nat Gateway."
  type        = map(string)
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_cidr_blocks_management" {
  description = "Lista de CIDR blocks para a subrede management."
  type        = map(string)
}

variable "availability_zones" {
  description = "Zonas de disponibilidades"
  type        = map(string)
}
variable "tags" {
  description = "Tags adicionais para a Subnet"
  type        = map(string)
  default     = {}
}