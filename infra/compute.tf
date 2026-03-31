resource "aws_instance" "xpix_app_server" {
  ami                         = var.ami_id
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  iam_instance_profile        = var.instance_profile_name
  instance_type               = "t3.micro"
  key_name                    = "login1"
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.xpix-app-server.id]

  tags = {
    Name = "xpix-web-server"
  }

  user_data = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    iops = 3000
    throughput = 125
    delete_on_termination = true
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    http_put_response_hop_limit = 2
  }
}

import {
    to = aws_instance.xpix_app_server
    id = "i-0562fb8b127f80bb4"
}