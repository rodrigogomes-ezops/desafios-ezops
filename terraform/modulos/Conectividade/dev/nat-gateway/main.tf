resource "aws_eip" "this" {
  domain = "vpc"

  tags = var.tags
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.public_subnet_id
  connectivity_type = "public" #padrão

  tags = var.tags

  depends_on = [aws_eip.this]
}
