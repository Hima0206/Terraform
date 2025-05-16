provider "aws" {
  region = var.aws_region
  profile = "default"
}

# This provider block specifies the AWS region to use for deploying resources.
# The region is set using a variable called "aws_region", which can be defined in a separate variables file or passed in as an argument when running Terraform.


