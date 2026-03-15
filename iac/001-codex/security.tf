data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "deployment_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "deployment" {
  name               = "flower-shop-deployment-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.deployment_assume.json
}

resource "aws_iam_policy" "deployment_permissions" {
  name        = "flower-shop-deployment-${var.environment}"
  description = "Grants limited rights needed to upload assets, invalidate CDN, and manage TLS"

  policy = data.aws_iam_policy_document.deployment_permissions.json
}

resource "aws_iam_role_policy_attachment" "deployment_attach" {
  role       = aws_iam_role.deployment.name
  policy_arn = aws_iam_policy.deployment_permissions.arn
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "deployment_permissions" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]

    resources = [
      aws_s3_bucket.assets.arn,
      "${aws_s3_bucket.assets.arn}/*",
    ]
  }

  statement {
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
      "cloudfront:UpdateDistribution",
      "cloudfront:GetDistributionConfig",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "acm:ListCertificates",
      "acm:DescribeCertificate",
    ]

    resources = ["arn:aws:acm:*:${data.aws_caller_identity.current.account_id}:certificate/*"]
  }

  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:GetHostedZone",
      "route53:ChangeResourceRecordSets",
    ]

    resources = ["arn:aws:route53:::hostedzone/${var.route53_zone_id}"]
  }
}
