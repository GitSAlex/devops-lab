provider "aws" {
    region = var.aws_region
}

resource "aws_subnet" "subnet_a" {
  vpc_id = aws_vpc.cyber_vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = false

  tags = {
    name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
    vpc_id = aws_vpc.cyber_vpc.id
    cidr_block = "10.10.2.0/24"
    availability_zone = "eu-west-1a"
    map_public_ip_on_launch = false

    tags = {
        name = "subnet-b"
    }
}

resource "aws_vpc" "cyber_vpc" {    
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    name = "cyber-vpc"
  }
}

resource "aws_security_group" "internal_ssh" {
  name = "internal-ssh"
  description = "SSH only inside VPC"
  vpc_id = aws_vpc.cyber_vpc.id

  ingress {
    description = "ssh from Sub-a"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.10.1.0/24"]
  }
    ingress {
        description = "ssg from sub-b"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.10.2.0/24"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
}

resource "aws_instance" "node_a" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.internal_ssh.id]
  associate_public_ip_address = false
  key_name = "Key1"

  tags = {
    name = "NodeA"
  }
}

resource "aws_instance" "node_b" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.internal_ssh.id]
  associate_public_ip_address = false
  key_name = "Key1"

  tags = {
    name = "NodeB"
  }
}