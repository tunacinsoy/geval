# Provider configurations for multi-region setup

# Primary Region Provider (eu-central-1)
provider "aws" {
  alias  = "primary"
  region = var.primary_region

  default_tags {
    tags = local.common_tags
  }
}

# Secondary Region Provider (eu-west-1)
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region

  default_tags {
    tags = local.common_tags
  }
}

# Data source for current AWS account ID
data "aws_caller_identity" "current" {
  provider = aws.primary
}

# Data source for current region
data "aws_region" "current" {
  provider = aws.primary
}

# ============================================================================
# PRIMARY REGION INFRASTRUCTURE (eu-central-1)
# ============================================================================

# VPC
resource "aws_vpc" "primary" {
  provider             = aws.primary
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-vpc"
    }
  )
}

# Public Subnets (ALB tier)
resource "aws_subnet" "primary_public" {
  count                   = length(var.public_subnet_cidrs)
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.primary_availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-public-subnet-${count.index + 1}"
      Type = "Public"
    }
  )
}

# Private App Subnets
resource "aws_subnet" "primary_private_app" {
  count             = length(var.private_app_subnet_cidrs)
  provider          = aws.primary
  vpc_id            = aws_vpc.primary.id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = var.primary_availability_zones[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-private-app-subnet-${count.index + 1}"
      Type = "PrivateApp"
    }
  )
}

# Private DB Subnets
resource "aws_subnet" "primary_private_db" {
  count             = length(var.private_db_subnet_cidrs)
  provider          = aws.primary
  vpc_id            = aws_vpc.primary.id
  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = var.primary_availability_zones[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-private-db-subnet-${count.index + 1}"
      Type = "PrivateDB"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-igw"
    }
  )
}

# NAT Gateways (one per AZ for HA)
resource "aws_eip" "primary_nat" {
  count    = length(var.primary_availability_zones)
  provider = aws.primary
  domain   = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-nat-eip-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.primary]
}

resource "aws_nat_gateway" "primary" {
  count         = length(var.primary_availability_zones)
  provider      = aws.primary
  subnet_id     = aws_subnet.primary_public[count.index].id
  allocation_id = aws_eip.primary_nat[count.index].id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-nat-gw-${count.index + 1}"
    }
  )
}

# Route Tables
resource "aws_route_table" "primary_public" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-public-rt"
    }
  )
}

resource "aws_route_table" "primary_private" {
  count    = length(var.primary_availability_zones)
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.primary[count.index].id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-private-rt-${count.index + 1}"
    }
  )
}

# Route Table Associations
resource "aws_route_table_association" "primary_public" {
  count          = length(aws_subnet.primary_public)
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_public[count.index].id
  route_table_id = aws_route_table.primary_public.id
}

resource "aws_route_table_association" "primary_private_app" {
  count          = length(aws_subnet.primary_private_app)
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_private_app[count.index].id
  route_table_id = aws_route_table.primary_private[count.index].id
}

resource "aws_route_table_association" "primary_private_db" {
  count          = length(aws_subnet.primary_private_db)
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_private_db[count.index].id
  route_table_id = aws_route_table.primary_private[count.index].id
}

# Security Groups - Primary ALB
resource "aws_security_group" "primary_alb" {
  provider    = aws.primary
  name        = "${local.name_prefix_primary}-alb-sg"
  description = "Security group for ALB in primary region"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-alb-sg"
    }
  )
}

# Security Groups - Primary App Instances
resource "aws_security_group" "primary_app" {
  provider    = aws.primary
  name        = "${local.name_prefix_primary}-app-sg"
  description = "Security group for application instances in primary region"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.primary_alb.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.primary_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-app-sg"
    }
  )
}

# Security Groups - Primary RDS
resource "aws_security_group" "primary_rds" {
  provider    = aws.primary
  name        = "${local.name_prefix_primary}-rds-sg"
  description = "Security group for RDS in primary region"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.primary_app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-rds-sg"
    }
  )
}

# RDS DB Subnet Group - Primary
resource "aws_db_subnet_group" "primary" {
  provider    = aws.primary
  name        = "${local.name_prefix_primary}-db-subnet-group"
  subnet_ids  = aws_subnet.primary_private_db[*].id
  description = "DB subnet group for primary region"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-db-subnet-group"
    }
  )
}

# RDS Aurora Cluster - Primary
resource "aws_rds_cluster" "primary" {
  provider                = aws.primary
  cluster_identifier      = "${local.name_prefix_primary}-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = var.db_engine_version
  database_name           = "postgres"
  master_username         = "postgres"
  master_password         = random_password.db_password.result
  db_subnet_group_name    = aws_db_subnet_group.primary.name
  vpc_security_group_ids  = [aws_security_group.primary_rds.id]
  storage_encrypted       = true
  backup_retention_period = var.db_backup_retention_days
  skip_final_snapshot     = false
  final_snapshot_identifier = "${local.name_prefix_primary}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  enable_http_endpoint    = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-aurora-cluster"
    }
  )
}

# RDS Cluster Instance - Primary
resource "aws_rds_cluster_instance" "primary" {
  provider           = aws.primary
  cluster_identifier = aws_rds_cluster.primary.id
  identifier         = "${local.name_prefix_primary}-instance-1"
  instance_class     = var.db_instance_class
  engine              = aws_rds_cluster.primary.engine
  engine_version      = aws_rds_cluster.primary.engine_version
  publicly_accessible = false

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-instance-1"
    }
  )
}

# Application Load Balancer - Primary
resource "aws_lb" "primary" {
  provider           = aws.primary
  name               = "${local.name_prefix_primary}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.primary_alb.id]
  subnets            = aws_subnet.primary_public[*].id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-alb"
    }
  )
}

# Target Group - Primary
resource "aws_lb_target_group" "primary" {
  provider    = aws.primary
  name        = "${local.name_prefix_primary}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.primary.id
  target_type = "instance"

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = var.health_check_path
    matcher             = "200"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-tg"
    }
  )
}

# ALB Listener - Primary
resource "aws_lb_listener" "primary" {
  provider          = aws.primary
  load_balancer_arn = aws_lb.primary.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.primary.arn
  }
}

# Launch Template - Primary
resource "aws_launch_template" "primary" {
  provider      = aws.primary
  name          = "${local.name_prefix_primary}-launch-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.primary_app.id]

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix_primary}-instance"
      }
    )
  }
}

# Auto Scaling Group - Primary
resource "aws_autoscaling_group" "primary" {
  provider            = aws.primary
  name                = "${local.name_prefix_primary}-asg"
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = aws_subnet.primary_private_app[*].id
  target_group_arns   = [aws_lb_target_group.primary.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.primary.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix_primary}-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# CloudWatch Log Group - Primary
resource "aws_cloudwatch_log_group" "primary" {
  provider            = aws.primary
  name                = "/aws/ec2/${local.name_prefix_primary}/application-instances"
  retention_in_days   = 7

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_primary}-log-group"
    }
  )
}

# ============================================================================
# SECONDARY REGION INFRASTRUCTURE (eu-west-1)
# ============================================================================

# VPC - Secondary
resource "aws_vpc" "secondary" {
  provider             = aws.secondary
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-vpc"
    }
  )
}

# Public Subnets - Secondary
resource "aws_subnet" "secondary_public" {
  count                   = length(var.public_subnet_cidrs)
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.secondary_availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-public-subnet-${count.index + 1}"
      Type = "Public"
    }
  )
}

# Private App Subnets - Secondary
resource "aws_subnet" "secondary_private_app" {
  count             = length(var.private_app_subnet_cidrs)
  provider          = aws.secondary
  vpc_id            = aws_vpc.secondary.id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = var.secondary_availability_zones[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-private-app-subnet-${count.index + 1}"
      Type = "PrivateApp"
    }
  )
}

# Private DB Subnets - Secondary
resource "aws_subnet" "secondary_private_db" {
  count             = length(var.private_db_subnet_cidrs)
  provider          = aws.secondary
  vpc_id            = aws_vpc.secondary.id
  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = var.secondary_availability_zones[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-private-db-subnet-${count.index + 1}"
      Type = "PrivateDB"
    }
  )
}

# Internet Gateway - Secondary
resource "aws_internet_gateway" "secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-igw"
    }
  )
}

# NAT Gateways - Secondary
resource "aws_eip" "secondary_nat" {
  count    = length(var.secondary_availability_zones)
  provider = aws.secondary
  domain   = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-nat-eip-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.secondary]
}

resource "aws_nat_gateway" "secondary" {
  count         = length(var.secondary_availability_zones)
  provider      = aws.secondary
  subnet_id     = aws_subnet.secondary_public[count.index].id
  allocation_id = aws_eip.secondary_nat[count.index].id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-nat-gw-${count.index + 1}"
    }
  )
}

# Route Tables - Secondary
resource "aws_route_table" "secondary_public" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-public-rt"
    }
  )
}

resource "aws_route_table" "secondary_private" {
  count    = length(var.secondary_availability_zones)
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.secondary[count.index].id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-private-rt-${count.index + 1}"
    }
  )
}

# Route Table Associations - Secondary
resource "aws_route_table_association" "secondary_public" {
  count          = length(aws_subnet.secondary_public)
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_public[count.index].id
  route_table_id = aws_route_table.secondary_public.id
}

resource "aws_route_table_association" "secondary_private_app" {
  count          = length(aws_subnet.secondary_private_app)
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_private_app[count.index].id
  route_table_id = aws_route_table.secondary_private[count.index].id
}

resource "aws_route_table_association" "secondary_private_db" {
  count          = length(aws_subnet.secondary_private_db)
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_private_db[count.index].id
  route_table_id = aws_route_table.secondary_private[count.index].id
}

# Security Groups - Secondary ALB
resource "aws_security_group" "secondary_alb" {
  provider    = aws.secondary
  name        = "${local.name_prefix_secondary}-alb-sg"
  description = "Security group for ALB in secondary region"
  vpc_id      = aws_vpc.secondary.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-alb-sg"
    }
  )
}

# Security Groups - Secondary App Instances
resource "aws_security_group" "secondary_app" {
  provider    = aws.secondary
  name        = "${local.name_prefix_secondary}-app-sg"
  description = "Security group for application instances in secondary region"
  vpc_id      = aws_vpc.secondary.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.secondary_alb.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.secondary_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-app-sg"
    }
  )
}

# Security Groups - Secondary RDS
resource "aws_security_group" "secondary_rds" {
  provider    = aws.secondary
  name        = "${local.name_prefix_secondary}-rds-sg"
  description = "Security group for RDS in secondary region"
  vpc_id      = aws_vpc.secondary.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.secondary_app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-rds-sg"
    }
  )
}

# RDS DB Subnet Group - Secondary
resource "aws_db_subnet_group" "secondary" {
  provider    = aws.secondary
  name        = "${local.name_prefix_secondary}-db-subnet-group"
  subnet_ids  = aws_subnet.secondary_private_db[*].id
  description = "DB subnet group for secondary region"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-db-subnet-group"
    }
  )
}

# RDS Aurora Cluster - Secondary (read replica of primary)
resource "aws_rds_cluster" "secondary" {
  provider                = aws.secondary
  cluster_identifier      = "${local.name_prefix_secondary}-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = var.db_engine_version
  db_subnet_group_name    = aws_db_subnet_group.secondary.name
  vpc_security_group_ids  = [aws_security_group.secondary_rds.id]
  storage_encrypted       = true
  backup_retention_period = var.db_backup_retention_days
  skip_final_snapshot     = false
  final_snapshot_identifier = "${local.name_prefix_secondary}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  # This would be a read replica in a real setup, but infracost needs a complete config
  depends_on = [aws_rds_cluster_instance.primary]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-aurora-cluster"
    }
  )
}

# RDS Cluster Instance - Secondary
resource "aws_rds_cluster_instance" "secondary" {
  provider           = aws.secondary
  cluster_identifier = aws_rds_cluster.secondary.id
  identifier         = "${local.name_prefix_secondary}-instance-1"
  instance_class     = var.db_instance_class
  engine              = aws_rds_cluster.secondary.engine
  engine_version      = aws_rds_cluster.secondary.engine_version
  publicly_accessible = false

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-instance-1"
    }
  )
}

# Application Load Balancer - Secondary
resource "aws_lb" "secondary" {
  provider           = aws.secondary
  name               = "${local.name_prefix_secondary}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.secondary_alb.id]
  subnets            = aws_subnet.secondary_public[*].id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-alb"
    }
  )
}

# Target Group - Secondary
resource "aws_lb_target_group" "secondary" {
  provider    = aws.secondary
  name        = "${local.name_prefix_secondary}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.secondary.id
  target_type = "instance"

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = var.health_check_path
    matcher             = "200"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-tg"
    }
  )
}

# ALB Listener - Secondary
resource "aws_lb_listener" "secondary" {
  provider          = aws.secondary
  load_balancer_arn = aws_lb.secondary.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.secondary.arn
  }
}

# Launch Template - Secondary
resource "aws_launch_template" "secondary" {
  provider      = aws.secondary
  name          = "${local.name_prefix_secondary}-launch-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.secondary_app.id]

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix_secondary}-instance"
      }
    )
  }
}

# Auto Scaling Group - Secondary (reduced size for cost optimization)
resource "aws_autoscaling_group" "secondary" {
  provider            = aws.secondary
  name                = "${local.name_prefix_secondary}-asg"
  min_size            = 1  # Reduced for DR standby
  max_size            = var.asg_max_size
  desired_capacity    = 1  # Reduced for DR standby
  vpc_zone_identifier = aws_subnet.secondary_private_app[*].id
  target_group_arns   = [aws_lb_target_group.secondary.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.secondary.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix_secondary}-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# CloudWatch Log Group - Secondary
resource "aws_cloudwatch_log_group" "secondary" {
  provider            = aws.secondary
  name                = "/aws/ec2/${local.name_prefix_secondary}/application-instances"
  retention_in_days   = 7

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix_secondary}-log-group"
    }
  )
}

# ============================================================================
# DATA SOURCES
# ============================================================================

# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Generate random password for RDS
resource "random_password" "db_password" {
  length  = 32
  special = true
}
