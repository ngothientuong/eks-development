#!/bin/bash

# Update the package index
sudo apt-get update

# Install necessary packages
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the package index again
sudo apt-get update

# Install Docker Engine
sudo apt-get install -y docker-ce

# Add the current user to the docker group
sudo usermod -aG docker $USER

# Enable and start the Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Print a message to log out and back in
echo "Docker installation complete. Please restart your Windows to use Docker as a non-root user. If using remote Ubuntu machine, please restart the machine."