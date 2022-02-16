
provider "aws" {
  region     = "us-east-1"
  access_key = "XXXXXX"
  secret_key = "XXXXXXXXXXXX"
}

###########  VPC block ##################
resource "aws_vpc" "myVpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "WINTERFELL"
  }
}
/*
######### Creating Nat Gateway ########
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.mySubnet_1.id
  tags = {
    Name = "NAT Gateway Public Subnet"
  }
}
# Add routes for VPC
resource "aws_route_table" "myVpc-private" {
  vpc_id = aws_vpc.myVpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "private route table"
  }
}
# Creating route associations for private Subnets
resource "aws_route_table_association" "myVpc-private-1-a" {
  subnet_id      = aws_subnet.mySubnet_2.id
  route_table_id = aws_route_table.myVpc-private.id
}
/*
resource "aws_route_table_association" "myVpc-private-2-a" {
subnet_id      = aws_subnet.myVpc-private-2.id
route_table_id = aws_route_table.myVpc-private.id
}
*/
##########  Internet Gateway ############
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myVpc.id
  tags = {
    Name = "IGW"
  }
}
######### Subnets #################
resource "aws_subnet" "mySubnet_1" {
  vpc_id     = aws_vpc.myVpc.id # Argument
  cidr_block = "10.0.0.0/27"
  tags = {
    Name = "PUBLIC SUBNET 1a"
  }
}
resource "aws_subnet" "mySubnet_2" {
  vpc_id     = aws_vpc.myVpc.id # Argument
  cidr_block = "10.0.0.32/27"
  tags = {
    Name = "PRIVATE SUBNET 1a"
  }
}
resource "aws_subnet" "mySubnet_3" {
  vpc_id     = aws_vpc.myVpc.id # Argument
  cidr_block = "10.0.0.192/27"
  tags = {
    Name = "PRIVATE DB SUBNET 1a"
  }
}
############ Route Table ###################
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myVpc.id
  route = []
  tags = {
    Name = "EXAMPLE"
  }
}
########### Route #####################
resource "aws_route" "route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.rt]
}
################# Route Table Associations #################
resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.mySubnet_1.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.mySubnet_2.id
  route_table_id = aws_route_table.rt.id
}
######### Security Group ###################
resource "aws_security_group" "sg" {
  name        = "allow_all_traffic"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.myVpc.id
  ingress = [
    {
      description      = "All traffic"
      from_port        = 0    # All ports
      to_port          = 0    # All Ports
      protocol         = "-1" # All traffic
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    Name = "ALL_TRAFFIC"
  }
}
################ EC2 Instances ##########################
resource "aws_instance" "ec2_1" {
  ami           = "ami-033b95fb8079dc481"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mySubnet_1.id
  
  tags = {
    Name = "BASTION"
  }
}
resource "aws_instance" "ec2_2" {
  ami           = "ami-038b3df3312ddf25d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mySubnet_2.id
  
  tags = {
    Name = "WEBSERVER 1"
  }
}
