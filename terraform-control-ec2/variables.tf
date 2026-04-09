variable "aws_region" {
  description = "AWS region where the EC2 instance will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR notation for SSH access, for example 203.0.113.10/32."
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip_cidr, 0))
    error_message = "my_ip_cidr must be a valid IPv4 CIDR block, for example 203.0.113.10/32."
  }
}

variable "instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
  default     = "control"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "AWS key pair name to create."
  type        = string
  default     = "control"
}

variable "security_group_name" {
  description = "Security group name for the EC2 instance."
  type        = string
  default     = "control-sg"
}

variable "environment" {
  description = "Environment tag."
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project tag."
  type        = string
  default     = "control"
}
