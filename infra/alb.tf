resource "aws_lb" "main" {
  name               = "${var.stack["api"]}-alb-${var.environment["qa"]}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.subnets.*.id

  enable_deletion_protection = false

  tags = {
    Name        = "${var.stack["api"]}-alb-${var.environment["qa"]}"
    Environment = var.environment["qa"]
  }
}

resource "aws_alb_target_group" "main" {
  name        = "${var.stack["api"]}-tg-${var.environment["qa"]}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.stack["api"]}-tg-${var.environment["qa"]}"
    Environment = var.environment["qa"]
  }
}

# Redirect to https listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

   default_action {
        target_group_arn = aws_alb_target_group.main.id
        type             = "forward"
    }
}

# # Redirect traffic to target group [redirection on possible with ssl certificate which i cant afford now]
# resource "aws_alb_listener" "https" {
#     load_balancer_arn = aws_lb.main.id
#     port              = 443
#     protocol          = "HTTPS"

#     ssl_policy        = "ELBSecurityPolicy-2016-08"
#     certificate_arn   = var.alb_tls_cert_arn["qa"]

#     default_action {
#         target_group_arn = aws_alb_target_group.main.id
#         type             = "forward"
#     }
# }
