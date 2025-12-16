output "appfront_subnet_id" {
  description = "IDs das subnets appfront"
  value       = [for subnet in aws_subnet.dev_appfront : subnet.id]
}

output "appfront_subnet_ids_by_name" {
  description = "Mapa de nomes para os IDs das subnets appfront"
  value = {
    for az, name in var.appfront_subnet_names :
    name => aws_subnet.dev_appfront[az].id
  }
}
