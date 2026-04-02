# VPC and Networking Infrastructure

# Primary VPC for infrastructure isolation
resource "aws_vpc" "orders" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "orders-vpc-${var.environment}"
    }
  )
}

# Primary database subnet in us-east-1a
resource "aws_subnet" "database_primary" {
  vpc_id                  = aws_vpc.orders.id
  cidr_block              = var.database_subnet_1_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "database-subnet-primary-${var.environment}"
    }
  )
}

# Secondary database subnet in us-east-1b for Multi-AZ failover
resource "aws_subnet" "database_secondary" {
  vpc_id                  = aws_vpc.orders.id
  cidr_block              = var.database_subnet_2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "database-subnet-secondary-${var.environment}"
    }
  )
}

# RDS DB Subnet Group for database placement
resource "aws_db_subnet_group" "orders" {
  name_prefix = "orders-db-subnet-${var.environment}-"
  description = "Database subnet group for orders database - ${var.environment}"
  subnet_ids  = [aws_subnet.database_primary.id, aws_subnet.database_secondary.id]

  tags = merge(
    var.tags,
    {
      Name = "orders-db-subnet-group-${var.environment}"
    }
  )
}

# Internet Gateway for future bastion/NAT access (not used directly by RDS)
resource "aws_internet_gateway" "orders" {
  vpc_id = aws_vpc.orders.id

  tags = merge(
    var.tags,
    {
      Name = "orders-igw-${var.environment}"
    }
  )
}

# Route table for VPC local routes
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.orders.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = merge(
    var.tags,
    {
      Name = "private-rt-${var.environment}"
    }
  )
}

# Associate primary database subnet with route table
resource "aws_route_table_association" "database_primary" {
  subnet_id      = aws_subnet.database_primary.id
  route_table_id = aws_route_table.private.id
}

# Associate secondary database subnet with route table
resource "aws_route_table_association" "database_secondary" {
  subnet_id      = aws_subnet.database_secondary.id
  route_table_id = aws_route_table.private.id
}

# VPC Flow Logs for security auditing (optional but recommended)
resource "aws_flow_log" "vpc_log" {
  count           = var.environment == "prod" ? 1 : 0
  iam_role_arn    = aws_iam_role.vpc_flow_logs[0].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.orders.id

  tags = merge(
    var.tags,
    {
      Name = "vpc-flow-logs-${var.environment}"
    }
  )
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count             = var.environment == "prod" ? 1 : 0
  name              = "/aws/vpc/flowlogs/orders-${var.environment}"
  retention_in_days = 30

  tags = merge(
    var.tags,
    {
      Name = "vpc-flow-logs-group-${var.environment}"
    }
  )
}

# IAM role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs" {
  count = var.environment == "prod" ? 1 : 0
  name  = "vpc-flow-logs-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# IAM policy for VPC Flow Logs
resource "aws_iam_role_policy" "vpc_flow_logs" {
  count = var.environment == "prod" ? 1 : 0
  name  = "vpc-flow-logs-policy-${var.environment}"
  role  = aws_iam_role.vpc_flow_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}
