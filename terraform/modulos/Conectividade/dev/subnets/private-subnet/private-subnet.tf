resource "aws_subnet" "dev_private" {
  for_each          = var.private_subnet_names
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_blocks_private[each.key]
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = each.value
  }
}
