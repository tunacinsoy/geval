# IAM Roles and Policies for Infrastructure Management

# ========================================
# Terraform Executor Role (for CI/CD)
# ========================================

resource "aws_iam_role" "terraform_executor" {
  name_prefix = "terraform-executor-${var.environment}-"
  description = "Role for Terraform to manage infrastructure - ${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
          # Add additional principals for CI/CD services:
          # AWS       = "arn:aws:iam::ACCOUNT_ID:role/GitHubActionsRole"
          # AWS       = "arn:aws:iam::ACCOUNT_ID:role/GitLabRunnerRole"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "terraform-executor-${var.environment}"
    }
  )
}

# Policy for Terraform to manage RDS resources
resource "aws_iam_role_policy" "terraform_rds" {
  name_prefix = "terraform-rds-${var.environment}-"
  role        = aws_iam_role.terraform_executor.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:ModifyDBInstance",
          "rds:DescribeDBInstances",
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup",
          "rds:DescribeDBSubnetGroups",
          "rds:CreateDBSnapshot",
          "rds:DescribeDBSnapshots",
          "rds:ListTagsForResource",
          "rds:AddTagsToResource",
          "rds:RemoveTagsFromResource",
          "rds:DescribeDBParameters",
          "rds:ModifyDBParameterGroup",
          "rds:CreateDBParameterGroup",
          "rds:DeleteDBParameterGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

# Policy for Terraform to manage VPC and networking
resource "aws_iam_role_policy" "terraform_vpc" {
  name_prefix = "terraform-vpc-${var.environment}-"
  role        = aws_iam_role.terraform_executor.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:DescribeVpcs",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:DescribeSubnets",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:DescribeRouteTables",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway",
          "ec2:DescribeInternetGateways",
          "ec2:CreateFlowLogs",
          "ec2:DescribeFlowLogs",
          "ec2:DeleteFlowLogs",
          "ec2:DescribeTags",
          "ec2:CreateTags"
        ]
        Resource = "*"
      }
    ]
  })
}

# Policy for Terraform to manage Secrets Manager
resource "aws_iam_role_policy" "terraform_secrets" {
  name_prefix = "terraform-secrets-${var.environment}-"
  role        = aws_iam_role.terraform_executor.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecret",
          "secretsmanager:TagResource",
          "secretsmanager:UntagResource",
          "secretsmanager:RotateSecret",
          "secretsmanager:UpdateSecretVersionStage"
        ]
        Resource = "*"
      }
    ]
  })
}

# Policy for Terraform to manage CloudWatch
resource "aws_iam_role_policy" "terraform_cloudwatch" {
  name_prefix = "terraform-cloudwatch-${var.environment}-"
  role        = aws_iam_role.terraform_executor.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:ListMetrics",
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:DescribeLogGroups",
          "logs:PutRetentionPolicy",
          "monitoring:GetMetricStatistics"
        ]
        Resource = "*"
      }
    ]
  })
}

# Policy for Terraform to manage IAM
resource "aws_iam_role_policy" "terraform_iam" {
  name_prefix = "terraform-iam-${var.environment}-"
  role        = aws_iam_role.terraform_executor.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:ListRoles",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRolePolicy",
          "iam:ListRolePolicies",
          "iam:UpdateAssumeRolePolicy",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile"
        ]
        Resource = "*"
      }
    ]
  })
}

# ========================================
# Application Server Role
# ========================================

resource "aws_iam_role" "application" {
  name_prefix = "application-${var.environment}-"
  description = "Role for application servers to access database credentials - ${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "application-${var.environment}"
    }
  )
}

# Policy for application servers to read database credentials from Secrets Manager
resource "aws_iam_role_policy" "application_secrets" {
  name_prefix = "application-secrets-${var.environment}-"
  role        = aws_iam_role.application.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.db_password.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

# Instance Profile for application servers
resource "aws_iam_instance_profile" "application" {
  name_prefix = "application-profile-${var.environment}-"
  role        = aws_iam_role.application.name
}

# ========================================
# RDS Enhanced Monitoring Role
# ========================================

resource "aws_iam_role" "rds_monitoring" {
  name_prefix = "rds-monitoring-${var.environment}-"
  description = "Role for RDS Enhanced Monitoring to CloudWatch - ${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "rds-monitoring-${var.environment}"
    }
  )
}

# Policy for RDS to write Enhanced Monitoring metrics to CloudWatch
resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
