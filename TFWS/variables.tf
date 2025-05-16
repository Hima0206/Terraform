variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  
}

variable "aws_subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = list
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "aws_subnet_az" {
  description = "The availability zone for the subnet"
  type        = list
  default     = ["us-east-1a", "us-east-1b"]
}

variable "aws_instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  
}

variable "aws_ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  
}