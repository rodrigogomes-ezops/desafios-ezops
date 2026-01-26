output "id" {
  description = "ID do attachment TGW↔VPC."
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}
