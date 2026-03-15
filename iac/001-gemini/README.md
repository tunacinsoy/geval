# Flower Shop Website Infrastructure

This directory contains the Terraform code to provision the infrastructure for the Flower Shop's static website on AWS.

## Prerequisites

- Terraform `~> 1.14`
- An AWS account with credentials configured.
- A pre-existing S3 bucket and DynamoDB table for the Terraform backend.
- A registered domain name and a corresponding public hosted zone in AWS Route 53.
- An ACM certificate for the domain name, validated in the `us-east-1` region.

## Setup

1.  **Configure Backend**:
    Update the `iac/backend.tf` file with the name of your S3 bucket and DynamoDB table.

2.  **Configure Variables**:
    Create a `terraform.tfvars` file in the `iac/` directory and provide values for the required variables:
    ```terraform
    domain_name         = "your-domain.com"
    bucket_name         = "your-unique-bucket-name"
    acm_certificate_arn = "arn:aws:acm:us-east-1:..."
    ```

3.  **Initialize Terraform**:
    Run `terraform init` to initialize the backend and download the necessary providers and modules.

## Deployment

1.  **Plan**:
    Run `terraform plan` to review the changes that will be applied.

2.  **Apply**:
    Run `terraform apply` to provision the infrastructure.

## Content Deployment

After the infrastructure is provisioned, you can deploy your website content by uploading the static files (HTML, CSS, JS, images) to the S3 bucket specified in your variables.

## Destruction

To tear down the infrastructure, run `terraform destroy`.
