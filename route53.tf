variable "my_domain" {
  description = "Your domain name"
  type        = string
  default     = "juliusoh.com" // replace with your domain
}

variable "ingyuoh" {
  description = "Your domain name"
  type        = string
  default     = "ingyuoh.com" // replace with your domain
}

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

# IngyuOh

resource "aws_route53_zone" "ingyuoh" {
  name = var.ingyuoh
}

resource "aws_route53_record" "ingyu_oh" {
  zone_id = aws_route53_zone.ingyuoh.zone_id
  name    = "${var.ingyuoh}"
  type    = "A"
  alias {
    evaluate_target_health = false 
    zone_id = "Z368ELLRRE2KJ0"
    name   = "dualstack.k8s-sharedlb-0b6b1133ba-867358731.us-west-1.elb.amazonaws.com"
  }
}
resource "aws_route53_record" "ingyuoh" {
  zone_id = aws_route53_zone.ingyuoh.zone_id
  name    = "www.${var.ingyuoh}"
  type    = "A"
  alias {
    evaluate_target_health = false 
    zone_id = "Z368ELLRRE2KJ0"
    name   = "dualstack.k8s-sharedlb-0b6b1133ba-867358731.us-west-1.elb.amazonaws.com"
  }
}


output "name_servers" {
  description = "The name servers for the hosted zone."
  value       = aws_route53_zone.my_zone.name_servers
}
