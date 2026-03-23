# IAM roles for Route 53 Resolver service

# IAM role for Route 53 Resolver service to manage endpoints
resource "aws_iam_role" "resolver_service" {
  name               = "route53-resolver-service-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.resolver_trust.json

  tags = {
    Name = "route53-resolver-service-role-${var.environment}"
  }
}

# Trust policy: Allow Route 53 Resolver service to assume the role
data "aws_iam_policy_document" "resolver_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["route53resolver.amazonaws.com"]
    }
  }
}

# Inline policy for resolver service role
resource "aws_iam_role_policy" "resolver_service" {
  name   = "route53-resolver-service-policy"
  role   = aws_iam_role.resolver_service.id
  policy = data.aws_iam_policy_document.resolver_service_policy.json
}

data "aws_iam_policy_document" "resolver_service_policy" {
  statement {
    sid    = "ManageNetworkInterfaces"
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:Vpc"
      values   = [data.aws_vpc.main.arn]
    }
  }

  statement {
    sid    = "DescribeVpc"
    effect = "Allow"

    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "WriteCloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.dns_queries.arn,
      "${aws_cloudwatch_log_group.dns_queries.arn}:*"
    ]
  }
}

# IAM role for infrastructure team access to resolver configuration
resource "aws_iam_role" "infrastructure_team" {
  name               = "hybrid-dns-infrastructure-team-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.infrastructure_team_trust.json

  tags = {
    Name = "hybrid-dns-infrastructure-team-${var.environment}"
  }
}

# Trust policy: Allow human users/applications to assume this role
data "aws_iam_policy_document" "infrastructure_team_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

# Inline policy for infrastructure team (read-only + limited write access)
resource "aws_iam_role_policy" "infrastructure_team" {
  name   = "hybrid-dns-infrastructure-team-policy"
  role   = aws_iam_role.infrastructure_team.id
  policy = data.aws_iam_policy_document.infrastructure_team_policy.json
}

data "aws_iam_policy_document" "infrastructure_team_policy" {
  # Read-only access to resolver configuration
  statement {
    sid    = "ReadResolverConfiguration"
    effect = "Allow"

    actions = [
      "route53resolver:GetResolverEndpoint",
      "route53resolver:ListResolverEndpoints",
      "route53resolver:GetResolverRule",
      "route53resolver:ListResolverRules",
      "route53resolver:GetResolverRuleAssociation",
      "route53resolver:ListResolverRuleAssociations"
    ]

    resources = ["*"]
  }

  # Modify resolver rules (add/remove associations)
  statement {
    sid    = "ManageResolverRules"
    effect = "Allow"

    actions = [
      "route53resolver:AssociateResolverRule",
      "route53resolver:DisassociateResolverRule"
    ]

    resources = ["*"]
  }

  # Read CloudWatch logs
  statement {
    sid    = "ReadCloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:GetLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.dns_queries.arn,
      "${aws_cloudwatch_log_group.dns_queries.arn}:*"
    ]
  }

  # Read CloudWatch metrics and alarms
  statement {
    sid    = "ReadCloudWatchMetrics"
    effect = "Allow"

    actions = [
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListDashboards",
      "cloudwatch:GetDashboard",
      "cloudwatch:DescribeAlarms"
    ]

    resources = ["*"]
  }
}

# Current AWS account ID for resource ARNs
data "aws_caller_identity" "current" {}
