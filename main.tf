#Creating VPC
resource "aws_vpc" "set32-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "set32-vpc"
  }
}

#Creating subnet
resource "aws_subnet" "set32-subnet" {
  vpc_id     = aws_vpc.set32-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

#Creating Internet Gateway
resource "aws_internet_gateway" "set32-igw" {
  vpc_id = aws_vpc.set32-vpc.id

  tags = {
    Name = "set32-igw"
  }
}

#Creating Route Table
resource "aws_route_table" "set32-rt" {
  vpc_id = aws_vpc.set32-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.set32-igw.id
  }

  tags = {
    Name = "set32-rt"
  }
}

#Creating Route Table Association
resource "aws_route_table_association" "set32-rta" {
  subnet_id      = aws_subnet.set32-subnet.id
  route_table_id = aws_route_table.set32-rt.id
}

#Creating Security Group
resource "aws_security_group" "set32-sg" {
  name        = "set32-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.set32-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "set32-sg"
  }
}

#tls key pair
resource "tls_private_key" "set32-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Creating local file for private key
resource "local_file" "set32-key-file" {
  content         = tls_private_key.set32-key.private_key_pem
  filename        = "./set32-key.pem"
  file_permission = "400"
}

#creating public key
resource "aws_key_pair" "set32-key-pair" {
  key_name   = "set32-key-pair"
  public_key = tls_private_key.set32-key.public_key_openssh
}

#Creating EC2 instance
resource "aws_instance" "set32-instance" {
  ami                         = "ami-0884bba1ac5619645" # Redhat AMI (HVM), SSD Volume Type
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.set32-subnet.id
  key_name                    = aws_key_pair.set32-key-pair.key_name
  vpc_security_group_ids      = [aws_security_group.set32-sg.id]
  associate_public_ip_address = true
  user_data                   = file("./user_data.sh")

  tags = {
    Name = "set32-instance"
  }
}