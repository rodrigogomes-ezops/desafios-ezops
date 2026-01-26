variable "target_group_arn" {
  description = "ARN do Target Group ao qual os targets serão associados"
  type        = string
}

variable "target_id" {
  description = "Mapeamento de targets (ex: instâncias EC2) a serem associados ao Target Group"
  type        = map(string)
}

variable "target_port" {
  description = "Mapa opcional de portas por target (chave deve bater com a de target_id)"
  type        = map(number)
  default     = {}
}

variable "target_az" {
  description = "Mapa opcional de Availability Zone por target (ex.: us-east-1a). Necessário quando o IP não está na VPC."
  type        = map(string)
  default     = {}
}