resource "aws_elasticache_subnet_group" "this" {
  name        = var.name
  description = "Subnet Group Elasticache"
  subnet_ids  = var.subnet_ids
  tags = var.tags
}

