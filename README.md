# Installation and Preparation of Pima Docker

## Prerequisites

In order to install this software you must have Administrator Permissions. These permissions are required in order to install the needed GPU Drivers and the Docker Daemon. If the software is already installed skip to the operations section.

Pima relies on GPU acceleration and parallezation for parts of its pipeline. Therefore a graphics card with a CUDA Compute Capability of >=6.0. [Handy Reference linking GPUs to Compatibility](https://developer.nvidia.com/cuda-gpus#compute)

The Docker Environment and associated files require at least 100gb to build correctly and execute. It is recommended that more than 200gb be available to the host machine for.

## Nvidia-Driver Installation

**Note: The Nvidia Driver installation process changes every few years, this guide may be out of date.** 

Though the docker will include all the code needed to execute the parallelization through the graphics card, the drivers must be installed on the host machine for the docker to communicate to the GPU. The documentation is summarized here, but can be viewed in full [here](https://docs.nvidia.com/ai-enterprise/deployment-guide/dg-docker.html)

# Installation

Download the installation scripts to this computer

```commandline
wget https://raw.githubusercontent.com/appliedbinf/pima-docker/main/InstallScript.sh
```

Then simply run the following.

```commandline
sudo bash InstallScript.sh
```

This process will install the drivers, the docker packages, and pull down the latest **kraken** docker image. It may take a while and requires elevated permissions

# Testing installation
In order to test if the installation was successful, run the following from the interactive docker shell.
```commandline
sudo run -it appliedbioinformaticslab/pima-docker:kraken
```

You should see the --help output for Pima.

# Using the Pima Docker
For ease of use, use the pima.sh script included in this repository.

```commandline
sudo bash pima.sh -r <relative path to reference file> -m <relative path to mutations file> -f <relative path to fast5 file>
```
The flags for -r, -m, -f all have to be set and should be within the current working directory by a reachable relative path. 

Running this script will execut pima and output the results to a directory named **out** within the current working directory.
