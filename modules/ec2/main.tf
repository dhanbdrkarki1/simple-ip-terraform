# Web Server
resource "aws_instance" "web_server" {
  ami               = var.ami # us-west-2
  instance_type     = var.type
  availability_zone = var.az[0]
  key_name          = var.key_pair
  associate_public_ip_address = true
  subnet_id = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.web_security_group]
  
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo bash -c 'echo "This is the first web server." > /var/www/html/index.html'
            EOF
  tags = {
    Name = "web_server_1"
  }
}





# Bastion Host
# resource "aws_instance" "bastion_server" {
#   ami               = var.ami # us-west-2
#   instance_type     = var.type
#   availability_zone = var.az[0]
#   key_name          = var.key_pair
#   associate_public_ip_address = true
#   subnet_id = var.private_subnet[0]
#   vpc_security_group_ids = [var.web_security_group]
  
#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo yum install httpd -y
#               sudo systemctl start httpd
#               sudo bash -c 'echo "This is the first web server." > /var/www/html/index.html'
#             EOF
#   tags = {
#     Name = "Bastion_Host"
#   }
# }