# IAM Roles and Policies

# ============================================================================
# Image Builder Service Role
# ============================================================================

resource "aws_iam_role" "imagebuilder_service" {
  name = "${var.project_name}-imagebuilder-service-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "imagebuilder.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-imagebuilder-service-role-${var.environment}"
  }
}

# Instance Profile for Image Builder EC2 instances
resource "aws_iam_instance_profile" "imagebuilder" {
  name = "${var.project_name}-imagebuilder-profile-${var.environment}"
  role = aws_iam_role.imagebuilder_service.name
}

# Image Builder Policy: S3 access, SNS publish, CloudWatch Logs
resource "aws_iam_role_policy" "imagebuilder" {
  name = "${var.project_name}-imagebuilder-policy"
  role = aws_iam_role.imagebuilder_service.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ImageRegistry"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-ami-registry-${var.environment}",
          "arn:aws:s3:::${var.project_name}-ami-registry-${var.environment}/*"
        ]
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/imagebuilder/*"
      },
      {
        Sid    = "SNSPublish"
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${var.project_name}-*"
      },
      {
        Sid    = "EC2ImageBuilder"
        Effect = "Allow"
        Action = [
          "ec2:CreateImage",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:CreateTags",
          "ec2:ModifyImageAttribute",
          "ec2:ModifySnapshotAttribute",
          "ec2:RunInstances",
          "ec2:TerminateInstances"
        ]
        Resource = "*"
      },
      {
        Sid    = "SSMAccess"
        Effect = "Allow"
        Action = [
          "ssm:GetAutomationExecution",
          "ssm:StartAutomationExecution",
          "ssm:GetParameters"
        ]
        Resource = "*"
      }
    ]
  })
}

# ============================================================================
# ASG Instance Role
# ============================================================================

resource "aws_iam_role" "asg_instance" {
  name = "${var.project_name}-asg-instance-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-asg-instance-role-${var.environment}"
  }
}

resource "aws_iam_instance_profile" "asg_instance" {
  name = "${var.project_name}-asg-instance-profile-${var.environment}"
  role = aws_iam_role.asg_instance.name
}

# ASG Instance Policy: S3 read (image registry), CloudWatch Logs write
resource "aws_iam_role_policy" "asg_instance" {
  name = "${var.project_name}-asg-instance-policy"
  role = aws_iam_role.asg_instance.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ImageRegistryRead"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-ami-registry-${var.environment}",
          "arn:aws:s3:::${var.project_name}-ami-registry-${var.environment}/*"
        ]
      },
      {
        Sid    = "CloudWatchLogsWrite"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/applicationinstances/*"
      },
      {
        Sid    = "EC2Describe"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

# ============================================================================
# CI/CD Deployment Role (for terraform operations)
# ============================================================================

resource "aws_iam_role" "cicd_deployment" {
  name = "${var.project_name}-cicd-deployment-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-cicd-deployment-role-${var.environment}"
  }
}

# CI/CD Policy: Terraform state management
resource "aws_iam_role_policy" "cicd_deployment" {
  name = "${var.project_name}-cicd-deployment-policy"
  role = aws_iam_role.cicd_deployment.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "TerraformState"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-terraform-state",
          "arn:aws:s3:::${var.project_name}-terraform-state/*"
        ]
      },
      {
        Sid    = "DynamoDBLock"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.project_name}-terraform-lock"
      },
      {
        Sid    = "IAMPassRole"
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [
          aws_iam_role.imagebuilder_service.arn,
          aws_iam_role.asg_instance.arn
        ]
      }
    ]
  })
}

# ============================================================================
# Monitoring/Audit Role (read-only access)
# ============================================================================

resource "aws_iam_role" "monitoring_audit" {
  name = "${var.project_name}-monitoring-audit-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-monitoring-audit-role-${var.environment}"
  }
}

# Monitoring/Audit Policy: Read-only access to logs and audit buckets
resource "aws_iam_role_policy" "monitoring_audit" {
  name = "${var.project_name}-monitoring-audit-policy"
  role = aws_iam_role.monitoring_audit.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchLogsRead"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:ListLogDeliveries"
        ]
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Sid    = "S3AuditLogsRead"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-audit-logs-${var.environment}",
          "arn:aws:s3:::${var.project_name}-audit-logs-${var.environment}/*"
        ]
      }
    ]
  })
}
