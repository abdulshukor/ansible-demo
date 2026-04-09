locals {
  common_tags = {
    Name        = var.instance_name
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Canonical Ubuntu Server 24.04 LTS AMD64 AMI published via AWS SSM Parameter Store
data "aws_ssm_parameter" "ubuntu_24_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "tls_private_key" "control" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "control" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.control.public_key_openssh

  tags = {
    Name = var.key_pair_name
  }
}

resource "local_sensitive_file" "control_pem" {
  filename        = "${path.module}/${var.key_pair_name}.pem"
  content         = tls_private_key.control.private_key_pem
  file_permission = "0400"
}

resource "aws_security_group" "control" {
  name        = var.security_group_name
  description = "Allow SSH access only from the operator public IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from operator IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_instance" "control" {
  ami                         = data.aws_ssm_parameter.ubuntu_24_ami.value
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.control.id]
  key_name                    = aws_key_pair.control.key_name
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = var.instance_name
  }
}
