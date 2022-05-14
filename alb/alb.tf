provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_id" {
  default = "vpc-5ab22e31"
}

variable "subnet_id" {
  default = ["subnet-4fc00f10", "subnet-c076848f"]
}

data "aws_vpc" "foo" {

}

data "aws_subnet_ids" "example" {
  vpc_id = data.aws_vpc.foo.id
}

data "aws_subnet" "example" {
  for_each = data.aws_subnet_ids.example.ids
  id       = each.value
}

output "vpc_id" {
  value = data.aws_vpc.foo.id
}

output "alb_dns_name" {
  value = "aws_lb.test.dns_name"
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.example : s.cidr_block]
}

resource "aws_security_group" "allow_alb" {
  name        = "allow_alb"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "alb from VPC"
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
    Name = "allow_alb"
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_alb.id]
#  subnets            = var.subnet_id
  subnets            = data.aws_subnet_ids.example.ids

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.foo.id
  // default 는 instance
  target_type = "ip"

  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 5
    matcher = "200"
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group_attachment" "test-2a" {
  for_each = toset(data.aws_instances.test.private_ips)
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb_target_group_attachment" "test-2a" {
  count = toset(data.aws_instances.test.private_ips)
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = element(data.aws_instances.test.private_ips, count.index)
  port             = 80
}

#resource "aws_lb_target_group_attachment" "test-2a" {
#  target_group_arn = aws_lb_target_group.test.arn
#  target_id        = data.aws_instances.test.private_ips[0]
#  port             = 80
#}
#
#resource "aws_lb_target_group_attachment" "test-2c" {
#  target_group_arn = aws_lb_target_group.test.arn
#  target_id        = data.aws_instances.test.private_ips[1]
#  port             = 80
#}

data "aws_instances" "test" {
  instance_tags = {
    Name = "web-*"
  }
}