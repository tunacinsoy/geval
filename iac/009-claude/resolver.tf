# Route 53 Resolver endpoints for hybrid DNS resolution

# Route 53 Resolver Inbound Endpoint
# Receives DNS queries from on-premises network for cloud-hosted services
resource "aws_route53_resolver_endpoint" "inbound" {
  name            = "hybrid-dns-inbound-${var.environment}"
  direction       = "INBOUND"
  security_groups = [aws_security_group.inbound_endpoint.id]

  ip_address_subnet {
    subnet_id = aws_subnet.inbound_endpoint.id
  }

  # Specify second AZ for high availability
  ip_address_subnet {
    subnet_id = aws_subnet.outbound_endpoint.id # Can reuse or use separate subnet
  }

  tags = {
    Name = "hybrid-dns-inbound-${var.environment}"
  }

  depends_on = [aws_cloudwatch_log_group.dns_queries]
}

# Route 53 Resolver Outbound Endpoint
# Forwards DNS queries to on-premises DNS servers
resource "aws_route53_resolver_endpoint" "outbound" {
  name            = "hybrid-dns-outbound-${var.environment}"
  direction       = "OUTBOUND"
  security_groups = [aws_security_group.outbound_endpoint.id]

  ip_address_subnet {
    subnet_id = aws_subnet.outbound_endpoint.id
  }

  # Specify second AZ for high availability
  ip_address_subnet {
    subnet_id = aws_subnet.inbound_endpoint.id # Can reuse or use separate subnet
  }

  tags = {
    Name = "hybrid-dns-outbound-${var.environment}"
  }

  depends_on = [aws_cloudwatch_log_group.dns_queries]
}

# Route 53 Resolver Rule
# Forwards queries for corp.internal to on-premises DNS servers
resource "aws_route53_resolver_rule" "corp_internal" {
  name                 = "corp-internal-${var.environment}"
  domain_name          = "corp.internal"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  # Primary DNS server (192.168.10.5)
  target_ip {
    ip   = var.on_premises_dns_servers[0]
    port = 53
  }

  # Secondary DNS server (192.168.10.6) - active-active load balancing
  target_ip {
    ip   = var.on_premises_dns_servers[1]
    port = 53
  }

  tags = {
    Name = "corp-internal-forwarding-${var.environment}"
  }

  depends_on = [aws_route53_resolver_endpoint.outbound]
}

# Route 53 Resolver Rule Association with VPC
# Associates the forwarding rule with the VPC
resource "aws_route53_resolver_rule_association" "corp_internal_vpc" {
  resolver_rule_id = aws_route53_resolver_rule.corp_internal.id
  vpc_id           = data.aws_vpc.main.id
  name             = "corp-internal-vpc-assoc-${var.environment}"

  depends_on = [aws_route53_resolver_rule.corp_internal]
}

# CloudWatch Log Configuration for Resolver
# Enables DNS query logging to CloudWatch
resource "aws_route53_resolver_query_log_config" "dns_queries" {
  name                      = "hybrid-dns-query-logs-${var.environment}"
  cloudwatch_log_group_name = aws_cloudwatch_log_group.dns_queries.name

  resource_id = data.aws_vpc.main.id
}
