output "option_group_id" {
  description = "Id do option group criado"
  value = aws_db_option_group.this.id

}

output "option_group_name" {
  description = "Nome do option group criado"
  value       = aws_db_option_group.this.name
}