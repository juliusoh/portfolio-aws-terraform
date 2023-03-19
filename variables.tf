variable "private_subnets" {
  description = "A comma separated list of private subnets inside the VPC"
  type        = string
  default     = "10.0.101.0/24,10.0.102.0/24,10.0.103.0/24"
}
variable "eks_subnets" {
  description = "A comma separated list of eks subnets inside the VPC"
  type        = string
  default     = "10.0.151.0/24,10.0.152.0/24,10.0.153.0/24"
}

variable "app_subnets" {
  description = "A comma separated list of app subnets inside the VPC"
  type        = string
  default     = "10.0.51.0/24,10.0.52.0/24,10.0.53.0/24"
}

variable "public_subnets" {
  description = "A comma separated list of public subnets inside the VPC"
  type        = string
  default     = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
}

variable "internal_dns_zone" {
  description = "The name of the internal route53 hosted zone"
  type        = string
  default     = "juliusoh.com"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "stack_name" {
  description = "The name of the stack that will be used to tag all known AWS Entities"
  type        = string
  default     = "juliusoh"
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-west-2"
}