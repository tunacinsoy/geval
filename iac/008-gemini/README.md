# Pub/Sub Order Events Infrastructure

This directory contains the Terraform code for the Pub/Sub Order Events infrastructure.

## Prerequisites

- Terraform v1.14.0 or higher
- Google Cloud SDK authenticated to your target project

## Provisioning

1.  **Initialize Terraform**:
    ```sh
    terraform init
    ```

2.  **Select a workspace**:
    ```sh
    terraform workspace select dev
    ```

3.  **Review the plan**:
    ```sh
    terraform plan -var-file=terraform.tfvars.dev
    ```

4.  **Apply the changes**:
    ```sh
    terraform apply -var-file=terraform.tfvars.dev
    ```

## Environments

This infrastructure is managed across three environments using Terraform workspaces:

- `dev`
- `staging`
- `prod`

Each environment has a corresponding `.tfvars` file to specify environment-specific variables.

## Resources

This code will create the following resources in your GCP project:

-   A Pub/Sub topic named `order-events` with Avro schema validation.
-   A Dead-Letter Queue for the main topic.
-   A push subscription for a Cloud Run service.
-   A pull subscription for an analytics service.
-   A Cloud Run service for order processing.
-   An IAM Service Account for the Cloud Run service with appropriate permissions.
-   Monitoring and alerting policies for the Pub/Sub topic.
