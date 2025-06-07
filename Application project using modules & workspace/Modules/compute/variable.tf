variable "instance_name" {
  type        = string
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "value of the AMI ID to use for the instance"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "subnet_id" {
  description = "ID of the subnet where the instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group to associate with the instance"
  type        = string
}