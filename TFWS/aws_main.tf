resource "aws_vpc" "webapp_vpc" {
  cidr_block = var.aws_vpc_cidr
  tags = {
    Name = "webapp-vpc"
  }
} 

resource "aws_subnet" "webapp_submet" {
  count = length(var.aws_subnet_cidr)
  vpc_id = aws_vpc.webapp_vpc.id
  cidr_block = var.aws_subnet_cidr[count.index]
  map_public_ip_on_launch = true  
  availability_zone = var.aws_subnet_az[count.index]
  tags = {
    Name = "webapp-subnet-${count.index}"
  }
  
}

resource "aws_internet_gateway" "webapp_igw" {
  vpc_id = aws_vpc.webapp_vpc.id
  tags = {
    Name = "webapp-igw"
  }
}


resource "aws_route_table" "webapp_route_table" {
  vpc_id = aws_vpc.webapp_vpc.id
  tags = {
    Name = "webapp-route-table"
  }

  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webapp_igw.id 
  }
}    

resource "aws_route_table_association" "webapp_route_table_association" {
  count = length(var.aws_subnet_cidr)
  subnet_id = aws_subnet.webapp_submet[count.index].id
  route_table_id = aws_route_table.webapp_route_table.id
}

resource "aws_instance" "webapp_instance" {
  ami = var.aws_ami_id
  instance_type = var.aws_instance_type
  subnet_id = aws_subnet.webapp_submet[0].id
  associate_public_ip_address = true
  tags = {
    Name = "webapp-instance"
  }
  
}