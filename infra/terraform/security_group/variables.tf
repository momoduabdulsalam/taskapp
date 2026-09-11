variable "vpc_id" {
  description = "ID of the VPC where the Kubernetes nodes will run"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}
variable "admin_cidr" {
  description = "Public IPv4 CIDR allowed to SSH to Kubernetes nodes"
  type        = string
}
