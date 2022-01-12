#!/usr/bin/env bash

# Install all the Docker Environment
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-commo

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install the Nvidia Toolkit and Nvidia Drivers
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit

# Create docker user group and add current user to it

user=$SUDO_USER
echo $user

sudo groupadd docker
sudo usermod -aG docker $user
sudo newgrp docker
sudo service docker restart

# Download docker image from Dockerhub
docker pull kyxsune/pima-docker:latest

# Add shortcut aliasing
printf 'alias pima="docker run --gpus all -it --mount type=bind,source=$PWD/Workdir,target=/DockerDir/Workdirectory kyxsune/pima-docker:latest"' >> ~/.bashrc
source ~/.bashrc

# File handling Steps
mkdir Workdir
