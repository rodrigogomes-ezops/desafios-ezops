variable "transit_gateway_attachment_id" {
  description = "ID do attachment (ex.: módulo do aws_ec2_transit_gateway_vpc_attachment)."
  type        = string
}

variable "transit_gateway_route_table_id" {
  description = "ID da TGW Route Table alvo."
  type        = string
}
