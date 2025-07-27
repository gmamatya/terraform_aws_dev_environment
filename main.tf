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
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH access from specified CIDR block"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_key_pair" "dev_env_auth" {
  key_name   = "dev_env_auth_key"
  public_key = file("~/.ssh/dev_env_key.pub") # Path to your public key
}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.server_ami.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.dev_env_auth.key_name # Can use id as well
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id              = aws_subnet.dev_env_subnet.id
  user_data              = file("userdata.tpl") # Path to your user data script
  root_block_device {
    volume_size = 10 # Size in GB
  }

  tags = {
    Name = "DevEnvironmentNode"
  }
}
