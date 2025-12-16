variable "name"{
    description = "Nome da Lambda"
    type = string
}

variable "iam_role"{
    description = "iam role attach Lambda"
    type = string
}

variable "handler"{
    description = "handler Lambda"
    type = string
}

variable "alb_int_auth" {
  description = "Variavél do ALB do Authorizer"  
  type = string
}

variable "filename"{
    description = "filename Lambda path"
    type = string
}

variable "security_group"{
    description = "Security Group Attach Lambda"
    type = string
}

variable "subnet_ids"{
    description = "Subnet Ids Attach Lambda"
    type        = list(string)
}

variable "tags" {
  description = "Tags da Lambda"  
  type = map(string)
}