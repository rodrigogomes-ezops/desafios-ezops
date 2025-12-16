output "instance_id" {
  description = "ID da instância criada"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "IP privado da instância"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "IP público da instância (se aplicável)"
  value       = aws_instance.this.public_ip
}

output "instance_name" {
  description = "Nome da instância (tag Name)"
  value       = lookup(aws_instance.this.tags, "Name", null)
}
