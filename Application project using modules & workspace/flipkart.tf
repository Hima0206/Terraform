provider "aws" {
  alias = "ap-south-1"
  region = "ap-south-1"
}

module "flipkart_network" {
  source = "./Modules/network"
  vpc_cidr = "10.30.0.0/16"
  subnet_cidr = "10.30.3.0/24"
  providers = {
    aws = aws.ap-south-1        
  }
}

module "flipkart_compute" {
  source = "./Modules/compute"
  ami_id = data.aws_ami.linux_ap_south.id
  instance_type = "t2.micro" 
  instance_count = 2
  subnet_id = module.flipkart_network.subnet_id
  security_group_id = module.flipkart_network.security_group_id
  instance_name = "flipkart_instance"

  providers = {
    aws = aws.ap-south-1        
  }
}