output "vpc_id" {
  description = "ID of the TaskApp VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the TaskApp VPC"
  value       = aws_vpc.main.cidr_block
}
output "public_subnet_a_id" {
  description = "ID of public subnet A"
  value       = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  description = "ID of public subnet B"
  value       = aws_subnet.public_b.id
}

output "public_subnet_c_id" {
  description = "ID of public subnet C"
  value       = aws_subnet.public_c.id
}
