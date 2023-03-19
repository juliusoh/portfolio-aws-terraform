# Terraform Configuration for Portfolio

This Terraform configuration sets up the infrastructure for my portfolio, including an S3 bucket for the backend, and an OIDC provider for GitHub authentication. 

## Requirements

- Terraform v1.1 or later
- AWS CLI configured with appropriate credentials
- GitHub account with an OIDC provider set up

## Usage

1. Clone the repository: 


2. Navigate to the directory containing the Terraform configuration: 


3. Initialize Terraform: 


## Terraform Configuration Details

### S3 Bucket for Backend

This Terraform configuration creates an S3 bucket to store the backend state for your portfolio. The `backend.tf` file specifies the backend configuration using the S3 bucket you created manually.

### OIDC Provider for GitHub

This Terraform configuration sets up an OIDC provider for GitHub to allow users to authenticate to your portfolio using their GitHub account. The `github-oidc.tf` file sets up the OIDC provider and configures an IAM role with the necessary permissions.

### AWS Role with Trust Relationship

This Terraform configuration creates an IAM role with a trust relationship that allows the OIDC provider to assume the role. The `iam.tf` file defines the IAM role and specifies the trust relationship with the OIDC provider. The `variables.tf` file contains the necessary variables to customize the IAM role with the appropriate conditions. 

## Contributors

- Julius Oh <juliusoh@gmail.com>

## License

This project is licensed under the [MIT License](LICENSE).
