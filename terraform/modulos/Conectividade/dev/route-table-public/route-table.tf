resource "aws_route_table" "this" {
  count  = length(var.subnet_ids)
  vpc_id = var.vpc_id
  tags   = {
    Name = "RouteTable-${var.service_name[var.azs[count.index]]}-${var.azs[count.index]}"  
  }
}