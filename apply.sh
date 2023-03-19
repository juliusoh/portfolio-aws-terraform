#!/bin/bash -e

echo
echo "##############################################################################"
echo
echo "                           Deploying juliusoh Infrastructure"
echo
echo "##############################################################################"
echo

echo "Running Terraform Apply"

terraform apply -parallelism=10 plan.out