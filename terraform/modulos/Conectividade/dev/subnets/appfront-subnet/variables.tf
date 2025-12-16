variable "appfront_subnet_names" {
  description = "Map para subrede appfront e Nat Gateway."
  type        = map(string)
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_cidr_blocks_appfront" {
  description = "Lista de CIDR blocks para a subrede appfront."
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