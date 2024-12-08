provider "helm" {
    kubernetes {
      host                  = aws_eks_cluster.eks-cluster.endpoint
      cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
      exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "aws"
        args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks-cluster.id]
      }
    }
}

# resource "helm_release" "aws-load-balancer-controler" {
#     name = "aws-load-balancer-controller"

#     repository = "https://aws.github.io/eks-charts"
#     chart = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     version = "1.4.1"

#     set {
#         name = "clusterName"
#         value = aws_eks_cluster.eks-cluster.id
#     }

#     set {
#        name = "image.tag"
#        value = "v2.4.2"
#     }

#     set {
#         name = "serviceAccount.name"
#         value = "aws-load-balancer-controller"
#     }

#     set  {
#         name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#         value = aws_iam_role.aws_load_balancer_controller.arn
#     }
# }

resource "helm_release" "karpenter" {
  count = var.deploy_karpenter ? 1 : 0
  
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.13.1"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller[0].arn
  }

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks-cluster.id
  }

  set {
    name  = "clusterEndpoint"
    value = aws_eks_cluster.eks-cluster.endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter[0].name
  }

  depends_on = [aws_eks_node_group.eks-node-group]
}
