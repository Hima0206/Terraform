terraform {
    backend "s3" {
        bucket         = "tfassignbucket"
        key            = "terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "terraform-lock-table"
        encrypt        = true
    }
    required_providers {    
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.99.1"
        }
    }
}

