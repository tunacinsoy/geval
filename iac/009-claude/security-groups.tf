# Security groups for Route 53 Resolver endpoints

# Security group for inbound resolver endpoint
# Receives DNS queries from on-premises network and VPC
resource "aws_security_group" "inbound_endpoint" {
  name        = "route53-resolver-inbound-${var.environment}"
  description = "Security group for Route 53 Resolver inbound endpoint"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "route53-resolver-inbound-${var.environment}"
  }
}

# Inbound: Allow DNS queries from on-premises network (UDP/TCP 53)
resource "aws_vpc_security_group_ingress_rule" "inbound_from_on_premises" {
  security_group_id = aws_security_group.inbound_endpoint.id

  description = "DNS queries from on-premises network"
  from_port   = 53
  to_port     = 53
  ip_protocol = "udp"
  cidr_ipv4   = var.on_premises_cidr

  tags = {
    Name = "dns-from-on-premises-udp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound_from_on_premises_tcp" {
  security_group_id = aws_security_group.inbound_endpoint.id

  description = "DNS queries from on-premises network (TCP)"
  from_port   = 53
  to_port     = 53
  ip_protocol = "tcp"
  cidr_ipv4   = var.on_premises_cidr

  tags = {
    Name = "dns-from-on-premises-tcp"
  }
}

# Inbound: Allow DNS queries from VPC (UDP/TCP 53) for internal testing
resource "aws_vpc_security_group_ingress_rule" "inbound_from_vpc" {
  security_group_id = aws_security_group.inbound_endpoint.id

  description = "DNS queries from VPC"
  from_port   = 53
  to_port     = 53
  ip_protocol = "udp"
  cidr_ipv4   = var.vpc_cidr

  tags = {
    Name = "dns-from-vpc-udp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound_from_vpc_tcp" {
  security_group_id = aws_security_group.inbound_endpoint.id

  description = "DNS queries from VPC (TCP)"
  from_port   = 53
  to_port     = 53
  ip_protocol = "tcp"
  cidr_ipv4   = var.vpc_cidr

  tags = {
    Name = "dns-from-vpc-tcp"
  }
}

# Outbound: Allow all traffic (for health checks, DNS responses)
resource "aws_vpc_security_group_egress_rule" "inbound_allow_all" {
  security_group_id = aws_security_group.inbound_endpoint.id

  description = "Allow all outbound traffic"
  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "allow-all-egress"
  }
}

# Security group for outbound resolver endpoint
# Sends DNS queries to on-premises DNS servers
resource "aws_security_group" "outbound_endpoint" {
  name        = "route53-resolver-outbound-${var.environment}"
  description = "Security group for Route 53 Resolver outbound endpoint"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "route53-resolver-outbound-${var.environment}"
  }
}

# Inbound: Allow DNS queries from VPC (UDP/TCP 53)
resource "aws_vpc_security_group_ingress_rule" "outbound_from_vpc" {
  security_group_id = aws_security_group.outbound_endpoint.id

  description = "DNS queries from VPC resources"
  from_port   = 53
  to_port     = 53
  ip_protocol = "udp"
  cidr_ipv4   = var.vpc_cidr

  tags = {
    Name = "dns-from-vpc-udp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "outbound_from_vpc_tcp" {
  security_group_id = aws_security_group.outbound_endpoint.id

  description = "DNS queries from VPC resources (TCP)"
  from_port   = 53
  to_port     = 53
  ip_protocol = "tcp"
  cidr_ipv4   = var.vpc_cidr

  tags = {
    Name = "dns-from-vpc-tcp"
  }
}

# Outbound: Allow DNS queries to on-premises DNS servers
resource "aws_vpc_security_group_egress_rule" "outbound_to_on_premises" {
  security_group_id = aws_security_group.outbound_endpoint.id

  description = "DNS queries to on-premises DNS servers"
  from_port   = 53
  to_port     = 53
  ip_protocol = "udp"
  cidr_ipv4   = var.on_premises_cidr

  tags = {
    Name = "dns-to-on-premises-udp"
  }
}

resource "aws_vpc_security_group_egress_rule" "outbound_to_on_premises_tcp" {
  security_group_id = aws_security_group.outbound_endpoint.id

  description = "DNS queries to on-premises DNS servers (TCP)"
  from_port   = 53
  to_port     = 53
  ip_protocol = "tcp"
  cidr_ipv4   = var.on_premises_cidr

  tags = {
    Name = "dns-to-on-premises-tcp"
  }
}

# Outbound: Allow DNS queries to AWS Route 53 (for non-forwarded queries)
resource "aws_vpc_security_group_egress_rule" "outbound_to_aws_dns" {
  security_group_id = aws_security_group.outbound_endpoint.id

  description = "DNS queries to AWS Route 53"
  from_port   = 53
  to_port     = 53
  ip_protocol = "udp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "dns-to-aws-route53"
  }
}
