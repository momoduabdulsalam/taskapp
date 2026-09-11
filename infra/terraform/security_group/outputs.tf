output "security_group_id" {
  description = "ID of the Kubernetes nodes security group"
  value       = aws_security_group.nodes.id
}
