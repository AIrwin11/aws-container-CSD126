terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.92"
    }
  }
  required_version = ">= 1.2"
}

import {
  to = aws_cognito_user_pool.xpix
  id = "us-east-1_yRYeWDfPU"
}

import {
  to = aws_cognito_user_pool_client.xpix
  id = "us-east-1_yRYeWDfPU/7u735lje1brrh1urvfosfovbtg"
}

import {
  to = aws_ssm_parameter.user_pool_id
  id = "/app/cognito/user_pool_id"
}

import {
  to = aws_ssm_parameter.client_id
  id = "/app/cognito/client_id"
}

output "public_ip" {
  value = aws_instance.xpix_app_server.public_ip
}