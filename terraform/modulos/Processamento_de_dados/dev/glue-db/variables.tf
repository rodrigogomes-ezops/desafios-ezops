variable "glue_db_name" {
  type        = string
  description = "Glue Database Name"
}

variable "tags" {
  type        = map(string)
  description = "Tags do Glue Database"
}