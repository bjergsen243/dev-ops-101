resource "aws_secretsmanager_secret" "api" {
  name                    = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}/Api"
  description             = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)} Environment data."
  recovery_window_in_days = 30
}
