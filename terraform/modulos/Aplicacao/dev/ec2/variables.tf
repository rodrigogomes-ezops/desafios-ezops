variable "ami" {
  description = "AMI da instância"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância"
  type        = string
}

variable "iam_instance_profile" {
  description = "Perfil IAM"
  type        = string
}

variable "security_group_ids" {
  description = "Lista de Security Groups"
  type        = list(string)
}

variable "key_name" {
  description = "Chave SSH"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet"
  type        = string
}

variable "private_ip" {
  type    = string
  default = ""
  description = "Endereço IP privado opcional. Se vazio, o IP será atribuído automaticamente."
}

variable "instance_name" {
  description = "Nome da Instancia"
  type        = string
}

variable "user_data" {
  description = "Caminho do script de user_data"
  type        = string
}

variable "tags" {
  description = "Tags da instância"
  type        = map(string)
}
