variable "name" {
  type        = string
  description = "Nome do Cloudwatch LogGroup " 
}

variable "retention_days" {
  type        = string
  description = "Dias de Retenção dos logs"  
}

variable "tags" {
  type = map(any)
  description = "Tags do Cloudwatch"  
}  