provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_key_pair" "terraform-tf-key-pair" {
  key_name   = "tf-key-pair"
  public_key = file("/home/ec2-user/.ssh/tf-key-pair.pub")
}