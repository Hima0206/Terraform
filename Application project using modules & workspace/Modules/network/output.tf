output "vpc_id" {
  description = "The ID of the VPC created."
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "The ID of the subnet created."
  value       = aws_subnet.main_subnet.id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway created."
  value       = aws_internet_gateway.main.id
}

output "route_table_id" {
  description = "The ID of the route table created."
  value       = aws_route_table.main.id
}

output "security_group_id" {
  description = "The ID of the security group created."
  value       = aws_security_group.main.id
}

output "availability_zone" {
  description = "The availability zone where the subnet is created."
  value       = data.aws_availability_zones.available.names[0]
}