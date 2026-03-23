# Application Load Balancer (optional, enabled in staging/prod)

resource "aws_lb" "main" {
  count                            = var.enable_alb ? 1 : 0
  name                             = "${var.project_name}-alb-${var.environment}"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.alb[0].id]
  subnets                          = aws_subnet.public[*].id
  enable_deletion_protection       = var.environment == "prod" ? true : false
  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  access_logs {
    bucket  = aws_s3_bucket.alb_logs[0].id
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-alb-${var.environment}"
  }

  depends_on = [aws_s3_bucket_policy.alb_logs]
}

# S3 bucket for ALB access logs
resource "aws_s3_bucket" "alb_logs" {
  count  = var.enable_alb ? 1 : 0
  bucket = "${var.project_name}-alb-logs-${var.environment}"

  tags = {
    Name = "${var.project_name}-alb-logs-${var.environment}"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs" {
  count  = var.enable_alb ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "alb_logs" {
  count  = var.enable_alb ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy to allow ELB to write logs
resource "aws_s3_bucket_policy" "alb_logs" {
  count  = var.enable_alb ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::127311923021:root" # ELB service account for us-east-1
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_logs[0].arn}/*"
      }
    ]
  })
}

# Target Group
resource "aws_lb_target_group" "main" {
  count    = var.enable_alb ? 1 : 0
  name     = "${var.project_name}-tg-${var.environment}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout_seconds
    interval            = var.health_check_interval_seconds
    path                = "/health/ready"
    matcher             = "200"
    port                = "8080"
  }

  deregistration_delay = var.connection_drain_timeout_seconds

  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 86400
  }

  tags = {
    Name = "${var.project_name}-tg-${var.environment}"
  }
}

# HTTP Listener (redirect to HTTPS)
resource "aws_lb_listener" "http" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener (with self-signed cert for dev, ACM cert for prod)
resource "aws_lb_listener" "https" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.self_signed[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
}

# Self-signed certificate (for dev, replace with ACM certificate in production)
resource "tls_private_key" "main" {
  count     = var.enable_alb ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "main" {
  count           = var.enable_alb ? 1 : 0
  private_key_pem = tls_private_key.main[0].private_key_pem

  subject {
    common_name  = "${var.project_name}-${var.environment}.local"
    organization = "Example Organization"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "self_signed" {
  count            = var.enable_alb ? 1 : 0
  private_key      = tls_private_key.main[0].private_key_pem
  certificate_body = tls_self_signed_cert.main[0].cert_pem
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_name}-cert-${var.environment}"
  }
}

# ============================================================================
# Outputs
# ============================================================================

output "alb_dns_name" {
  value       = try(aws_lb.main[0].dns_name, "ALB not enabled")
  description = "DNS name of the Application Load Balancer"
}

output "alb_arn" {
  value       = try(aws_lb.main[0].arn, "ALB not enabled")
  description = "ARN of the Application Load Balancer"
}

output "target_group_arn" {
  value       = try(aws_lb_target_group.main[0].arn, "ALB not enabled")
  description = "ARN of the target group"
}
