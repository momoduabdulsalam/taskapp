resource "aws_security_group" "nodes" {
  name        = "${var.project_name}-nodes"
  description = "Security group for TaskApp Kubernetes nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-nodes-sg"
  }
}
