##################################################################################################
######################################## Variáveis de Conectividade ##############################
##################################################################################################

variable "vpc_cidr_block" {
  description = "cidr_block usado para a VPC"
  type        = string
}

variable "tags_vpc" {
  description = "Tags adicionais para a VPC"
  type        = map(string)
  default     = {}
}

variable "tags_public_subnet" {
  description = "Tags adicionais para a Subnet Publica"
  type        = map(string)
  default     = {}
}

variable "subnet_cidr_blocks_public" {
  description = "Lista de CIDR blocks para a subrede Publica"
  type        = map(string)
}

variable "availability_zones_public" {
  description = "Zonas de disponibilidades publicas"
  type        = map(string)
}

variable "public_subnet_names" {
  description = "Map para subrede publica e Nat Gateway"
  type        = map(string)
}

variable "tags_route_table_public" {
  description = "Tags adicionais para route table public"
  type        = map(string)
  default     = {}
}  

variable "rt_public_name" {
  description = " route table name Public"
  type = map(string)
}