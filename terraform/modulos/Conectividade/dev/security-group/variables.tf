variable "name" {
  description = "Nome do Security Group"
  type        = string
}

variable "description" {
  description = "Descrição do Security Group"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o SG será criado"
  type        = string
}

variable "tags" {
  description = "Tags do SG"
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress)"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress)"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []
}
