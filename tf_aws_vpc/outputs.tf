output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "app_subnets" {
  value = aws_subnet.app.*.id
}

output "eks_subnets" {
  value = aws_subnet.eks.*.id
}

output "vpc_id" {
  value = aws_vpc.mod.id
}

output "public_route_table_ids" {
  value = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  value = aws_route_table.private.*.id
}

output "default_security_group_id" {
  value = aws_vpc.mod.default_security_group_id
}

output "nat_eips" {
  value = aws_eip.nateip.*.id
}

output "internal_dns_zone-id" {
  value = aws_route53_zone.internal-dns-zone.zone_id
}

output "internal_dns_zone-name" {
  value = aws_route53_zone.internal-dns-zone.name
}

output "external_ips" {
  value = aws_nat_gateway.natgw.*.public_ip
}

output "vpc_cidr" {
  value = aws_vpc.mod.cidr_block
}
