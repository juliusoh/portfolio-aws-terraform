provider "aws" {
  region      = var.region
  max_retries = "100"

  assume_role {
    role_arn = "arn:aws:iam::939919218449:role/julius_role"
  }
}set -e

# Authenticate to AWS using the IAM role
aws configure set role_arn "$AWS_ROLE_ARN"
aws configure set source_profile default

# Initialize the Terraform backend
terraform init -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="key=$TF_STATE_KEY"

# Run a Terraform plan and store the output in a file
terraform plan -out=tfplan.out