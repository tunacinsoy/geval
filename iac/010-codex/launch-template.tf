data "aws_ssm_parameter" "current_ami" {
  name = aws_ssm_parameter.latest_ami.name
}

resource "aws_launch_template" "hardened" {
  name_prefix = "hardened-"
  image_id    = data.aws_ssm_parameter.current_ami.value
  instance_type = var.hardened_instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.asg.name
  }
  vpc_security_group_ids = [aws_security_group.app.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "hardened-node"
    }
  }
  user_data = base64encode("#!/bin/bash\nset -e\n")
}
