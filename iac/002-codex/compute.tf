resource "aws_ecs_cluster" "hr_cluster" {
  name = "hr-documents-cluster"
}

resource "aws_ecs_task_definition" "hr_task" {
  family                   = "hr-documents"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execute.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  container_definitions = jsonencode([
    {
      name      = "hr-portal"
      image     = "public.ecr.aws/nginx/nginx:latest"
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.hr_app.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "hr-portal"
        }
      }
      environment = [
        {
          name  = "DOCUMENT_BUCKET"
          value = aws_s3_bucket.hr_documents.bucket
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "hr_service" {
  name            = "hr-document-service"
  cluster         = aws_ecs_cluster.hr_cluster.id
  desired_count   = var.desired_task_count
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.hr_task.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 75
  network_configuration {
    subnets         = aws_subnet.private[*].id
    security_groups = [aws_security_group.tasks.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.hr_targets.arn
    container_name   = "hr-portal"
    container_port   = 443
  }
  depends_on = [aws_lb_listener.https]
}

resource "aws_appautoscaling_target" "service" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.hr_cluster.name}/${aws_ecs_service.hr_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "hr-scale-up"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.service.resource_id
  scalable_dimension = aws_appautoscaling_target.service.scalable_dimension
  policy_type        = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
