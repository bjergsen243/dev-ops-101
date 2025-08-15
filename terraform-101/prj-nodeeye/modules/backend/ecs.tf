# Cluster
resource "aws_ecs_cluster" "main_cluster" {
  name = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-cluster"
}

# Task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = lower(lookup(var.common, "customer"))
  requires_compatibilities = ["FARGATE"]

  cpu    = terraform.workspace == "prod" ? "2048" : "1024"
  memory = terraform.workspace == "prod" ? "4096" : "2048"

  network_mode = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "application",
    "image": "${aws_ecr_repository.application.repository_url}:latest",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}",
        "awslogs-stream-prefix": "logs",
        "awslogs-group": "${aws_cloudwatch_log_group.application.name}"
      }
    },
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "cpu": ${terraform.workspace == "prod" ? 2048 : 1024},
    "memory": ${terraform.workspace == "prod" ? 4096 : 2048},
    "command": ["sh", "run.sh"],
    "environment": [
      {
        "name": "GOLANG_PROTOBUF_REGISTRATION_CONFLICT",
        "value": "warn"
      }
    ]
  }
]
TASK_DEFINITION

  #   volume {
  #     name = "credentials_storage"

  #     efs_volume_configuration {
  #       file_system_id     = aws_efs_file_system.efs_credentials.id
  #       root_directory     = "/"
  #       transit_encryption = "ENABLED"
  #       authorization_config {
  #         access_point_id = aws_efs_access_point.efs_credentials_access_point.id
  #         iam             = "ENABLED"
  #       }
  #     }
  #   }
}

resource "aws_ecs_task_definition" "task_definition_migration" {
  family                   = "${lower(lookup(var.common, "customer"))}-migration"
  requires_compatibilities = ["FARGATE"]

  cpu    = "1024"
  memory = "2048"

  network_mode = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<TASK_DEFINITION_MIGRATION
[
  {
    "name": "application",
    "image": "${aws_ecr_repository.application-migration.repository_url}:latest",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}",
        "awslogs-stream-prefix": "logs",
        "awslogs-group": "${aws_cloudwatch_log_group.application_migration.name}"
      }
    },
    "portMappings": [],
    "cpu": 1024,
    "memory": 2048,
    "command": [],
    "environment": [],
    "secrets": [
      {
          "name": "APP_NAME",
          "valueFrom": "/Api-Zwwgvf:APP_NAME::"
      },
      {
          "name": "APP_ENV",
          "valueFrom": "/Api-Zwwgvf:APP_ENV::"
      },
      {
          "name": "APP_KEY",
          "valueFrom": "/Api-Zwwgvf:APP_KEY::"
      },
      {
          "name": "APP_DEBUG",
          "valueFrom": "/Api-Zwwgvf:APP_DEBUG::"
      },
      {
          "name": "APP_URL",
          "valueFrom": "/Api-Zwwgvf:APP_URL::"
      },
      {
          "name": "APP_HOST",
          "valueFrom": "/Api-Zwwgvf:APP_HOST::"
      },
      {
          "name": "APP_PORT",
          "valueFrom": "/Api-Zwwgvf:APP_PORT::"
      },
      {
          "name": "LOG_CHANNEL",
          "valueFrom": "/Api-Zwwgvf:LOG_CHANNEL::"
      },
      {
          "name": "LOG_LEVEL",
          "valueFrom": "/Api-Zwwgvf:LOG_LEVEL::"
      },
      {
          "name": "DB_CONNECTION",
          "valueFrom": "/Api-Zwwgvf:DB_CONNECTION::"
      },
      {
          "name": "DB_HOST",
          "valueFrom": "/Api-Zwwgvf:DB_HOST::"
      },
      {
          "name": "DB_PORT",
          "valueFrom": "/Api-Zwwgvf:DB_PORT::"
      },
      {
          "name": "DB_DATABASE",
          "valueFrom": "/Api-Zwwgvf:DB_DATABASE::"
      },
      {
          "name": "DB_USERNAME",
          "valueFrom": "/Api-Zwwgvf:DB_USERNAME::"
      },
      {
          "name": "DB_PASSWORD",
          "valueFrom": "/Api-Zwwgvf:DB_PASSWORD::"
      },
      {
          "name": "AWS_ACCESS_KEY_ID",
          "valueFrom": "/Api-Zwwgvf:AWS_ACCESS_KEY_ID::"
      },
      {
          "name": "AWS_SECRET_ACCESS_KEY",
          "valueFrom": "/Api-Zwwgvf:AWS_SECRET_ACCESS_KEY::"
      },
      {
          "name": "AWS_REGION",
          "valueFrom": "/Api-Zwwgvf:AWS_REGION::"
      },
      {
          "name": "AWS_COGNITO_CLIENT_ID",
          "valueFrom": "/Api-Zwwgvf:AWS_COGNITO_CLIENT_ID::"
      },
      {
          "name": "AWS_COGNITO_USER_POOL_ID",
          "valueFrom": "/Api-Zwwgvf:AWS_COGNITO_USER_POOL_ID::"
      },
      {
          "name": "AWS_S3_BUCKET",
          "valueFrom": "/Api-Zwwgvf:AWS_S3_BUCKET::"
      },
      {
          "name": "AWS_S3_REGION",
          "valueFrom": "/Api-Zwwgvf:AWS_S3_REGION::"
      },
      {
          "name": "MAIL_HOST",
          "valueFrom": "/Api-Zwwgvf:MAIL_HOST::"
      },
      {
          "name": "MAIL_PORT",
          "valueFrom": "/Api-Zwwgvf:MAIL_PORT::"
      },
      {
          "name": "MAIL_USERNAME",
          "valueFrom": "/Api-Zwwgvf:MAIL_USERNAME::"
      },
      {
          "name": "MAIL_PASSWORD",
          "valueFrom": "/Api-Zwwgvf:MAIL_PASSWORD::"
      },
      {
          "name": "MAIL_FROM_ADDRESS",
          "valueFrom": "/Api-Zwwgvf:MAIL_FROM_ADDRESS::"
      },
      {
          "name": "WEB_URL",
          "valueFrom": "/Api-Zwwgvf:WEB_URL::"
      },
      {
          "name": "REDIS_HOST",
          "valueFrom": "/Api-Zwwgvf:REDIS_HOST::"
      },
      {
          "name": "EMAIL_SHIMZ",
          "valueFrom": "/Api-Zwwgvf:EMAIL_SHIMZ::"
      },
      {
          "name": "AWS_COGNITO_SSO_CLIENT_ID",
          "valueFrom": "/Api-Zwwgvf:AWS_COGNITO_SSO_CLIENT_ID::"
      },
      {
          "name": "AWS_COGNITO_SSO_CLIENT_SECRET",
          "valueFrom": "/Api-Zwwgvf:AWS_COGNITO_SSO_CLIENT_SECRET::"
      },
      {
          "name": "AWS_COGNITO_SSO_CALLBACK_URL",
          "valueFrom": "/Api-Zwwgvf:AWS_COGNITO_SSO_CALLBACK_URL::"
      },
      {
          "name": "AWS_COGNITO_SSO_ENDPOINT",
          "valueFrom": "/Api-Zwwgvf:AWS_COGNITO_SSO_ENDPOINT::"
      }
    ]
  }
]
TASK_DEFINITION_MIGRATION

  #   volume {
  #     name = "credentials_storage"

  #     efs_volume_configuration {
  #       file_system_id     = aws_efs_file_system.efs_credentials.id
  #       root_directory     = "/"
  #       transit_encryption = "ENABLED"
  #       authorization_config {
  #         access_point_id = aws_efs_access_point.efs_credentials_access_point.id
  #         iam             = "ENABLED"
  #       }
  #     }
  #   }
}

# Service
resource "aws_ecs_service" "service" {
  name                   = lower(lookup(var.common, "customer"))
  cluster                = aws_ecs_cluster.main_cluster.id
  task_definition        = "${aws_ecs_task_definition.task_definition.family}:${max(aws_ecs_task_definition.task_definition.revision, data.aws_ecs_task_definition.task_definition.revision)}"
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"
  enable_execute_command = true

  network_configuration {
    security_groups = [aws_security_group.fargate.id]
    subnets         = [aws_subnet.private_a.id, aws_subnet.private_c.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main_alb_tg.arn
    container_name   = "application"
    container_port   = 8080
  }
}

data "aws_caller_identity" "current" {}

data "aws_ecs_task_definition" "task_definition" {
  task_definition = aws_ecs_task_definition.task_definition.family
}
