
#########
## ECS
#########
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "EcsTaskExecution${lower(lookup(var.common, "customer"))}${lower(terraform.workspace)}Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_system_manager_policy" {
  name = "ECSSystemsManagerPolicy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${lookup(var.common, "${terraform.workspace}.region")}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ecs/*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:secretsmanager:${lookup(var.common, "${terraform.workspace}.region")}:${data.aws_caller_identity.current.account_id}:secret:*",
                "arn:aws:kms:${lookup(var.common, "${terraform.workspace}.region")}:${data.aws_caller_identity.current.account_id}:key/*"
            ]
        }
    ]
}
POLICY
}
