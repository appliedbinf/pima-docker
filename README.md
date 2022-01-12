# Installation and Preparation of Pima Docker

## Prerequisites

In order to install this software you must have Administrator Permissions. These permissions are required in order to install the needed GPU Drivers and the Docker Daemon. If the software is already installed skip to the operations section.

Pima relies on GPU acceleration and parallezation for parts of its pipeline. Therefore a graphics card with a CUDA Compute Capability of >=6.0. [Handy Reference linking GPUs to Compatibility](https://developer.nvidia.com/cuda-gpus#compute)

The Docker Environment and associated files require at least 100gb to build correctly and execute. It is recommended that more than 200gb be available to the host machine for.

## Nvidia-Driver Installation

**Note: The Nvidia Driver installation process changes every few years, this guide may be out of date.** 

Though the docker will include all the code needed to execute the parallelization through the graphics card, the drivers must be installed on the host machine for the docker to communicate to the GPU. The documentation is summarized here, but can be viewed in full [here](https://docs.nvidia.com/ai-enterprise/deployment-guide/dg-docker.html)

### Install Docker

To install Docker, add the docker repository to your package manager. 

    sudo apt-get update
    
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-commo
    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

### Install Nvidia Toolkit

With Docker installed next is the install for the nvidia-compatible docker toolkit.

    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -

    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

    sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit

Dont forget to restart your docker service

    sudo systemctl restart docker

### Test the Installation

Once the drivers and the docker is properly installed test it out with the below code. It should show the GPUs within the host machine.

    sudo docker run --gpus all nvidia/cuda:11.0-base nvidia-smi

## Recommended Docker Building

In order to build the docker image, it is recommended that a compressed prebuilt image file is retrieved from ABIL. With this image, all preloaded files are included and no internet connection is required

If you have the tar file then the pima image can be built with the following

    docker load --input <path to tar file>

This will build the docker image file in a single step with no further prep needed

## Alternative Docker Building

If the above is not an option, one can build the image from the Dockerfile if the following additional prerequisites are met.

* [The latest version of the guppy installation file](https://nanoporetech.com/nanopore-sequencing-data-analysis)
* [The testSet files](https://www.dropbox.com/sh/ifkinqmhnaag35b/AAC-qlBwO1CPru_RgA9QHmDKa?dl=0)

For the Guppy Installation to work, make sure to edit lines 37 and lines 45 in the Dockerfile to match the installation file
Make sure the testSet directory is named testSet
The testset has a file named **AmesRegions.bed** In order for the script to run properly, its header line must have 6 columns. Either add a header line seperated by spaces, or shift the longest line to the toprow.

With all the modifications in place, run the following to build the image. Run the following from inside the top level of the git repo.

```commandline
docker build -t pima .
```


# Interacting with the Docker 

Once built, to run the environment execute the following, with modifications to **source** and **target** as appropriate.
```commandline
docker run --gpus all -it --mount type=bind,source=<DirectoryOnHostMachine>,target=/DockerDir/Workdirectory
```

# Testing installation
In order to test if the installation was successful, run the following from the interactive docker shell.
```commandline
sh DockerDir/pima_test.sh
```