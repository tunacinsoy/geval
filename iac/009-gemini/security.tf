module "resolver_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0" # NOTE: It is recommended to pin a specific version

  name        = "dns-resolver-sg"
  description = "Security group for Route 53 Resolver endpoints"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      description = "Allow DNS from VPC"
      cidr_blocks = [data.aws_vpc.this.cidr_block]
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      description = "Allow DNS from VPC"
      cidr_blocks = [data.aws_vpc.this.cidr_block]
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      description = "Allow DNS from On-Premise"
      cidr_blocks = [var.on_prem_cidr]
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      description = "Allow DNS from On-Premise"
      cidr_blocks = [var.on_prem_cidr]
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      description = "Allow DNS to On-Premise"
      cidr_blocks = [for ip in var.on_prem_dns_ips : "${ip}/32"]
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      description = "Allow DNS to On-Premise"
      cidr_blocks = [for ip in var.on_prem_dns_ips : "${ip}/32"]
    },
  ]

  tags = var.tags
}

data "aws_vpc" "this" {
  id = var.vpc_id
}
