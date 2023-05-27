variable "github_url" {
  description = "URL of Github for TLS certificate"
  type        = string
  default     = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

variable "oidc_url" {
  description = "URL for the OIDC Provider"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "client_id_list" {
  description = "Client ID list for OIDC Provider"
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}

variable "org_repo" {
  description = "Organization and repository in Github for role assignment"
  type        = string
}

variable "allowed_actions" {
  description = "List of allowed actions in IAM policy"
  type        = list(string)
  default     = ["sns:*", "lambda:*", "iam:*", "s3:*"]
}

data "tls_certificate" "github" {
  url = var.github_url
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = var.oidc_url
  client_id_list  = var.client_id_list
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "gha_oidc_assume_role" {
  name = "gha_oidc_assume_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Principal : {
          Federated : aws_iam_openid_connect_provider.github_actions.arn
        },
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringEquals : {
            
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
                          StringLike: {
                    "token.actions.githubusercontent.com:sub" : ["repo:${var.org_repo}"],
                }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "gha_oidc_terraform_permissions" {
  name = "gha_oidc_terraform_permissions"
  role = aws_iam_role.gha_oidc_assume_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = var.allowed_actions
        Effect = "Allow"
        Resource = "*"
      },
    ]
  })
}

output "role_arn" {
  value = aws_iam_role.gha_oidc_assume_role.arn
}
