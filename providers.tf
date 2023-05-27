provider "aws" {
  region      = var.region
  max_retries = "100"

  # assume_role {
  #   role_arn = "arn:aws:iam::673692536255:role/gha_oidc_assume_role"
  # }
}
