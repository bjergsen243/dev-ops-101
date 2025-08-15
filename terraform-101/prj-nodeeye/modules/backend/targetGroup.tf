# ALB
resource "aws_lb_target_group" "main_alb_tg" {
  name                 = "RestAPI"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc.id
  target_type          = "ip"
  deregistration_delay = 5

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    interval            = 10
    port                = 8080
    protocol            = "HTTP"
    path                = "/healthcheck"
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.main_alb
  ]
}
