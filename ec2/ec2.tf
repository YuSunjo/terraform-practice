
provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_id" {
  default = "vpc-5ab22e31"
}

data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_security_group" "allow_web" {
  name = "allow_web"
  description = "allow web inbound traffic"
  vpc_id = var.vpc_id // 위에 variable 참조

  ingress {
    description      = "web from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }

}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"
  key_name = "tf-key-pair"
  vpc_security_group_ids = [aws_security_group.allow_web.id] // 위에꺼 참조

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "web"
  }
}