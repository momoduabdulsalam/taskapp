variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Kubernetes nodes"
  type        = string
  default     = "t3.small"
}

variable "security_group_id" {
  description = "Security group ID for Kubernetes nodes"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the Kubernetes nodes"
  type        = list(string)
}
