resource "aws_route53_zone" "internal-dns-zone" {
  name = var.internal_dns_zone
  vpc {
    vpc_id = aws_vpc.mod.id
  }
}
