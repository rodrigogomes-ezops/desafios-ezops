variable "vpc_cidr_block" {
  description = "Subrede padrão do VPC"
  type        = string
}

variable "tags" {
  description = "Tags adicionais para o bucket"
  type        = map(string)
  default     = {}
}
