resource "aws_vpc" "dev_env_vpc" {
  cidr_block = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true # Enabled by default
    tags = {
        Name = "DevEnvironmentVPC"
    }
}