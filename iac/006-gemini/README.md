# Multi-Region Disaster Recovery Infrastructure

This repository contains the Terraform code for deploying a multi-region disaster recovery infrastructure on AWS.

## Prerequisites

- Terraform v1.14.7 or later
- AWS credentials configured for the target accounts

## Usage

1.  Initialize Terraform:
    ```sh
    terraform -chdir=iac init
    ```
2.  Select the desired environment:
    ```sh
    export TF_VAR_env=dev
    ```
3.  Plan the infrastructure changes:
    ```sh
    terraform -chdir=iac plan -var-file="terraform.tfvars.$TF_VAR_env"
    ```
4.  Apply the changes:
    ```sh
    terraform -chdir=iac apply -var-file="terraform.tfvars.$TF_VAR_env"
    ```
