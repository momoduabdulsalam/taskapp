resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.nodes.id
  description       = "SSH from administrator IP"
  cidr_ipv4         = var.admin_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.nodes.id
  description       = "HTTP from the internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.nodes.id
  description       = "HTTPS from the internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.nodes.id
  description       = "Allow outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "k3s_api" {
  security_group_id            = aws_security_group.nodes.id
  description                  = "K3s API server from cluster nodes"
  referenced_security_group_id = aws_security_group.nodes.id
  from_port                    = 6443
  to_port                      = 6443
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "k3s_flannel_vxlan" {
  security_group_id            = aws_security_group.nodes.id
  description                  = "K3s Flannel VXLAN from cluster nodes"
  referenced_security_group_id = aws_security_group.nodes.id
  from_port                    = 8472
  to_port                      = 8472
  ip_protocol                  = "udp"
}

resource "aws_vpc_security_group_ingress_rule" "k3s_kubelet" {
  security_group_id            = aws_security_group.nodes.id
  description                  = "K3s kubelet from cluster nodes"
  referenced_security_group_id = aws_security_group.nodes.id
  from_port                    = 10250
  to_port                      = 10250
  ip_protocol                  = "tcp"
}
