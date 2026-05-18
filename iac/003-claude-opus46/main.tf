module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "= 6.6.1"

  name = "${var.project}-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["${var.region}a"]
  public_subnets = ["10.0.1.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  map_public_ip_on_launch = true
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "playground" {
  key_name   = "${var.project}-key"
  public_key = var.ssh_public_key
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "= 6.4.0"

  name = "${var.project}-instance"

  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_group.security_group_id]
  key_name               = aws_key_pair.playground.key_name

  associate_public_ip_address = true

  root_block_device = {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
}

resource "aws_eip" "playground" {
  instance = module.ec2_instance.id

  tags = {
    Name = "${var.project}-eip"
  }
}
