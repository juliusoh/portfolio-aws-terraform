variable "instance_types" {
  type = list(string)
}

variable "deploy_argocd" {
  description = "Control the deployment of argocd"
  type        = bool
  default     = false
}

variable "region" {}

variable "stack_name" {}

variable "subnet_ids" {}

variable "account_id" {}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      version = "v1.21.2-eksbuild.2"
    },
    {
      name    = "vpc-cni"
      version = "v1.10.1-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.8.4-eksbuild.1"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.4.0-eksbuild.preview"
    }
  ]
}