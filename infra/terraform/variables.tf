variable "aws_region" {
  description = "AWS region for the TaskApp infrastructure"
  type        = string
  default     = "us-east-2"
}
variable "vpc_cidr" {
  description = "CIDR block for the TaskApp VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "taskapp"
}
