#!/bin/bash
# User data script for instance initialization

set -e

ENVIRONMENT="${environment}"
LOG_GROUP="${log_group}"
REGION="${region}"

# Log all output
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=== Instance Initialization ==="
echo "Environment: $ENVIRONMENT"
echo "Region: $REGION"
echo "Timestamp: $(date)"

# ============================================================================
# Install CloudWatch Agent
# ============================================================================

echo "Installing CloudWatch agent..."
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# ============================================================================
# Configure CloudWatch Logs
# ============================================================================

echo "Configuring CloudWatch Logs..."
cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<EOF
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "$LOG_GROUP",
            "log_stream_name": "{instance_id}/system-log"
          },
          {
            "file_path": "/var/log/secure",
            "log_group_name": "$LOG_GROUP",
            "log_stream_name": "{instance_id}/secure-log"
          },
          {
            "file_path": "/var/log/cis-hardening.log",
            "log_group_name": "$LOG_GROUP",
            "log_stream_name": "{instance_id}/cis-hardening-log"
          }
        ]
      }
    }
  },
  "metrics": {
    "metrics_collected": {
      "cpu": {
        "measurement": [
          {
            "name": "cpu_usage_idle",
            "rename": "CPU_IDLE",
            "unit": "Percent"
          },
          "cpu_usage_iowait"
        ],
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": [
          {
            "name": "mem_used_percent",
            "rename": "MEM_USED",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          {
            "name": "used_percent",
            "rename": "DISK_USED",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "/"
        ]
      }
    }
  }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json

# ============================================================================
# Install Health Check Endpoint
# ============================================================================

echo "Setting up health check endpoint..."
yum install -y python3

# Create simple health check service
cat > /opt/health-check/app.py <<'ENDPOINT'
#!/usr/bin/env python3

import json
import subprocess
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime

class HealthCheckHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health/ready':
            response = {
                'status': 'ready',
                'timestamp': datetime.utcnow().isoformat(),
                'hostname': subprocess.check_output(['hostname']).decode().strip()
            }

            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps(response).encode())
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        # Suppress default logging
        pass

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), HealthCheckHandler)
    print('Health check endpoint listening on port 8080')
    server.serve_forever()
ENDPOINT

chmod +x /opt/health-check/app.py

# Create systemd service for health check
cat > /etc/systemd/system/health-check.service <<'SERVICE'
[Unit]
Description=Health Check Endpoint
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /opt/health-check/app.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable health-check
systemctl start health-check

# ============================================================================
# Enhanced Logging
# ============================================================================

echo "Setting up syslog forwarding..."
echo "User data script completed at $(date)" >> /var/log/user-data.log

# ============================================================================
# Signal completion
# ============================================================================

echo "=== Instance Initialization Complete ==="
