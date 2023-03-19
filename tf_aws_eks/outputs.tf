output "eks_cluster_name" {
  value = aws_eks_cluster.eks-cluster.name
}

output "eks_node_group_name" {
  value = aws_eks_node_group.eks-node-group.node_group_name
}

output "eks_role_arn" {
  value = aws_iam_role.eks_role.arn
}

output "oidc_provider_url" {
  value = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}