terraform {
  backend "s3" {
    bucket  = "rodrigo-desafio-ezops-tfstate"
    key     = "main/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}