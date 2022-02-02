# Installation and preparation of pima docker

## Prerequisites

In order to install this software you must have administrator permissions. These permissions are required to install the needed GPU drivers and the Docker daemon. If the software is already installed skip to the operations section.

PiMA relies on GPU acceleration and parallezation for parts of its pipeline. Therefore a graphics card with a CUDA Compute Capability of >=6.0. [Handy Reference linking GPUs to Compatibility](https://developer.nvidia.com/cuda-gpus#compute)

The Docker environment and associated files require at least 100gb to build correctly and execute. It is recommended that more than 200gb be available to the host machine for.

# Installation

Download the installation scripts to your system

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

You should see the --help output for PiMA.

# Using the PiMA Docker
For ease of use, use the pima.sh script included in this repository.

```commandline
wget https://raw.githubusercontent.com/appliedbinf/pima-docker/main/pima.sh
sudo bash pima.sh -r <relative path to reference file> -m <relative path to mutations file> -f <relative path to fast5 files directory> -o <relative path to output directory>
```
The flags for -r, -m, -f, -o all have to be set and should be within the current working directory by a reachable relative path. 

If an output directory is not provided then running this script will execute pima and output the results to a directory named **out** within the current working directory.
