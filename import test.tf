variable "ami" {}


provider "aws" {
   shared_credentials_file = "C:/Users/user/.aws/credentials"
   region     = "us-east-1"
}

resource "aws_security_group" "makkusg" {
  name        = "makku_sg"
  description = "Allow TLS inbound traffic"
  vpc_id="${aws_vpc.mvvpc.id}"

  ingress {   
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { 
    from_port   = 443
    to_port     = 443
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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "makku" {
   ami = "${var.ami}"
   instance_type="t2.micro"
   vpc_security_group_ids=["${aws_security_group.makkusg.id}"]
   key_name="key"
   subnet_id="${aws_subnet.mvpubsub.id}"
   associate_public_ip_address="True"
   user_data= <<-EOF
              #!/bin/bash
              yum -y install httpd
              service httpd start
              yum -y install git
              cd /home/ec2-user
              git clone https://github.com/makarandshenoy/webpage.git 
              cp /home/ec2-user/webpage/index.html /var/www/html
              EOF
  

     provisioner "local-exec" {
    command = "echo ${aws_instance.makku.public_ip} > file.txt"
  }
   }

   resource "aws_instance" "makku1" {
   ami = "${var.ami}"
   instance_type="t2.micro"
   vpc_security_group_ids=["${aws_security_group.makkusg.id}"]
   key_name="key"
   subnet_id="${aws_subnet.mvprivsub.id}"
   
   }
  

output "aws_instance_public_IP" {
  value = "${aws_instance.makku.public_ip}"
}

  


