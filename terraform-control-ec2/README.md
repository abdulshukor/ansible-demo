# Terraform EC2 Deployment - Control Instance

This Terraform configuration deploys:

- 1 Ubuntu 24.04 EC2 instance
- Instance name: `control`
- Instance type: `t2.micro`
- AWS key pair: `control`
- Security group: `control-sg`
- SSH access on port `22` only from your public IP

## Files

- `versions.tf` - Terraform and provider version constraints
- `providers.tf` - AWS provider configuration and default tags
- `variables.tf` - Input variables and validation
- `main.tf` - Core infrastructure resources
- `outputs.tf` - Useful deployment outputs
- `terraform.tfvars.example` - Example variable values

## Prerequisites

- Terraform 1.5+
- AWS credentials configured
- Default VPC available in the target region

## Usage

1. Initialize Terraform:

```bash
terraform init
```

2. Copy the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Edit `terraform.tfvars` and set your public IP in CIDR format:

```hcl
my_ip_cidr = "203.0.113.10/32"
```

4. Review the plan:

```bash
terraform plan
```

5. Apply the configuration:

```bash
terraform apply
```

## Connect to the Server

After apply completes:

```bash
ssh -i control.pem ubuntu@<public-ip>
```

Or use the generated Terraform output:

```bash
terraform output ssh_command
```

## Notes

- The private key is generated locally as `control.pem`
- The root volume is encrypted and deleted on termination
- Instance metadata service requires IMDSv2
- The configuration uses the latest Canonical Ubuntu 24.04 AMI from AWS SSM Parameter Store
