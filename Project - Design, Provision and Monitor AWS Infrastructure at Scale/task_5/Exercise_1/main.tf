# TODO: Designate a cloud provider, region, and credentials


# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2


# TODO: provision 2 m4.large EC2 instances named Udacity M4

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

resource "aws_instance" "udacity-t2" {
  ami = "ami-0ab4d1e9cf9a1215a"
  instance_type = "t2.micro"
  count = 4
  tags = {
    Name = "Udacity T2"
  }
}

resource "aws_instance" "udacity-m4" {
  ami = "ami-0ab4d1e9cf9a1215a"
  instance_type = "m4.large"
  count = 2
  tags = {
    Name = "Udacity M4"
  }
}