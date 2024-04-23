output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.virtual_network.id
}
output "subnet_pub01" {
  description = "The id of subnet "
  value       = aws_subnet.virtual_subnet_pub01.id
}
output "subnet_pub02" {
  description = "The id of subnet "
  value       = aws_subnet.virtual_subnet_pub02.id
}
output "subnet_pri01" {
  description = "The id of subnet "
  value       = aws_subnet.virtual_subnet_pri01.id
}
output "subnet_pri02" {
  description = "The id of subnet "
  value       = aws_subnet.virtual_subnet_pri02.id
}
