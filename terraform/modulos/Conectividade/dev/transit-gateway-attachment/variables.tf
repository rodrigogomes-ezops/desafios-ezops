variable "transit_gateway_id" {
  description = "ID do Transit Gateway (aws_ec2_transit_gateway.id)."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC a anexar."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets da VPC para o attachment (>=2 AZs recomendado)."
  type        = list(string)
}

variable "tags" {
  description = "Tags do attachment."
  type        = map(string)
  default     = {}
}
