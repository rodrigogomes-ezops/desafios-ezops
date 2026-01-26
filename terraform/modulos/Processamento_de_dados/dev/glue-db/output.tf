output "glue_database_name" {
  description = "Glue Database Name"
  value       = aws_glue_catalog_database.this.name
}
