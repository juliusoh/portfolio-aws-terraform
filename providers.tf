provider "aws" {
  region      = var.region
  max_retries = "100"

  assume_role {
    role_arn = var.AWS_ROLE_ARN
  }
}
