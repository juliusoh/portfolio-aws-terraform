module "vpc" {
  source = "./tf_aws_vpc"

  stack_name        = var.stack_name
  cidr              = var.cidr
  eks_subnets       = split(",", var.eks_subnets)
  private_subnets   = split(",", var.private_subnets)
  public_subnets    = split(",", var.public_subnets)
  internal_dns_zone = var.internal_dns_zone
}
