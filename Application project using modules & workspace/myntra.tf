provider "aws" {
  alias  = "us-west"
  region = "us-west-2"
}

module "myntra_network" {
  source = "./Modules/network"
  vpc_cidr = "10.20.0.0/16"
  subnet_cidr = "10.20.2.0/24"
    providers = {
        aws = aws.us-west
    }   
}

module "myntra_compute" {
  source = "./Modules/compute"
  ami_id = data.aws_ami.linux_us_west.id
  instance_type = "t2.small"
  instance_count = 2
  subnet_id = module.myntra_network.subnet_id
  security_group_id = module.myntra_network.security_group_id
  instance_name = "myntra_instance"

    providers = {
        aws = aws.us-west
    }   
}

