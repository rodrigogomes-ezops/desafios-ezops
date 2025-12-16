output "route_table_association_ids" {
  description = "IDs das associações entre subnets e route tables"
  value       = [for assoc in aws_route_table_association.this : assoc.id]
}