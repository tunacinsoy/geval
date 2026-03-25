resource "aws_security_group" "resolver_endpoint" {
  name        = "${local.project_prefix}-resolver-sg-${var.environment}"
  description = "Allows UDP/TCP 53 from VPC and on-prem CIDRs"
  vpc_id      = aws_vpc.resolver_bridge.id
  tags        = merge(var.common_tags, { Name = "resolver-sg-${var.environment}" })

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.on_prem_cidr]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr, var.on_prem_cidr]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.on_prem_cidr]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr, var.on_prem_cidr]
  }
}
