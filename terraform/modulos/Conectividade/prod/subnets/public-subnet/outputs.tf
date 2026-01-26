output "public_subnet_id" {
  description = "IDs das subnets public"
  value       = [for subnet in aws_subnet.prod_public : subnet.id]
}

output "public_subnet_ids_by_name" {
  description = "Mapa de nomes para os IDs das subnets public"
  value = {
    for az, name in var.public_subnet_names :
    name => aws_subnet.prod_public[az].id
  }
}