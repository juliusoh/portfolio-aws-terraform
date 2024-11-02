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

module "istio_eks" {
  source = "./tf_aws_eks"
  deploy_argocd = false  # We don't need ArgoCD for the tutorial
  instance_types = ["t3.large"]  # Single instance type is fine for testing
  region         = var.region
  stack_name     = "istio-tutorial"  # Different stack name to differentiate
  subnet_ids     = module.vpc.eks_subnets
  account_id     = data.aws_caller_identity.current.account_id
  capacity_type  = "ON_DEMAND"  # Using on-demand for stability during tutorial
}