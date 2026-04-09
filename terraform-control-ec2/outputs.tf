output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.control.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.control.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance."
  value       = aws_instance.control.public_dns
}

output "key_pair_name" {
  description = "Created AWS key pair name."
  value       = aws_key_pair.control.key_name
}

output "security_group_id" {
  description = "Security group ID attached to the EC2 instance."
  value       = aws_security_group.control.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance."
  value       = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.control.public_ip}"
}
