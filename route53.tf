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

resource "aws_acm_certificate" "cert" {
  domain_name       = var.my_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.my_zone.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}


output "name_servers" {
  description = "The name servers for the hosted zone."
  value       = aws_route53_zone.my_zone.name_servers
}