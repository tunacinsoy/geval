data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amazon-linux-2023*"]
  }
}

resource "aws_ssm_parameter" "latest_ami" {
  name        = "/hardened-image-pipeline/latest-ami"
  type        = "String"
  value       = data.aws_ami.amazon_linux_2023.id
  description = "AMI id for the latest hardened image"
  tags = {
    managed_by = "iac"
  }
}
