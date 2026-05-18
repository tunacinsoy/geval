# Temporary Feature Playground

Ephemeral AWS infrastructure for team feature testing. Single EC2 instance in an isolated VPC with SSH and HTTP/HTTPS access.

## Prerequisites

- AWS CLI configured with valid credentials
- Terraform >= 1.12
- SSH key pair (ed25519 or RSA)

## Quick Start

```bash
cd iac/
terraform init

# Edit terraform.tfvars — uncomment and set required values:
#   allowed_ssh_cidr = ["YOUR_TEAM_IP/32"]
#   ssh_public_key   = "ssh-ed25519 AAAA..."

terraform plan
terraform apply
```

## Connecting

After `terraform apply`, Terraform outputs connection details:

```bash
# SSH into the instance
ssh -i <private-key-file> ec2-user@$(terraform output -raw public_ip)

# Open web application in browser
echo $(terraform output -raw http_url)
```

## Teardown

Single command removes all resources:

```bash
terraform destroy
```

Verify no resources remain:

```bash
terraform state list
```

## Cost Estimate

- t3.small: ~$0.0208/hr (~$15/week on-demand)
- EBS 20 GiB gp3: ~$1.60/month
- Elastic IP (attached): free
- **Total for 2 weeks: ~$32** (well within $150 budget)

## Expiry

This environment has a hard expiration date of **2026-06-01**. All resources must be destroyed by this date regardless of testing status.
