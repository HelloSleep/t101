provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_security_group" "instance" {
  name = "t101sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "example" {
  ami                    = "ami-0c9c942bd7bf113a2"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-dbc571b0" 
  private_ip             = "172.31.1.100"
  key_name               = "onboarding" # 각자 자신의 EC2 SSH Keypair 이름 지정

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, T101 Study" > index.html
              nohup busybox httpd -f -p 80 &
              EOF

  tags = {
    Name = "Single-WebSrv"
  }

#   provisioner "remote-exec" {
#     inline = [
#       "echo ${aws_eip.myeip.public_ip}"
#      ]
#   }
}

resource "aws_eip" "myeip" {
  #vpc = true
  instance = aws_instance.example.id
  associate_with_private_ip = "172.31.1.100"
}

resource "null_resource" "echomyeip" {
  provisioner "remote-exec" {
    connection {
      host = aws_eip.myeip.public_ip
      type = "ssh"
      user = "ubuntu"
      # private_key =  file("/Users/gasida/.ssh/onboarding.pem") # 각자 자신의 EC2 SSH Keypair 파일 위치 지정
      #password = "qwe123"
    }
    inline = [
      "echo ${aws_eip.myeip.public_ip}"
      ]
  }
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}