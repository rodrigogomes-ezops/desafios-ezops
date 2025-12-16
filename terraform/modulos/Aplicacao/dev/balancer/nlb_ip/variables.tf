variable "name" {
  type        = string
  description = "Nome do Load Balancer"
}

variable "internal" {
  type        = bool
  description = "Se o LB é interno"
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Proteção contra deleção"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Lista de Security Groups para o LB"
}

variable "subnet_ids_1a" {
  type        = string
  description = "Lista de subnets para o LB"
}

variable "subnet_ids_1b" {
  type        = string
  description = "Lista de subnets para o LB"
}


variable "access_logs_bucket" {
  type        = string
  description = "Bucket S3 para access logs"
}

variable "access_logs_prefix" {
  type        = string
  description = "Prefixo dos logs no bucket"
}

variable "access_logs_enabled" {
  type        = bool
  description = "Se os access logs estão habilitados"
}

variable "type" {
  type = string
  description = "Tipo do Balancer"
  
}

variable "tags" {
  type        = map(string)
  description = "Tags do recurso"
}


variable "private_ipv4_address_1a" {
  type = string
  description = "IP do balancer"
  
}

variable "private_ipv4_address_1b" {
  type = string
  description = "IP do balancer"
  
}