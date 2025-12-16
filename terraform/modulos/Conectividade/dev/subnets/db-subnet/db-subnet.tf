resource "aws_subnet" "dev_db" {
  for_each          = var.db_subnet_names
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_blocks_db[each.key]
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = each.value
  }
}