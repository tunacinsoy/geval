# AWS CloudFront CDN Infrastructure

Infrastructure-as-Code for a globally distributed CloudFront content delivery network (CDN) to accelerate image delivery for a blog serving international readers.

## Overview

This Terraform configuration deploys:

- **CloudFront Distribution** with globally distributed edge locations (North America, Europe, Asia-Pacific)
- **Tiered Caching** with content-type-specific TTL values:
  - Evergreen images: 30 days
  - Blog post images: 7 days
  - Featured images: 1 day
- **Image Optimization**: Automatic compression (gzip, brotli) and format negotiation (WebP support)
- **CloudWatch Monitoring**: Dashboard with cache hit ratio, latency, error rates, and regional metrics
- **Automated Alerts**: SNS notifications for cache performance, latency, and error rate thresholds
- **Access Logging**: S3 bucket with lifecycle policies (archive after 90 days, delete after 1 year)
- **Security**: Origin health checks, custom headers, HTTPS-only connectivity, automatic failover to stale cache

## Prerequisites

### Required Tools
- Terraform >= 1.6.0
- AWS CLI (for authentication and testing)
- AWS Account with permissions to:
  - Create CloudFront distributions
  - Create S3 buckets
  - Create CloudWatch dashboards and alarms
  - Create SNS topics
  - Create IAM roles and policies

### AWS Permissions
You can use the provided IAM policies or the predefined AWS managed policies:
- `CloudFrontFullAccess` (for deployment)
- `S3FullAccess` (for logs bucket)
- `CloudWatchFullAccess` (for monitoring)

### Configuration
Update `terraform.tfvars.prod` with your values before deployment:
- `domain_name`: Your blog domain (e.g., blog.example.com)
- `origin_domain`: Your origin server domain (e.g., images.example.com)
- `origin_verify_token`: Secret token for origin authentication (minimum 16 characters)
- `alert_email`: Email address for alert notifications

## File Structure

```
iac/
├── versions.tf              # Terraform and provider version constraints
├── provider.tf              # AWS provider configuration
├── backend.tf               # State backend (local; migration path documented)
├── variables.tf             # Input variables with validation
├── outputs.tf               # Output values and deployment information
├── main.tf                  # CloudFront distribution and cache behaviors
├── cloudfront-function.js   # CloudFront function for security headers
├── monitoring.tf            # CloudWatch dashboards, alarms, and SNS topic
├── security.tf              # IAM roles and policies
├── terraform.tfvars.prod    # Production environment variables
├── terraform.tfvars.example # Template for new environments
├── .gitignore               # Git ignore patterns for Terraform
├── README.md                # This file
└── MIGRATION-LOCAL-TO-S3.md # State backend migration guide
```

## Deployment

### 1. Initialize Terraform

```bash
cd iac/
terraform init
```

This downloads the AWS provider and configures the local state backend.

### 2. Review Configuration

```bash
terraform plan -var-file=terraform.tfvars.prod
```

Review the plan to verify CloudFront distribution, S3 bucket, CloudWatch resources, and IAM policies.

### 3. Deploy Infrastructure

```bash
terraform apply -var-file=terraform.tfvars.prod
```

This creates the CloudFront distribution and supporting infrastructure. Expected deployment time: 2-3 minutes.

### 4. Configure DNS

After successful deployment, update your DNS records:

- **Record Type**: CNAME (or ALIAS if using Route 53)
- **Source Domain**: `blog.example.com`
- **Target Domain**: CloudFront domain from `terraform output cloudfront_domain_name`
- **TTL**: 300 seconds (5 minutes) for quick failover

Example with Route 53:
```bash
aws route53 change-resource-record-sets \
  --hosted-zone-id YOUR_ZONE_ID \
  --change-batch '{
    "Changes": [{
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "blog.example.com",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [{"Value": "d123456.cloudfront.net"}]
      }
    }]
  }'
```

## Validation

### Test CloudFront Distribution

```bash
# Get the CloudFront domain
CLOUDFRONT_DOMAIN=$(terraform output -raw cloudfront_domain_name)

# Test cache hit
curl -I https://${CLOUDFRONT_DOMAIN}/evergreen/image.jpg

# Verify response headers
# - X-Cache: Hit from cloudfront (after first request)
# - Cache-Control: max-age=2592000 (30 days for evergreen)
# - Content-Encoding: gzip or br (compressed)
```

### Test Cache Behaviors

```bash
# Evergreen images (30-day cache)
curl -I https://${CLOUDFRONT_DOMAIN}/evergreen/logo.png | grep Cache-Control

# Blog post images (7-day cache)
curl -I https://${CLOUDFRONT_DOMAIN}/blog-posts/post-image.jpg | grep Cache-Control

# Featured images (1-day cache)
curl -I https://${CLOUDFRONT_DOMAIN}/featured/hero.png | grep Cache-Control
```

### Test Origin Health

CloudFront monitors origin health every 30 seconds. To simulate origin failure:

```bash
# Temporarily stop origin server
# Monitor CloudWatch dashboard - should show origin unhealthy
# CDN serves stale cache automatically

# Restart origin server
# Monitor CloudWatch - origin should return to healthy within 60 seconds
```

### Monitor Cache Performance

Open CloudWatch dashboard:
```bash
# Dashboard URL from terraform output
terraform output cloudfront_dashboard_url
```

Monitor these key metrics:
- **Cache Hit Rate**: Target > 85%
- **P95 Latency**: Target < 500ms
- **P99 Latency**: Target < 1000ms
- **Error Rate**: Target < 0.1%

## Alerts

CloudWatch alarms send notifications to the configured email address via SNS:

1. **Cache Hit Ratio Alert**: Fires if cache hit ratio drops below 75%
   - Action: Investigate cache configuration, check TTL values

2. **Latency P95 Alert**: Fires if 95th percentile latency exceeds 750ms
   - Action: Check origin server performance, verify TLS handshake time

3. **4xx Error Rate Alert**: Fires if error rate exceeds 1%
   - Action: Check origin for missing content, verify cache key configuration

4. **5xx Error Rate Alert**: Fires if error rate exceeds 1%
   - Action: Check origin server health, verify origin connectivity

5. **High Request Rate Alert**: Fires if requests exceed 100k/minute
   - Action: Investigate for DDoS or unusual traffic spike

## Cache Invalidation

To invalidate cache (e.g., after updating images):

### Using AWS CLI

```bash
DISTRIBUTION_ID=$(terraform output -raw cloudfront_distribution_id)

# Invalidate all images
aws cloudfront create-invalidation \
  --distribution-id $DISTRIBUTION_ID \
  --paths '/*'

# Invalidate specific path
aws cloudfront create-invalidation \
  --distribution-id $DISTRIBUTION_ID \
  --paths '/featured/*'

# Monitor invalidation progress
aws cloudfront list-invalidations --distribution-id $DISTRIBUTION_ID
```

### Using Terraform

Add to your Terraform configuration:

```hcl
resource "aws_cloudfront_invalidation" "example" {
  distribution_id = aws_cloudfront_distribution.blog_cdn.id
  paths           = ["/featured/*"]
}
```

Invalidation completes within 5 minutes across all edge locations.

## Origin Security

The CloudFront distribution requires the origin server to validate the `X-Origin-Verify` header:

```http
X-Origin-Verify: your-secret-token
```

Configure your origin server to:
1. Accept requests only with the correct `X-Origin-Verify` header
2. Reject direct requests (not through CloudFront)

Example (Node.js Express):
```javascript
app.use((req, res, next) => {
  if (req.headers['x-origin-verify'] !== process.env.ORIGIN_VERIFY_TOKEN) {
    return res.status(403).send('Unauthorized');
  }
  next();
});
```

## Troubleshooting

### Low Cache Hit Ratio

**Symptoms**: Cache hit ratio < 75%, more origin requests than expected

**Causes**:
1. Origin Cache-Control headers not set correctly
2. Query strings vary but not configured in CloudFront
3. Cookies vary but not configured in CloudFront
4. Images frequently updated (featured images with 1-day TTL)

**Solutions**:
1. Verify origin server sets Cache-Control headers:
   ```bash
   curl -I https://origin-domain/images/example.jpg
   # Look for: Cache-Control: max-age=...
   ```
2. Check cache key configuration in CloudFront
3. If query strings matter, configure CloudFront to include them in cache key
4. Adjust TTL values in `terraform.tfvars` if content updates frequently

### High Latency

**Symptoms**: P95 latency > 500ms, slow image loading from some regions

**Causes**:
1. Origin server slow or overloaded
2. TLS handshake overhead (especially first request)
3. Geographic distance to edge location (unlikely with CloudFront's 300+ global locations)

**Solutions**:
1. Check origin server performance:
   ```bash
   curl -w "\nTime Connect: %{time_connect}\nTime TTFB: %{time_starttransfer}\n" \
     https://origin-domain/health
   ```
2. Monitor CloudWatch dashboard for origin latency trends
3. Enable Origin Shield (already enabled in this configuration)
4. If persistent, consider origin server upgrade

### Origin Health Check Failures

**Symptoms**: Origin marked unhealthy, CloudFront serves stale cache

**Causes**:
1. Health check endpoint not responding (default: `/health`)
2. Origin server down or unreachable
3. Security group blocking health checks
4. X-Origin-Verify header validation failure

**Solutions**:
1. Verify health check endpoint:
   ```bash
   curl -I https://origin-domain/health
   curl -H "X-Origin-Verify: your-token" https://origin-domain/health
   ```
2. Check origin server logs for health check requests
3. Verify origin security group allows HTTPS from CloudFront
4. Monitor CloudWatch dashboard for origin health status

### Alert False Positives

**Symptoms**: Alerts firing frequently for expected behavior

**Solutions**:
1. Review alert thresholds in `terraform.tfvars`:
   - `cache_hit_alert_threshold`: Default 75%, increase if acceptable
   - `latency_alert_threshold`: Default 750ms, adjust to actual SLA
2. Check for legitimate traffic spikes
3. Increase alarm evaluation periods (currently 2 periods of 5 minutes)
4. Consider seasonal patterns in blog traffic

## State Management

### Current Setup (Local State)

Currently using local Terraform state (`terraform.tfstate`). **Not recommended for production or team collaboration.**

### Migration to Remote State (Recommended)

See `MIGRATION-LOCAL-TO-S3.md` for step-by-step instructions to migrate to AWS S3 + DynamoDB backend.

Benefits of remote state:
- Team collaboration (multiple users can safely run terraform)
- Automatic locking (DynamoDB prevents concurrent modifications)
- Encrypted state file (AES-256 encryption)
- Version history (S3 versioning)
- Automated backups

## Cost Estimation

Expected monthly costs (based on <100 GB/month traffic):

- **CloudFront**: Free tier covers 1 TB/month data transfer
- **S3 Logs**: ~$1-2/month for storage and lifecycle
- **CloudWatch**: ~$1-2/month for dashboard and alarms
- **Total**: <$5/month for small blog

For larger traffic:
- CloudFront data transfer: $0.085/GB (varies by region)
- CloudWatch metrics: $0.30/month per custom metric

Use AWS Cost Calculator for accurate estimates: https://calculator.aws/

## Support

For issues or questions:

1. **Check logs**: `terraform state list` and `terraform state show`
2. **Review CloudWatch**: Check metrics and logs for errors
3. **Check origin**: Verify origin server health and connectivity
4. **Terraform debug**: `TF_LOG=DEBUG terraform apply` for detailed logging

## References

- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [CloudFront Cache Behaviors](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html)
- [CloudWatch Monitoring CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/monitoring_cloudwatch.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)

## License

This infrastructure code is provided as-is. Modify as needed for your specific requirements.
