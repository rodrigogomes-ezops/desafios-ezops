variable "name" {
  description = "Name Subnet Elasticache"
  type        = string  
}

variable "subnet_ids" {
  type    = list(string)  
}

variable "tags" {
  description = "Tags adicionais para o Elasticache-SubnetGroup"
  type        = map(string) 
}