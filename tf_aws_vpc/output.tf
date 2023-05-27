output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_private_ids" {
  value = [
    for s in aws_subnet.subnets_private : s.id
  ]
}

output "subnet_public_ids" {
  value = [
    for s in aws_subnet.subnets_public : s.id
  ]
}

output "route_table_private_id" {
  value = aws_route_table.rt_private.id
}

output "route_table_public_id" {
  value = aws_route_table.rt_public.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}