# ──────────────────────────────────────────
# VPC
# ──────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc"
  }
}

# ──────────────────────────────────────────
# SUBNETS (4 total)
# ──────────────────────────────────────────
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-public1-us-east-1a"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-public2-us-east-1b"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-private1-us-east-1a"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-private2-us-east-1b"
  }
}

# ──────────────────────────────────────────
# INTERNET GATEWAY
# ──────────────────────────────────────────
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

# ──────────────────────────────────────────
# ROUTE TABLES (3 total)
# ──────────────────────────────────────────

# Public route table (shared by both public subnets)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "rtb-public"
  }
}

# Private route table for private subnet 1
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rtb-private1-us-east-1a"
  }
}

# Private route table for private subnet 2
resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rtb-private2-us-east-1b"
  }
}

# ──────────────────────────────────────────
# ROUTE TABLE ASSOCIATIONS (4 total)
# ──────────────────────────────────────────

# 10.6.1 - Two public subnets → public route table
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# 10.6.2 - Each private subnet → its own route table
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}

# ──────────────────────────────────────────
# SECURITY GROUP
# ──────────────────────────────────────────
resource "aws_security_group" "xpix-app-server" {
  name   = "xpix-app-server"
  vpc_id = aws_vpc.main.id
  description = "allow XPix app server connections"
}

# ──────────────────────────────────────────
# SECURITY GROUP INGRESS RULE
# ──────────────────────────────────────────
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.xpix-app-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}


# ──────────────────────────────────────────
# IMPORT BLOCKS
# ──────────────────────────────────────────

import {
  to = aws_vpc.main
  id = "vpc-0961b9cb497ea29f1"
}

import {
  to = aws_subnet.public_1
  id = "subnet-05233e1c356abdc49"
}

import {
  to = aws_subnet.public_2
  id = "subnet-0bc044ccc19b7c8b0"
}

import {
  to = aws_subnet.private_1
  id = "subnet-08c777eab5180fd3a"
}

import {
  to = aws_subnet.private_2
  id = "subnet-0a0e49cdaca72ab1a"
}

import {
  to = aws_internet_gateway.main
  id = "igw-027f5a90d6b315b96"
}

import {
  to = aws_route_table.public
  id = "rtb-0c1624ddd2aae6621"
}

import {
  to = aws_route_table.private_1
  id = "rtb-02c211ef00ad8e655"
}

import {
  to = aws_route_table.private_2
  id = "rtb-087d21f71327d9815"
}

import {
  to = aws_route_table_association.public_1
  id = "subnet-05233e1c356abdc49/rtb-0c1624ddd2aae6621"
}

import {
  to = aws_route_table_association.public_2
  id = "subnet-0bc044ccc19b7c8b0/rtb-0c1624ddd2aae6621"
}

import {
  to = aws_route_table_association.private_1
  id = "subnet-08c777eab5180fd3a/rtb-02c211ef00ad8e655"
}

import {
  to = aws_route_table_association.private_2
  id = "subnet-0a0e49cdaca72ab1a/rtb-087d21f71327d9815"
}

import {
  to = aws_security_group.xpix-app-server
  id = "sg-025d3f54c74f6f0e4"
}

import {
  to = aws_vpc_security_group_ingress_rule.allow_ssh
  id = "sgr-099dbc4807c6dbcdb"
}