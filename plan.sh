#!/bin/bash -e

echo
echo "##############################################################################"
echo
echo "                           Planning juliusoh Infrastructure"
echo
echo "##############################################################################"
echo
# Initialize the Terraform backend
terraform init -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="key=$TF_STATE_KEY"

# Run a Terraform plan and store the output in a file
terraform plan -out=plan.out