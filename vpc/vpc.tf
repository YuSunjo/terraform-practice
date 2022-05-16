provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "vpc_10-0-0-0" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_10-0-0-0"
  }
}

resource "aws_subnet" "subnet-pub1-10-0-1-0" {
  vpc_id     = aws_vpc.vpc_10-0-0-0.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-pub1-10-0-1-0"
  }
}

resource "aws_subnet" "subnet-pub2-10-0-2-0" {
  vpc_id     = aws_vpc.vpc_10-0-0-0.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-pub1-10-0-2-0"
  }
}

resource "aws_subnet" "subnet-pri1-10-0-3-0" {
  vpc_id     = aws_vpc.vpc_10-0-0-0.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "subnet-pub1-10-0-3-0"
  }
}

resource "aws_subnet" "subnet-pri2-10-0-4-0" {
  vpc_id     = aws_vpc.vpc_10-0-0-0.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "subnet-pub1-10-0-4-0"
  }
}

resource "aws_internet_gateway" "igw-vpc-10-0-0-0" {
  vpc_id = aws_vpc.vpc_10-0-0-0.id

  tags = {
    Name = "igw-vpc-10-0-0-0"
  }
}

resource "aws_route_table" "rt-pub-vpc-10-0-0-0" {
  vpc_id = aws_vpc.vpc_10-0-0-0.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-vpc-10-0-0-0
  }

  tags = {
    Name = "rt-pub-vpc-10-0-0-0"
  }
}

resource "aws_route_table_association" "rt-pub-as1-vpc-10-0-0-0" {
  subnet_id      = aws_subnet.subnet-pub1-10-0-1-0
  route_table_id = aws_route_table.rt-pub-vpc-10-0-0-0
}

resource "aws_route_table_association" "rt-pub-as2-vpc-10-0-0-0" {
  subnet_id      = aws_subnet.subnet-pub2-10-0-2-0
  route_table_id = aws_route_table.rt-pub-vpc-10-0-0-0
}

resource "aws_route_table" "rt-pri1-vpc-10-0-0-0" {
  vpc_id = aws_vpc.vpc_10-0-0-0.id

  tags = {
    Name = "rt-pri1-vpc-10-0-0-0"
  }
}

resource "aws_route_table" "rt-pri2-vpc-10-0-0-0" {
  vpc_id = aws_vpc.vpc_10-0-0-0.id

  tags = {
    Name = "rt-pri2-vpc-10-0-0-0"
  }
}

resource "aws_route_table_association" "rt-pri1-as1-vpc-10-0-0-0" {
  subnet_id      = aws_subnet.subnet-pri1-10-0-3-0
  route_table_id = aws_route_table.rt-pri1-vpc-10-0-0-0
}

resource "aws_route_table_association" "rt-pri-as2-vpc-10-0-0-0" {
  subnet_id      = aws_subnet.subnet-pri2-10-0-4-0
  route_table_id = aws_route_table.rt-pri2-vpc-10-0-0-0
}
