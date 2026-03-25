output "vpc_id" {
  value       = aws_vpc.resolver_bridge.id
  description = "VPC used for the resolver bridge"
}

output "inbound_endpoint_id" {
  value       = module.inbound_endpoint.endpoint_id
  description = "ID of the inbound resolver endpoint"
}

output "outbound_endpoint_id" {
  value       = module.outbound_endpoint.endpoint_id
  description = "ID of the outbound resolver endpoint"
}

output "resolver_security_group_id" {
  value       = aws_security_group.resolver_endpoint.id
  description = "Security group preventing unauthorized DNS traffic"
}
