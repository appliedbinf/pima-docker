#!/usr/bin/env bash

while getopts "k" flag

do
    case "${flag}" in
        k) kraken="true";;
        *) printf "illegal option: -%s\n" "$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Install all the Docker Environment
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-commo

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

wget https://raw.githubusercontent.com/appliedbinf/pima-docker/main/pima.sh

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
if [ $kraken ]
then
        sudo docker pull appliedbioinformaticslab/pima-docker:kraken
else
        sudo docker pull appliedbioinformaticslab/pima-docker:latest
fi


# Add shortcut aliasing
echo 'alias pima="docker run --gpus all -it --mount type=bind,source=$PWD/Workdir,target=/DockerDir/Workdirectory appliedbioinformaticslab/pima-docker:kraken"' >> ~/.bashrc
source ~/.bashrc

# File handling Steps
mkdir Workdir
