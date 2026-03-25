resource "aws_ecs_cluster" "ingestion_cluster" {
  name = "ingestion-cluster-${var.environment}"
}

resource "aws_cloudwatch_log_group" "ecs_ingestion" {
  name              = "/ecs/ingestion-${var.environment}"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "ingestion_task" {
  family                   = "ingestion-task-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "spreadsheet-import"
      image     = "public.ecr.aws/amazonlinux/amazonlinux:2023"
      essential = true
      command   = ["/bin/sh", "-c", "echo Import placeholder; sleep 30"]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.aws_region
          awslogs-group         = aws_cloudwatch_log_group.ecs_ingestion.name
          awslogs-stream-prefix = "ingestion"
        }
      }
      healthCheck = {
        command     = ["CMD-SHELL", "exit 0"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 30
      }
    }
  ])
}

resource "aws_ecs_service" "ingestion_service" {
  name            = "ingestion-service-${var.environment}"
  cluster         = aws_ecs_cluster.ingestion_cluster.id
  launch_type     = "FARGATE"
  desired_count   = var.fargate_desired_count
  task_definition = aws_ecs_task_definition.ingestion_task.arn

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ingestion.id]
    assign_public_ip = false
  }

  depends_on = [aws_ecs_task_definition.ingestion_task]
}

resource "aws_lambda_function" "validation_function" {
  function_name = "validation-${var.environment}"
  filename      = "${path.module}/lambda/customer-ingestion.zip"
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  memory_size   = var.lambda_memory
  timeout       = var.lambda_timeout
  vpc_config {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [aws_security_group.lambda.id]
  }
  environment {
    variables = {
      DB_SECRET = aws_secretsmanager_secret.database_credentials.arn
    }
  }
}

resource "aws_cloudwatch_event_rule" "validation_schedule" {
  name                = "validation-schedule-${var.environment}"
  schedule_expression = "rate(1 hour)"
  description         = "Hourly guard rails for customer data"
}

resource "aws_cloudwatch_event_target" "validation_target" {
  rule      = aws_cloudwatch_event_rule.validation_schedule.name
  target_id = "validation-lambda-${var.environment}"
  arn       = aws_lambda_function.validation_function.arn
}

resource "aws_lambda_permission" "allow_events" {
  statement_id  = "AllowCloudWatchEvents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.validation_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.validation_schedule.arn
}
