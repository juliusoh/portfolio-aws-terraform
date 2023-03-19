provider "aws" {
  region      = var.region
  max_retries = "100"

  assume_role {
    role_arn = "arn:aws:iam::939919218449:role/julius_role"
  }
}
