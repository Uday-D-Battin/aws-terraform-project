# aws-terraform-project
assignment-15

# AWS Infrastructure Deployment using Terraform

## Project Overview

This project provisions AWS infrastructure using Terraform.

## Architecture

- VPC
- 2 Public Subnets
- 2 Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- EC2 instances

## Deployment Steps

1. Install Terraform.
2. Configure AWS credentials.
3. Clone this repository.
4. Run:

terraform init

terraform validate

terraform plan

terraform apply

5. Verify the AWS resources.

## AD Decisions

- Terraform is used for Infrastructure as Code.
- VPC configuration is managed using a reusable module.
- Public and private subnets are separated.
- NAT Gateway provides outbound internet access for private resources.
- Security groups restrict required traffic.

## Cost Estimate

The estimated AWS cost depends on the selected EC2 instance types,
NAT Gateway usage, storage, and data transfer.
Actual cost should be checked using the AWS Pricing Calculator.

## Security Measures

- IAM roles are preferred instead of hard-coded AWS credentials.
- Private resources are deployed in private subnets.
- Security groups allow only required ports.
- Terraform state files are not committed to GitHub.
- Sensitive credentials are not stored in the repository.

## Scaling Strategy

- Use multiple Availability Zones.
- EC2 Auto Scaling can be implemented when required.
- Load Balancer can distribute application traffic.
- Resources can be resized based on CloudWatch monitoring.

## Production Readiness

Before production deployment:

- Review Terraform plan.
- Validate security groups and IAM permissions.
- Enable monitoring and logging.
- Configure backups.
- Review estimated AWS cost.
- Store Terraform state in a secure remote backend.
- Perform testing in a non-production environment first.
