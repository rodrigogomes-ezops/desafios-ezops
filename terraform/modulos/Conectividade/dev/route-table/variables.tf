variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Lista com as duas subnets públicas (em ordem)"
  type        = list(string)
}

variable "tags" {
  type = map(string)
}

variable "service_name" {
  type = map(string)
}

variable "azs" {
  type    = list(string)
  default = []
}