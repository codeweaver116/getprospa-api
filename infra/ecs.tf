
resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.stack["api"]}-task-${var.environment["qa"]}"

  tags = {
    Name        = "${var.stack["api"]}-task-${var.environment["qa"]}"
    Environment = var.environment["qa"]
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.stack["api"]}-task-${var.environment["qa"]}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "getprospa-${var.stack["api"]}-container-${var.environment["qa"]}"
    image     = "${var.stack["api"]}_${var.environment["qa"]}:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port,

    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
    },


    {
      essential = true,
      image     = "amazon/aws-for-fluent-bit:stable"
      name      = "log_router"
      firelensConfiguration = {
        type = "fluentbit"
        options = { enable-ecs-log-metadata = "true"
        }
      }

      logConfiguration = {
        logDriver = "awsfirelens"
        options = {
          Name           = "datadog"
          apikey         = data.aws_ssm_parameter.datadogs_key.value
          Host           = "http-intake.logs.datadoghq.com"
          dd_service     = "geprospa-${var.stack["api"]}-${var.environment["qa"]}"
          dd_source      = "geprospa-${var.stack["api"]}-backnend${var.environment["qa"]}"
          dd_message_key = "log"
          dd_tags        = "env:dev, Stack:api, Source:api-backend"
          TLS            = "on"
          provider       = "ecs"
        }
      }
    }



  ])

  tags = {
    Name        = "${var.stack["api"]}-task-${var.environment["qa"]}"
    Environment = var.environment["qa"]
  }
}

resource "aws_ecs_cluster" "main" {
  name = "getprospa-cluster-${var.environment["qa"]}"
  tags = {
    Name        = "${var.stack["api"]}-cluster-${var.environment["qa"]}"
    Environment = var.environment["qa"]
  }
}

resource "aws_ecs_service" "main" {
  name                               = "getprospa-${var.stack["api"]}-service-${var.environment["qa"]}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.service_desired_count["qa"]
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "getprospa-${var.stack["api"]}-container-${var.environment["qa"]}"
    container_port   = var.container_port
  }

  # we ignore task_definition changes as the revision changes on deploy
  # of a new version of the application
  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}