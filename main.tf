// Get latest AMI for Ubuntu 18.04
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

// Create and associate Elastic IP to web host
resource "aws_eip" "web_eip" {
  
  instance = aws_instance.web.id
  vpc      = true
  
}

resource "aws_key_pair" "webkey" {
  key_name   = "web-key"
  public_key = var.web_pkey
}

// Create web host instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = aws_key_pair.webkey.key_name

  user_data = <<-EOF
               #!/bin/bash
               echo "cwiczonko z terraforma \n Chaosgears" > index.html
               nohup busybox httpd -f -p 80 &
               EOF

  tags = {
    Name = "Webserver_host"
  }

}