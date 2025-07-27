#!/bin/bash
set -euo pipefail

# 1. Make sure lsb_release and add-apt-repository are available and up to date
apt-get update -y
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    lsb-release

# 2. Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | apt-key add -

# 3. Add the Docker APT repository with the right codename
#    $(lsb_release -cs) will expand to "jammy", "focal", etc.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# 4. Install Docker
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# 5. Give the 'ubuntu' user permission to run Docker
usermod -aG docker ubuntu
