
provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_id" {
  default = "vpc-5ab22e31"
}

variable "subnet_id" {
  default = ["subnet-4fc00f10", "subnet-c076848f"]
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

resource "aws_instance" "web-2a" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"
  key_name = "tf-key-pair"
  vpc_security_group_ids = [aws_security_group.allow_web.id] // 위에꺼 참조
  availability_zone = "ap-northeast-2c"
  subnet_id = var.subnet_id[1]
  user_data = file("./init-script.sh")

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "web-2a"
  }
}

resource "aws_instance" "web-2c" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"
  key_name = "tf-key-pair"
  vpc_security_group_ids = [aws_security_group.allow_web.id] // 위에꺼 참조
  availability_zone = "ap-northeast-2c"
  subnet_id = var.subnet_id[1]
  user_data = file("./init-script.sh")

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "web-2c"
  }
}