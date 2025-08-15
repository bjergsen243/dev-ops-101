resource "aws_rds_cluster_parameter_group" "aurora_cluster_param" {
  name   = "${lookup(var.rds, "default.engine")}-cluster-parameter-group"
  family = lookup(var.rds, "default.family")

  # install libraries
  parameter {
    apply_method = "pending-reboot"
    name         = "shared_preload_libraries"
    value        = "pg_stat_statements,pg_hint_plan,pgaudit"
  }

  # audit setting
  parameter {
    apply_method = "immediate"
    name         = "log_statement"
    value        = "mod"
  }
  parameter {
    apply_method = "immediate"
    name         = "log_min_duration_statement"
    value        = 0
  }
  parameter {
    apply_method = "immediate"
    name         = "pgaudit.log"
    value        = "write"
  }
  parameter {
    apply_method = "immediate"
    name         = "pgaudit.role"
    value        = "rds_pgaudit"
  }
  parameter {
    apply_method = "immediate"
    name         = "pgaudit.log_catalog"
    value        = 1
  }
  parameter {
    apply_method = "immediate"
    name         = "pgaudit.log_parameter"
    value        = 1
  }
  parameter {
    apply_method = "immediate"
    name         = "pgaudit.log_relation"
    value        = 1
  }
  parameter {
    apply_method = "immediate"
    name         = "pgaudit.log_statement_once"
    value        = 1
  }

  # no local
  parameter {
    apply_method = "immediate"
    name         = "lc_messages"
    value        = "C"
  }
  parameter {
    apply_method = "immediate"
    name         = "lc_monetary"
    value        = "C"
  }
  parameter {
    apply_method = "immediate"
    name         = "lc_numeric"
    value        = "C"
  }
  parameter {
    apply_method = "immediate"
    name         = "lc_time"
    value        = "C"
  }
}


resource "aws_db_parameter_group" "aurora_instance_param" {
  name   = "${lookup(var.rds, "default.engine")}-parameter-group"
  family = lookup(var.rds, "default.family")
}
