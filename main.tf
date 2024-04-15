provider "aws" {
  region = "ap-northeast-2"
  access_key = ""
  secret_key = ""
}

resource "aws_key_pair" "kafka_practice_key_pair" {
  key_name   = "kafka_practice_key_pair"
  public_key = file("${path.module}/publicKey.pub")
}

resource "aws_vpc" "kafka_practice_vpc" {
  cidr_block = "10.0.0.0/16"

    tags = {
        Name = "kafka_practice_vpc"
    }
}

resource "aws_subnet" "kafka_practice_subnet" {
  vpc_id = aws_vpc.kafka_practice_vpc.id
  cidr_block = "10.0.1.0/24"

    tags = {
        Name = "kafka_practice_subnet"
    }
}

resource "aws_security_group" "kafka_practice_security_group" {
  name = "kafka_practice_security_group"
  description = "security group for kafka practice(allow all inbound/outbound traffic)"
  vpc_id = aws_vpc.kafka_practice_vpc.id

  tags = {
    Name = "kafka_practice_security_group"
  }
}

resource "aws_instance" "kafka_01" {
  ami = "ami-050a4617492ff5822" # Amazon Linux 2 AMI
  instance_type = "t3.medium"
  subnet_id = aws_subnet.kafka_practice_subnet.id
  key_name = aws_key_pair.kafka_practice_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.kafka_practice_security_group.id]

  tags = {
    Name = "peter-kafka01"
  }
}