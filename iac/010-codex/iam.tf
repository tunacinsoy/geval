resource "aws_iam_role" "imagebuilder" {
  name = "hardened-imagebuilder-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "imagebuilder" {
  name = "imagebuilder-s3-ssm"
  role = aws_iam_role.imagebuilder.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "ssm:*",
          "logs:*",
          "imagebuilder:*",
          "ec2:CreateTags"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "imagebuilder" {
  name = "hardened-imagebuilder-profile"
  role = aws_iam_role.imagebuilder.name
}

resource "aws_iam_role" "asg" {
  name = "hardened-asg-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "asg" {
  name = "asg-inline"
  role = aws_iam_role.asg.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "autoscaling:*",
          "ec2:DescribeInstanceStatus",
          "cloudwatch:PutMetricData"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "asg" {
  name = "hardened-asg-profile"
  role = aws_iam_role.asg.name
}
