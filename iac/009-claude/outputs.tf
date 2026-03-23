# Output values for hybrid DNS resolver infrastructure

output "inbound_endpoint_ip" {
  description = "IP address of the inbound resolver endpoint (for on-premises DNS client configuration)"
  value = try(
    aws_route53_resolver_endpoint.inbound.ip_addresses[0].ip,
    "IP address will be available after terraform apply"
  )
}

output "outbound_endpoint_ip" {
  description = "IP address of the outbound resolver endpoint"
  value = try(
    aws_route53_resolver_endpoint.outbound.ip_addresses[0].ip,
    "IP address will be available after terraform apply"
  )
}

output "inbound_endpoint_id" {
  description = "ID of the inbound resolver endpoint"
  value       = aws_route53_resolver_endpoint.inbound.id
}

output "outbound_endpoint_id" {
  description = "ID of the outbound resolver endpoint"
  value       = aws_route53_resolver_endpoint.outbound.id
}

output "forwarding_rule_arn" {
  description = "ARN of the corp.internal forwarding rule"
  value       = aws_route53_resolver_rule.corp_internal.arn
}

output "forwarding_rule_id" {
  description = "ID of the corp.internal forwarding rule"
  value       = aws_route53_resolver_rule.corp_internal.id
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for DNS query logs"
  value       = aws_cloudwatch_log_group.dns_queries.name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.dns_queries.arn
}

output "inbound_security_group_id" {
  description = "Security group ID for inbound resolver endpoint"
  value       = aws_security_group.inbound_endpoint.id
}

output "outbound_security_group_id" {
  description = "Security group ID for outbound resolver endpoint"
  value       = aws_security_group.outbound_endpoint.id
}

output "vpc_id" {
  description = "VPC ID containing resolver endpoints"
  value       = data.aws_vpc.main.id
}

output "resolver_query_log_config_id" {
  description = "ID of the resolver query log configuration"
  value       = aws_route53_resolver_query_log_config.dns_queries.id
}

output "terraform_workspace" {
  description = "Terraform workspace name"
  value       = terraform.workspace
}

output "environment" {
  description = "Environment (dev, staging, prod)"
  value       = var.environment
}

output "resolver_service_role_arn" {
  description = "ARN of the resolver service IAM role"
  value       = aws_iam_role.resolver_service.arn
}

output "infrastructure_team_role_arn" {
  description = "ARN of the infrastructure team IAM role"
  value       = aws_iam_role.infrastructure_team.arn
}
