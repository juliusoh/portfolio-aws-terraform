data "aws_iam_policy_document" "karpenter_controller_assume_role_policy" {
  count = var.deploy_karpenter ? 1 : 0
  
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {
  count = var.deploy_karpenter ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.karpenter_controller_assume_role_policy[count.index].json
  name               = "karpenter-controller"
}

resource "aws_iam_policy" "karpenter_controller" {
  count = var.deploy_karpenter ? 1 : 0
  policy = file("${path.module}/controller-trust-policy.json")
  name   = "KarpenterController"
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach_karpenter" {
  count = var.deploy_karpenter ? 1 : 0
  role       = aws_iam_role.karpenter_controller[0].name
  policy_arn = aws_iam_policy.karpenter_controller[0].arn
}

resource "aws_iam_instance_profile" "karpenter" {
  count = var.deploy_karpenter ? 1 : 0
  name = "KarpenterNodeInstanceProfile"
  role = aws_iam_role.eks-node-group.name
}
