output "alb_dns_name" {
  description = "DNS name for the playground ALB"
  value       = aws_lb.playground.dns_name
}

output "vpc_id" {
  description = "VPC created for the playground"
  value       = aws_vpc.playground.id
}

output "expiration_date" {
  description = "Date when the automation schedules teardown"
  value       = timeadd(timestamp(), format("%sd", var.expiration_days))
}
