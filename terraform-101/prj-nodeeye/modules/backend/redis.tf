resource "aws_elasticache_subnet_group" "main" {
  name = "subnet-group-for-redis"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]
}

resource "aws_elasticache_parameter_group" "main" {
  name   = "parameter-group-for-redis"
  family = "redis6.x"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id          = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-cache"
  description                   = "redis cluster for ${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-cache"
  engine_version                = "6.x"
  node_type                     = "cache.t3.micro"
  num_cache_clusters            = 1
  port                          = 6379
  automatic_failover_enabled    = false
  auto_minor_version_upgrade    = false
  apply_immediately             = true
  parameter_group_name          = aws_elasticache_parameter_group.main.name
  subnet_group_name             = aws_elasticache_subnet_group.main.name
  security_group_ids            = [aws_security_group.redis.id]
  maintenance_window            = "sun:18:00-sun:19:00"
}
