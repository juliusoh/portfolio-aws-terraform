resource "aws_iam_role" "eks_role" {
  name = "tf-${var.stack_name}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "eks-node-group" {
  name = "tf-${var.stack_name}-eks-node-group-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "lb_controller_role" {
  name = "tf-${var.stack_name}-lb-controller-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [{
  	"Effect": "Allow",
  	"Principal": {
  		"Federated": "arn:aws:iam::${var.account_id}:oidc-provider/${aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer}"
  	},
  	"Action": "sts:AssumeRoleWithWebIdentity",
  	"Condition": {
  		"StringEquals": {
  			"${aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer}:aud": "sts.amazonaws.com",
  			"${aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
  		}
  	}
  }]
}
POLICY
}

data "tls_certificate" "eks" {
    url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
    url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "aws_load_balancer_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  count = var.deploy_lb_controller ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_assume_role_policy.json
  name               = "aws-load-balancer-controller-${var.stack_name}"
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  count = var.deploy_lb_controller ? 1 : 0
  role       = aws_iam_role.aws_load_balancer_controller[0].name
  policy_arn = aws_iam_policy.lb-controller[0].arn
}

output "aws_load_balancer_controller_role_arn" {
  value = var.deploy_lb_controller ? aws_iam_role.aws_load_balancer_controller[0].arn : null
}

data "template_file" "iam_policy" {
  template = file("${path.module}/iam.tpl")
}

resource "aws_iam_policy" "lb-controller" {
  count = var.deploy_lb_controller ? 1 : 0
  name = "tf-${var.stack_name}-lb-controller-policy"
  policy = data.template_file.iam_policy.rendered
}

resource "aws_iam_role_policy_attachment" "lb-controller-policy" {
  count = var.deploy_lb_controller ? 1 : 0
  policy_arn = aws_iam_policy.lb-controller[0].arn
  role       = aws_iam_role.lb_controller_role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-security-group-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks-node-group-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "eks-node-group-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "eks-node-group-registry-read-only-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group.name
}
