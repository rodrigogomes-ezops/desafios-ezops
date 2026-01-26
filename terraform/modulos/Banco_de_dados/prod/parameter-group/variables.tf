variable "family" {
  type        = string
  description = "Familia do banco de Dados"
}

variable "parameter_group_name" {
  type        = string
  description = "Nome Parameter Group"  
}

variable "tags" {
  description = "Tags adicionais para o Parameter Group."
  type        = map(string)
  default     = {}
}