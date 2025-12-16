output "id" {
  description = "ID da associação TGW RT ↔ attachment."
  value       = aws_ec2_transit_gateway_route_table_association.this.id
}
