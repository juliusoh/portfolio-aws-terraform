module "eks" {
  source = "./tf_aws_eks"
  deploy_argocd = true
  instance_types = ["t3.large", "t3a.large", "t2.large"]  # Multiple instance types for better spot availability
  region         = var.region
  stack_name     = var.stack_name
  subnet_ids     = module.vpc.eks_subnets
  account_id     = data.aws_caller_identity.current.account_id
  capacity_type  = "SPOT"  # Add this line
}
