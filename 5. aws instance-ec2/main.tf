resource "aws_instance" "webserver" {
  ami           = "ami-084a7d336e816906b"  # Example: Ubuntu AMI
  instance_type = "t2.nano"
    tags = {
    Name        = "webserver"
    Description = "An Nginx webserver on Ubuntu"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    sudo systemctl enable nginx
    sudo systemctl start nginx
  EOF

  key_name = aws_key_pair.web.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
}
resource "aws_key_pair" "web" {
    public_key = file("C:/Users/MarvinO/.ssh/marvin_aws.pub")
}
resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  description = "allow SSH access from the Internet"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "publicIP" {
  value = aws_instance.webserver.public_ip
}