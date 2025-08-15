resource "aws_db_subnet_group" "privates_v2" {
  name = "subnet_group_for_privates_v2"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]
  tags = {
    Name = "Subnet group for privates"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier              = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-aurora-cluster"
  availability_zones              = ["${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}a", "${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}c"]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_param.name
  vpc_security_group_ids          = [aws_security_group.rds.id]
  engine_mode                     = "provisioned"
  backup_retention_period         = 7
  preferred_backup_window         = "22:00-23:00"
  preferred_maintenance_window    = "Sat:07:00-Sat:07:30"
  master_username                 = lookup(var.rds, "default.username")
  master_password                 = lookup(var.rds, "default.password")
  database_name                   = lookup(var.rds, "default.db_name")
  skip_final_snapshot             = true
  final_snapshot_identifier       = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}"
  db_subnet_group_name            = aws_db_subnet_group.privates_v2.name
  enabled_cloudwatch_logs_exports = ["postgresql"]

  engine         = lookup(var.rds, "default.engine")
  engine_version = lookup(var.rds, "default.engine_version")

  lifecycle {
    ignore_changes = [availability_zones]
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = terraform.workspace == "prod" ? 2 : 1
  identifier         = "postgresql-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.cluster_identifier
  instance_class     = lookup(var.rds, "default.instance_class")
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
  apply_immediately  = true

  # maintenance window
  preferred_maintenance_window = aws_rds_cluster.aurora_cluster.preferred_maintenance_window

  # options
  db_parameter_group_name    = aws_db_parameter_group.aurora_instance_param.name
  auto_minor_version_upgrade = false
}
