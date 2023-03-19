module "eks" {
  source = "./tf_aws_eks"

  instance_types = ["t3.medium"]
  region         = var.region
  stack_name     = var.stack_name
  subnet_ids     = module.vpc.eks_subnets
  account_id     = data.aws_caller_identity.current.account_id
}