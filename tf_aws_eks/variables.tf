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
      name    = "aws-ebs-csi-driver"
      version = "v1.26.0"
    }
  ]
}