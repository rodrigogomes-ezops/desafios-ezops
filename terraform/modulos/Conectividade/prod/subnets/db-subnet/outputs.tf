output "db_subnet_id" {
  description = "IDs das subnets db"
  value       = [for subnet in aws_subnet.prod_db : subnet.id]
}

output "db_subnet_ids_by_name" {
  description = "Mapa de nomes para os IDs das subnets db"
  value = {
    for az, name in var.db_subnet_names :
    name => aws_subnet.prod_db[az].id
  }
}
