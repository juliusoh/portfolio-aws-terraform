resource "aws_route53_zone" "my_zone" {
  name = var.my_domain
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "www.${var.my_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.my_eip.public_ip]
}

variable "my_domain" {
  description = "Your domain name"
  type        = string
  default     = "juliusoh.com" // replace with your domain
}

resource "aws_eip" "my_eip" {
  vpc = true
}

output "name_servers" {
  description = "The name servers for the hosted zone."
  value       = aws_route53_zone.my_zone.name_servers
}