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
  instance_types  = var.instance_types
  node_group_name = "tf-${var.stack_name}-eks-cluster-node-group-${var.region}"
  node_role_arn   = aws_iam_role.eks-node-group.arn
  subnet_ids      = var.subnet_ids
  capacity_type   = var.capacity_type

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  # Add labels and taints for better pod scheduling
  labels = {
    "node-type" = "spot"
  }

  update_config {
    max_unavailable = 1
  }

  # Enable autoscaling
  tags = {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.eks-cluster.name}" = "owned"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-group-worker-node-policy,
    aws_iam_role_policy_attachment.eks-node-group-cni-policy,
    aws_iam_role_policy_attachment.eks-node-group-registry-read-only-policy
  ]
}

# resource "helm_release" "prometheus_operator_crds" {
#   name = "prometheus-operator-crds"

#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "prometheus-operator-crds"
#   namespace        = "monitoring"
#   create_namespace = true
#   version          = "5.1.0"
# }

# resource "helm_release" "metrics_server" {
#   name = "metrics-server"

#   repository = "https://kubernetes-sigs.github.io/metrics-server/"
#   chart      = "metrics-server"
#   namespace  = "kube-system"
#   version    = "3.11.0"
    
# }

