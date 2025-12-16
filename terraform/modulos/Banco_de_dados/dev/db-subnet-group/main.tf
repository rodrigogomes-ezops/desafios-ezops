resource "aws_db_subnet_group" "this" {
  name        = var.name
  description = "Db Subnet Group"
  subnet_ids  = var.subnet_ids
  tags        = var.tags
}