resource "aws_s3_bucket" "origin" {
  bucket = "my-awesome-blog-cdn-origin"

  tags = var.tags
}

resource "aws_s3_bucket_policy" "origin" {
  bucket = aws_s3_bucket.origin.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.origin.arn}/*"
      },
    ]
  })
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for ${aws_s3_bucket.origin.bucket}"
}
