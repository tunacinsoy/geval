output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2_instance.id
}

output "public_ip" {
  description = "Elastic IP address for stable access"
  value       = aws_eip.playground.public_ip
}

output "public_dns" {
  description = "EC2 public DNS name"
  value       = module.ec2_instance.public_dns
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i <private-key-file> ec2-user@${aws_eip.playground.public_ip}"
}

output "http_url" {
  description = "HTTP URL for web application testing"
  value       = "http://${aws_eip.playground.public_ip}"
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "security_group_id" {
  description = "Security group ID"
  value       = module.security_group.security_group_id
}
