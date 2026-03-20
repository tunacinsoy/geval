output "primary_vpc_id" {
  value = aws_vpc.primary.id
}

output "dr_vpc_id" {
  value = aws_vpc.dr.id
}

output "primary_alb_dns_name" {
  value = aws_lb.primary.dns_name
}

output "dr_alb_dns_name" {
  value = aws_lb.dr.dns_name
}

output "aurora_global_cluster_id" {
  value = aws_rds_global_cluster.aurora.id
}
