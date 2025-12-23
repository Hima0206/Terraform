provider "aws" {
  region = var.aws_region
  profile = "default"
  AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7XEAPMEL"
  AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"


}

# This provider block specifies the AWS region to use for deploying resources.
# The region is set using a variable called "aws_region", which can be defined in a separate variables file or passed in as an argument when running Terraform.





