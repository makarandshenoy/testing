variable "aws_access_key" {
      default = "AKIAIX2PZSP5ZFZ5YQSA"
  }
variable "aws_secret_key" {
     default = "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"
  }

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
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
   ami = "ami-0080e4c5bc078760e"
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
              cp /home/ec2-user/Test1/index.html /var/www/html
              EOF
  

     provisioner "local-exec" {
    command = "echo ${aws_instance.makku.public_ip} > file.txt"
  }
   }

   resource "aws_instance" "makku1" {
   ami = "ami-0080e4c5bc078760e"
   instance_type="t2.micro"
   vpc_security_group_ids=["${aws_security_group.makkusg.id}"]
   key_name="key"
   subnet_id="${aws_subnet.mvprivsub.id}"
   
   }
  

output "aws_instance_public_IP" {
  value = "${aws_instance.makku.public_ip}"
}

  


