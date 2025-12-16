output "private_subnet_id" {
  description = "IDs das subnets privadas"
  value       = [for subnet in aws_subnet.dev_private : subnet.id]
}

output "private_subnet_ids_by_name" {
  description = "Mapa de nomes para os IDs das subnets privadas"
  value = {
    for az, name in var.private_subnet_names :
    name => aws_subnet.dev_private[az].id
  }
}
