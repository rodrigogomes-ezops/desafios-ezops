output "nat_gateway_id" {
  description = "ID do NAT Gateway"
  value       = aws_nat_gateway.this.id
}

output "eip_allocation_id" {
  description = "ID do Elastic IP alocado"
  value       = aws_eip.this.id
}
