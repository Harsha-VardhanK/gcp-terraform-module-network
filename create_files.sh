#!/usr/bin/env bash

# Create directories
mkdir -p examples/simple

# Create files in the current directory
touch \
  main.tf \
  variables.tf \
  outputs.tf \
  versions.tf \
  examples/simple/main.tf \
  examples/simple/terraform.tfvars

echo "Terraform structure created in current directory."
