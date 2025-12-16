resource "aws_db_parameter_group" "this" {
  description = var.parameter_group_name
  family      = var.family
  name        = var.parameter_group_name
  tags        = var.tags

  # Cria o parâmetro só se o usuário enviar um valor
  dynamic "parameter" {
    for_each = var.shared_preload_libraries == null ? [] : [1]
    content {
      name         = "shared_preload_libraries"
      value        = var.shared_preload_libraries
      apply_method = "pending-reboot" 
    }
  }
}