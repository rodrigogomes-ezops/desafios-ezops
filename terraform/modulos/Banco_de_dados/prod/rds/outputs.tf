output "rds_endpoint" {
  description = "Endpoint do RDS"
  value       = aws_db_instance.this.address
}

output "rds_port" {
  description = "Porta do RDS"
  value       = aws_db_instance.this.port
}

output "rds_postgres_connection_string" {
  description = "Connection string do PostgreSQL"
  value       = "postgresql://${var.username}:${var.password}@${aws_db_instance.this.address}:${aws_db_instance.this.port}/${var.db_name}"
  sensitive   = true
}