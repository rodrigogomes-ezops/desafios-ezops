output "parameter_group_name" {
  description = "Nome do DB Parameter Group criado."
  value       = aws_db_parameter_group.this.name
}