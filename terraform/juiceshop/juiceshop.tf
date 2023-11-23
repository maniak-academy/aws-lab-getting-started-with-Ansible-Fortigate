
variable "fwsshkey" {
  description = "The fwsshkey where the EC2 instance will be deployed"
}
variable "customer_vpc_id" {
  description = "The customer_vpc_id where the EC2 instance will be deployed"
}
variable "csprivatesubnetaz1" {

}

resource "aws_instance" "juiceshop_ec2" {
  ami             = "ami-0694d931cee176e7d" # Replace with the latest Ubuntu 20.04 AMI in your region
  instance_type   = "t2.micro"
  subnet_id       = var.csprivatesubnetaz1
  key_name        = var.fwsshkey
  associate_public_ip_address = true  # This line is added to associate a public IP
  vpc_security_group_ids      = [aws_security_group.juiceshop_sg.id] # Attach the security group

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              sudo apt-get update
              sudo apt-get install -y docker-ce
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo docker run --rm -d -p 80:3000 bkimminich/juice-shop
              EOF

  tags = {
    Name = "juiceshopServer"
  }
}

resource "aws_security_group" "juiceshop_sg" {
  name        = "juiceshop_sg"
  description = "Allow inbound traffic on port 80 and all outbound traffic"
  vpc_id      = var.customer_vpc_id  # Replace this with your VPC ID if needed

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Allows traffic from any IP address. Narrow this down as necessary for your use case.
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Allows traffic from any IP address. Narrow this down as necessary for your use case.
  }
  egress {
    description      = "All traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Allows all traffic
    cidr_blocks      = ["0.0.0.0/0"] # Allows traffic to any IP address
  }

  tags = {
    Name = "juiceshop_sg"
  }
}


output "juiceshop_public_ip" {
  value = aws_instance.juiceshop_ec2.public_ip
}

output "juiceshop_private_ip" {
  value = aws_instance.juiceshop_ec2.private_ip
}
