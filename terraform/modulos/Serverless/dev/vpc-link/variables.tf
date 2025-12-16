variable "name" {
  description = "Nome do VPC Link no API Gateway"
  type        = string
}

variable "description" {
  description = "Descrição (opcional)"
  type        = string
  default     = null
}

variable "target_arns" {
  description = "Lista de ARNs de Network Load Balancers (NLB) a serem associados ao VPC Link"
  type        = list(string)
}

variable "tags" {
  description = "Tags VPC LINK"
  type        = map(string)
  default     = {}
}
