terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "default" {
  default = true
}


resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg-2"
  description = "Allow SSH and Minecraft access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Minecraft"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minecraft-sg-2"
  }
}

resource "tls_private_key" "mc_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content              = tls_private_key.mc_key.private_key_pem
  filename             = "${pathexpand("~/mc_terraform_key.pem")}"
  file_permission      = "0600"
  directory_permission = "0700"
}


resource "aws_key_pair" "mc_key" {
  key_name   = "mc_terraform_key"
  public_key = tls_private_key.mc_key.public_key_openssh
}

resource "aws_instance" "minecraft_server" {
  ami           = "ami-0ec1ab28d37d960a9"
  instance_type = "t3.small"
  key_name      = aws_key_pair.mc_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = "minecraft-server"
  }
}
