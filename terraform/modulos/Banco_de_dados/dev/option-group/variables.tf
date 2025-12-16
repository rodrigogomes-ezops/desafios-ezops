variable "engine_name" {
  type        = string
  description = "Engine Name"
}

variable "major_engine_version" {
  type        = string
  description = "Version Major Engine"
}

variable "name" {
  type        = string
  description = "Name option group"
}
variable "option_name" {
  type        = string
  description = "Option name"
}

variable "tags" {
  description = "Tags adicionais para o Option-Group"
  type        = map(string) 
}
   