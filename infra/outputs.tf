output "alb" {
  value = aws_security_group.alb.id
}

output "ecs_tasks" {
  value = aws_security_group.ecs_tasks.id
}

output "aws_ecr_repository_url" {
    value = aws_ecr_repository.main.repository_url
}
output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.main.arn
}