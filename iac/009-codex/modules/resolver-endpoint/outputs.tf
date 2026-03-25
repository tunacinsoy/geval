output "endpoint_id" {
  description = "Resolver endpoint identifier"
  value       = aws_route53_resolver_endpoint.this.id
}
