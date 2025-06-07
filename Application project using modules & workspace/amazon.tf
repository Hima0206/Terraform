provider "aws" {
  alias = "us-east"
  region = "us-east-1"
}

module "amazon_network" {
  source = "./Modules/network"
  vpc_cidr = "10.10.0.0/16"
  subnet_cidr = "10.10.1.0/24"

  providers = {
    aws = aws.us-east
  } 
}

module "amazon_compute" {
  source = "./Modules/compute"
  ami_id = data.aws_ami.linux_us_east.id
  instance_type = "t2.micro"
  instance_count = 2
  subnet_id = module.amazon_network.subnet_id
  security_group_id = module.amazon_network.security_group_id
  instance_name = "amazon_instance"

    providers = {
      aws = aws.us-east
    }   
}

