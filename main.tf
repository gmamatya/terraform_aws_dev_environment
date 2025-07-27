resource "aws_vpc" "dev_env_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true # Enabled by default
  tags = {
    Name = "DevEnvironmentVPC"
  }
}

resource "aws_subnet" "dev_env_subnet" {
  vpc_id                  = aws_vpc.dev_env_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true         # Automatically assign public IPs to instances
  availability_zone       = "us-east-2a" # Specify the AZ you want to use
  tags = {
    Name = "DevEnvironmentPublicSubnet"
  }
}

resource "aws_internet_gateway" "dev_env_igw" {
  vpc_id = aws_vpc.dev_env_vpc.id
  tags = {
    Name = "DevEnvironmentIGW"
  }
}

resource "aws_route_table" "dev_env_route_table" {
  vpc_id = aws_vpc.dev_env_vpc.id
  tags = {
    Name = "DevEnvironmentRouteTable"
  }
}

resource "aws_route" "dev_env_default_route_internet_access" {
  route_table_id         = aws_route_table.dev_env_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_env_igw.id
}

resource "aws_route_table_association" "dev_env_subnet_association" {
  subnet_id      = aws_subnet.dev_env_subnet.id
  route_table_id = aws_route_table.dev_env_route_table.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dev_env_vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
