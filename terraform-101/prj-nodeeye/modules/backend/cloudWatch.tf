#######
## ECS
#######
resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/ecs/task/${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-application"
  retention_in_days = lookup(var.common, "${terraform.workspace}.retention_in_days", "default.retention_in_days")
}

resource "aws_cloudwatch_log_group" "application_migration" {
  name              = "/aws/ecs/task/${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-application-migration"
  retention_in_days = lookup(var.common, "${terraform.workspace}.retention_in_days", "default.retention_in_days")
}
