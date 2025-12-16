output "id"   { 
 value = aws_ec2_transit_gateway.this.id  
 description = "ID do TGW" 
}
output "arn"  { 
 value = aws_ec2_transit_gateway.this.arn 
 description = "ARN do TGW" 
}
output "association_default_route_table_id" {
  value       = aws_ec2_transit_gateway.this.association_default_route_table_id
  description = "TGW RT (default association)"
}
output "propagation_default_route_table_id" {
  value       = aws_ec2_transit_gateway.this.propagation_default_route_table_id
  description = "TGW RT (default propagation)"
}
