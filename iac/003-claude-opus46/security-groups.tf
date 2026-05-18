module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "= 5.3.1"

  name        = "${var.project}-sg"
  description = "Playground security group: SSH, HTTP, HTTPS inbound"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = join(",", var.allowed_ssh_cidr)
      description = "SSH access from team CIDR"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "HTTP access for application testing"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "HTTPS access for application testing"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "All outbound traffic"
    },
  ]
}
