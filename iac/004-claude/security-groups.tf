# Security Groups for database access control

# RDS Database Security Group
# Restricted to internal VPC access only - no internet access
resource "aws_security_group" "rds" {
  name_prefix = "rds-sg-${var.environment}-"
  description = "Security group for RDS PostgreSQL database - ${var.environment}"
  vpc_id      = aws_vpc.orders.id

  # Egress: Allow all outbound traffic (standard for databases)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "rds-sg-${var.environment}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# RDS Ingress: PostgreSQL from application security group
# Note: In production, replace with actual application security group reference
# For now, allow from VPC CIDR (to be restricted to app servers later)
resource "aws_vpc_security_group_ingress_rule" "rds_postgresql" {
  description       = "Allow PostgreSQL access from application servers"
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr
  security_group_id = aws_security_group.rds.id

  tags = merge(
    var.tags,
    {
      Name = "allow-postgresql-${var.environment}"
    }
  )
}

# Optional Bastion/Admin Security Group for future use
# Allows SSH and PostgreSQL connectivity for administrative access
resource "aws_security_group" "bastion" {
  name_prefix = "bastion-sg-${var.environment}-"
  description = "Security group for bastion/admin access - ${var.environment}"
  vpc_id      = aws_vpc.orders.id

  # Ingress: SSH from anywhere (restrict this in production!)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: Restrict this to your IP in production
    description = "SSH access (restrict in production)"
  }

  # Egress: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "bastion-sg-${var.environment}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Application Security Group (placeholder for external application servers)
# This represents the security group for application servers that will connect to RDS
resource "aws_security_group" "application" {
  name_prefix = "app-sg-${var.environment}-"
  description = "Security group for application servers - ${var.environment}"
  vpc_id      = aws_vpc.orders.id

  # Egress: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "app-sg-${var.environment}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Allow application security group to connect to RDS
resource "aws_vpc_security_group_ingress_rule" "rds_from_application" {
  description                  = "Allow PostgreSQL access from application security group"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.application.id
  security_group_id            = aws_security_group.rds.id

  tags = merge(
    var.tags,
    {
      Name = "allow-postgresql-from-app-${var.environment}"
    }
  )
}

# Allow bastion/admin access to RDS for troubleshooting
resource "aws_vpc_security_group_ingress_rule" "rds_from_bastion" {
  description                  = "Allow PostgreSQL access from bastion for administrative access"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.bastion.id
  security_group_id            = aws_security_group.rds.id

  tags = merge(
    var.tags,
    {
      Name = "allow-postgresql-from-bastion-${var.environment}"
    }
  )
}
