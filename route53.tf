resource "aws_route53_zone" "my_zone" {
  name = var.my_domain
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "www.${var.my_domain}"
  type    = "A"
  alias {
    evaluate_target_health = false 
    zone_id = "Z368ELLRRE2KJ0"
    name   = "dualstack.k8s-sharedlb-0b6b1133ba-867358731.us-west-1.elb.amazonaws.com"
  }
}

variable "my_domain" {
  description = "Your domain name"
  type        = string
  default     = "juliusoh.com" // replace with your domain
}

output "name_servers" {
  description = "The name servers for the hosted zone."
  value       = aws_route53_zone.my_zone.name_servers
}