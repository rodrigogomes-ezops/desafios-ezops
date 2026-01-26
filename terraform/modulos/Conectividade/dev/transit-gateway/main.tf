resource "aws_ec2_transit_gateway" "this" {
  description = "Transit Gateway"
  amazon_side_asn = 64512
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = var.tags
}
