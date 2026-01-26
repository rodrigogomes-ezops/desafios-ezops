resource "aws_subnet" "dev_public" {
  for_each          = var.public_subnet_names
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_blocks_public[each.key]
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = each.value
  }
}