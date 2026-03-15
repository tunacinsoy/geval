#!/bin/bash
# User Data Script for EC2 Instances
# Bootstraps instances with CloudWatch agent and Docker

set -e  # Exit on error

# Logging
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=== Starting User Data Script ==="
echo "Environment: ${environment}"
echo "Project: ${project}"
echo "Region: ${region}"
echo "RDS Endpoint: ${rds_endpoint}"
echo "S3 Bucket: ${s3_bucket}"

# Update system packages
yum update -y

# Install CloudWatch agent
wget https://s3.${region}.amazonaws.com/amazoncloudwatch-agent-${region}/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# Install Docker
amazon-linux-extras install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install PostgreSQL client tools (for RDS connection testing)
yum install -y postgresql-devel

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --update

# Create CloudWatch agent configuration
cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json << 'EOF'
{
  "metrics": {
    "namespace": "TestPlayground",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "/"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/docker",
            "log_group_name": "/test-playground/docker",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%Y-%m-%dT%H:%M:%S"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/test-playground/system",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%b %d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json

# Create environment file for application deployment
cat > /home/ec2-user/.env << 'EOF'
ENVIRONMENT=${environment}
PROJECT=${project}
AWS_REGION=${region}
RDS_ENDPOINT=${rds_endpoint}
S3_BUCKET=${s3_bucket}
EOF

chown ec2-user:ec2-user /home/ec2-user/.env
chmod 600 /home/ec2-user/.env

# Test PostgreSQL connection
echo "Testing RDS PostgreSQL connection..."
pg_isready -h $(echo "${rds_endpoint}" | cut -d: -f1) -p 5432 || echo "RDS endpoint not yet available (expected during initial provisioning)"

# Test S3 access
echo "Testing S3 bucket access..."
aws s3 ls ${s3_bucket} --region ${region} || echo "S3 access test failed (check IAM role permissions)"

echo "=== User Data Script Complete ==="
