/*
provider "aws" {
  region = "us-east-1b"
}
*/
######### Subnets #################
resource "aws_subnet" "mySubnet_4" {
  vpc_id     = aws_vpc.myVpc.id # Argument
  cidr_block = "10.0.0.96/27"
  tags = {
    Name = "PUBLIC SUBNET 1b"
  }
}
resource "aws_subnet" "mySubnet_5" {
  vpc_id     = aws_vpc.myVpc.id # Argument
  cidr_block = "10.0.0.128/27"
  tags = {
    Name = "PRIVATE SUBNET 1b"
  }
}
resource "aws_subnet" "mySubnet_6" {
  vpc_id     = aws_vpc.myVpc.id # Argument 
  cidr_block = "10.0.0.160/27"
  tags = {
    Name = "PRIVATE DB SUBNET 1b"
  }
}