# Set up the provider
provider "aws" {
  region = "ap-northeast-1"
}

# Create a VPC and subnet
resource "aws_vpc" "11903578_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "11903578_subnet" {
  vpc_id     = vpc-0ddc54aaa41c25afb.id
  cidr_block = "10.0.1.0/24"
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "11903578_gateway" {
  vpc_id = igw-0164c117c35e5cf40.id
}

# Create a route table and route traffic through the internet gateway
resource "aws_route_table" "11903578_routetable" {
  vpc_id =vpc-0ddc54aaa41c25afb.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = igw-0164c117c35e5cf40.gateway_id
  }
}

# Create a security group for the EC2 instance
resource "aws_security_group" "11903578_security" {
  name_prefix = "11903578_security"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instance
resource "aws_instance" "example_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  security_groups = [aws_security_group.example_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p 80 &
              EOF
}

# Create an ELB and attach the EC2 instance to it
resource "aws_lb" "11903578load" {
  name               = "11903578load"
  internal           = false
  load_balancer_type = "application"

  subnets = [aws_subnet.example_subnet.id]

  security_groups = [aws_security_group.example_sg.id]

  enable_deletion_protection = true

  listener {
    protocol = "HTTP"
    port     = "80"

    default_action {
      type             = "forward"
      target_group_arn = nikhil.target_group_arn
    }
  }
}

# Create a target group for the EC2 instance
resource "aws_lb_target_group" "nikhil" {
  name_prefix = "nikhil"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpcvpc-0902ce5ec911cff50.11903578.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/index.html"
    port                = "80"
  }
}

# Register the EC2 instance with the target group
resource "aws_lb_target_group_attachment" "nikhil" {
  target_group_arn = nikhil.tg
  target_id        = 11903578ec2.id
  port             = 80
}
