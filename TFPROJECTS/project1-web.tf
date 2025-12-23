provider "aws" {
    region = "us-east-1"
    profile = "default"
    AWS_ACCESS_KEY = AKIATESTBANHYDMUMDL
}


# This Terraform script creates a VPC, a public subnet, a security group, and an EC2 instance with Apache installed.

resource "aws_security_group" "web_sg" {
    name        = "project1-web-sg"
    description = "Allow HTTP and SSH traffic"
    vpc_id      = aws_vpc.project1_vpc.id
    # Removed invalid attribute 'subnet_id'
    # Attach the security group to the VPC

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]                       
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }   

    tags = {
        Name        = "project1-web-sg"
        Environment = "dev"
    }
}


resource "aws_vpc" "project1_vpc" {
    cidr_block = "172.10.0.0/16" # Adjust CIDR block as needed
    tags = {
        Name        = "project1-vpc"
        Environment = "dev"
    }       
}

resource "aws_internet_gateway" "project1_igw" {
    vpc_id = aws_vpc.project1_vpc.id

    tags = {
        Name        = "project1-igw"
        Environment = "dev"
    }       
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.project1_vpc.id
  availability_zone = "us-east-1a" # Adjust as needed
  cidr_block = "172.10.0.0/25" # Adjust CIDR block as needed
  map_public_ip_on_launch = true # Enable public IP assignment

  tags = {
    Name = "Main"
  }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.project1_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.project1_igw.id   
    }
}

resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.main.id
    route_table_id = aws_route_table.public.id
  
}
resource "aws_key_pair" "project1_key" {
    key_name   = "project1-key"
    public_key = file("~/.ssh/id_rsa.pub") # Adjust path to your public key
}

resource "aws_instance" "web_server_1" {
    ami           = "ami-0b86aaed8ef90e45f" # Amazon Linux 2 AMI
    instance_type = "t2.micro"
    security_groups =   [aws_security_group.web_sg.id] # Attach the security group to the instance 
    subnet_id    = aws_subnet.main.id # Attach the instance to the subnet
    key_name      = aws_key_pair.project1_key.key_name
    associate_public_ip_address = true # Enable public IP address

    tags = {
        Name        = "project1-web-server"
        Environment = "dev"
    }       

    provisioner "remote-exec" {
        connection {
            type        = "ssh"
            host        = self.public_ip
            user        = "ec2-user"    
            private_key = file("~/.ssh/id_rsa") # Adjust path to your private key
        }

        inline = [
            "sudo yum update -y",
            "sudo yum install -y httpd",
            "sudo systemctl start httpd",       
            "sudo systemctl enable httpd",
            "echo '<h1>Hello from Terraform!</h1>' | sudo tee /var/www/html/index.html",            

            "sudo systemctl restart httpd"
        ]      
    }
}

resource "aws_ebs_volume" "project1_ebs" {
    availability_zone = aws_instance.web_server_1.availability_zone
    # Attach the EBS volume to the same availability zone as the instance
    size              = 10 # Size in GB
    tags = {
        Name        = "project1-ebs-volume"
        Environment = "dev"
    }                     
}

resource "aws_volume_attachment" "project1_volume_attachment" {
    device_name = "/dev/sdh"
    volume_id   = aws_ebs_volume.project1_ebs.id
    instance_id = aws_instance.web_server_1.id

    depends_on = [aws_instance.web_server_1, aws_ebs_volume.project1_ebs] # Ensure the instance and volume are created before attaching the volume
    # This is important
    # Ensure the instance is created before attaching the volume    
    # and the volume is created before attaching it to the instance
    # This is important     
  
}

output "web_server_ip" {
    value = aws_instance.web_server_1.public_ip

    description = "Public IP of the web server"     

}

