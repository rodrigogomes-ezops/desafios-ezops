resource "aws_glue_catalog_database" "this" {
  name = var.glue_db_name
  tags = var.tags
}