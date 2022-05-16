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

resource "aws_subnet" "subnet-pri2-10-0-3-0" {
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