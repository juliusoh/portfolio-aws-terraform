resource "aws_eks_cluster" "eks-cluster" {
  name     = "tf-${var.stack_name}-eks-cluster-${var.region}"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-policy,
    aws_iam_role_policy_attachment.eks-cluster-security-group-policy
  ]
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  instance_types = var.instance_types
  node_group_name = "tf-${var.stack_name}-eks-cluster-node-group-${var.region}"
  node_role_arn   = aws_iam_role.eks-node-group.arn
  subnet_ids      = var.subnet_ids
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-group-worker-node-policy,
    aws_iam_role_policy_attachment.eks-node-group-cni-policy,
    aws_iam_role_policy_attachment.eks-node-group-registry-read-only-policy
  ]
}
