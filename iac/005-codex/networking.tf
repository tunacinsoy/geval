resource "aws_vpc_endpoint" "s3" {
  count               = var.authoring_vpc_id != "" ? 1 : 0
  vpc_id              = var.authoring_vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids     = var.authoring_route_table_ids
  policy              = data.aws_iam_policy_document.s3_endpoint.json
  private_dns_enabled = true
}

resource "aws_iam_role" "authoring" {
  name = var.authoring_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "authoring" {
  name = "image-authoring-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectTagging"
        ]
        Resource = "${aws_s3_bucket.primary.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.primary.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "authoring" {
  role       = aws_iam_role.authoring.name
  policy_arn = aws_iam_policy.authoring.arn
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "s3_endpoint" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
