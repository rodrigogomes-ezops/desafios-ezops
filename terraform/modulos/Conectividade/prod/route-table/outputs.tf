output "route_table_ids" {
  description = "IDs das route tables públicas criadas."
  value       = [for rt in aws_route_table.this : rt.id]
}

output "route_table_ids_by_az" {
  description = "Mapa AZ => route_table_id."
  value = {
    for idx, rt in aws_route_table.this :
    var.azs[idx] => rt.id
  }
}
