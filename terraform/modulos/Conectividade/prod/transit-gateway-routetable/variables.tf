variable "transit_gateway_id" {
  description = "ID do Transit Gateway."
  type        = string
}

variable "tags" {
  description = "Tags da TGW route table."
  type        = map(string)
  default     = {}
}
