# ALB
resource "aws_lb_listener" "alb_http_listener" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.main_alb.arn

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_https_listener" {
  port              = 443
  protocol          = "HTTPS"
  load_balancer_arn = aws_lb.main_alb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn // ACM

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_alb_tg.arn
  }
}

resource "aws_lb" "main_alb" {
  name               = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-alb"
  security_groups    = [aws_security_group.alb.id]
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]
  tags = {
    Name = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-alb"
  }
}
