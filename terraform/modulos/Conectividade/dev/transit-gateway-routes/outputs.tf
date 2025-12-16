output "route_ids" {
  description = "IDs das rotas criadas (por chave do JSON)."
  value       = { for k, r in aws_ec2_transit_gateway_route.this : k => r.id }
}
