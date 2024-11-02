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

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "deploy_karpenter" {
  description = "Control the deployment of karpenter"
  type        = bool
  default     = false
}
