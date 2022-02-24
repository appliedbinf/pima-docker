# Docker container for PIMA
This repository has the following structure:

 * Interfaces (holds the interfaces for interacting with the docker)
 * Internal (holds the scripts and reference files used for docker image building)
 * Installation Script (The installation script used to install and build the docker image)
 
# Table of Contents

- [PIMA: Plasmid, Integrations, Mutations, and Antibiotic docker implementation](#pima--plasmid--integrations--mutations--and-antibiotic-docker-implementation)
  * [Prerequisites](#prerequisites)
- [Installation](#installation)
  * [Add Docker Group](#add-docker-group)
- [Testing installation](#testing-installation)
- [Using the docker](#using-the-docker)
  * [Python Interface](#python-interface)
    + [Quickstart](#quickstart)
    + [All available Arguments](#all-available-arguments)
  * [Direct Access](#direct-access)
- [Examples](#examples)
  * [Python Interface](#python-interface-1)
  * [Direct access](#direct-access)
- [FAQ](#faq)
  * [Using Mounts to connect spare directories for docker](#using-mounts-to-connect-spare-directories-for-docker)

## Prerequisites

In order to install this software you must have administrator permissions. These permissions are required to install the needed GPU drivers and the Docker daemon. If the software is already installed skip to the operations section.  

PiMA relies on GPU acceleration and parallezation for parts of its pipeline. Therefore a graphics card with a CUDA Compute Capability of >=6.0. [Handy Reference linking GPUs to Compatibility](https://developer.nvidia.com/cuda-gpus#compute)  

The Docker environment and associated files require at least 100gb to build correctly and execute. It is recommended that more than 200gb be available to the host machine for.

# Installation

Download the installation scripts to your system

```commandline
wget https://raw.githubusercontent.com/appliedbinf/pima-docker/main/InstallScript.sh
```

To download the docker image with kraken databases loaded: (estimated size 70gb)
```commandline
sudo bash InstallScript.sh -k
```
To download the docker image without: (estimated size 8gb)
```commandline
sudo bash InstallScript.sh
```

This process will install the drivers, the docker packages. It will take a while and requires elevated permissions

## Add Docker Group
Though the installation script attempts to configure the docker group, you may need to run the following to interact the docker outside of root
```commandline
sudo groupadd docker
sudo usermod -aG docker $USER
```
Close your shell and reopen it so that changes may take effect and verify that you may execute docker commands
```commandline
docker run hello-world
```
The full documentation for this process is [here](https://docs.docker.com/engine/install/linux-postinstall/)

# Testing installation
In order to test if the installation was successful, run the following from the interactive docker shell.
```commandline
sudo run -it appliedbioinformaticslab/pima-docker:kraken
```
You should see the --help output for PiMA.

# Using the docker
There are two ways of interacting with the Docker:
1. Through the included python interface
2. Through the included bash interface
3. Directly calling it
## Python Interface
To use this interface make sure the docker sdk for python is installed
```commandline
pip install python_on_whales
```
After running that install there should be a python file created in the installation directory.
```
pima_interface.py <- This is the python interface script
```
The python Interface manages calling the docker and handling standard arguments.
**Note: To run this script, you may require elevated permissions depending on how docker was installed**
### Quickstart
A typical fastq run can be executed with given reference & mutation files
By default the docker ran is the **kraken** enabled docker, to run latest add the **-t latest** flag.
```commandline
python pima_inteface --reference_genome <relative path to reference file> --mutation <relative path to mutations file> \
--Fastq <relative path to fastq files directory> --output <relative path to desired output directory>
```
Alternatively, one may forego providing a reference genome and mutation file, and use one of the defaults included in `Preloaded.json`
```commandline
python pima_inteface --Preloded_Reference <Desired Organism>\
--Fastq <relative path to fastq files directory> --output <relative path to desired output directory>
```

### All available Arguments
The full description of each commandline option is provided below.
```commandline
usage: pima_interface_T.py [-h] [-t TAG] (-f FAST5 | -q FASTQ)
                           [-r REFERENCE_GENOME] [-m MUTATION]
                           [-R {bacillus_anthracis,bacillus_anthracis_STERNE,burkholderia_psuedomallei,francisella_tularensis,francisella_tula
rensis_LVS,klebsiella_pneumoniae,yersinia_pestis,yersinia_pestis_KIM10+,yersinia_pestis_KIM5}]
                           [-o OUTPUT]

Pima docker python interface

optional arguments:
  -h, --help            show this help message and exit
  -t TAG, --tag TAG     tag of docker container to run:[latest|kraken]
  -f FAST5, --Fast5 FAST5
                        Path to the Directory Containing Fast5 Files
  -q FASTQ, --Fastq FASTQ
                        Path to the Directory Containing Fastq Files
  -r REFERENCE_GENOME, --reference_genome REFERENCE_GENOME
                        Path to the Reference Genome
  -m MUTATION, --mutation MUTATION
                        Path to AMR mutation file
  -R {bacillus_anthracis,bacillus_anthracis_STERNE,burkholderia_psuedomallei,francisella_tularensis,francisella_tularensis_LVS,klebsiella_pneu
moniae,yersinia_pestis,yersinia_pestis_KIM10+,yersinia_pestis_KIM5}, --Preloded_Reference {bacillus_anthracis,bacillus_anthracis_STERNE,burkho
lderia_psuedomallei,francisella_tularensis,francisella_tularensis_LVS,klebsiella_pneumoniae,yersinia_pestis,yersinia_pestis_KIM10+,yersinia_pe
stis_KIM5}
                        Select one of the preloaded Reference and Mutation
                        Options
  -o OUTPUT, --output OUTPUT
                        Path to output file. If none given will create a dir
                        named 'out'
```
## Bash Interface
Though it should be installed with the installation script, it is also accessible via:
```commandline
wget https://raw.githubusercontent.com/appliedbinf/pima-docker/main/pima.sh
```
You may run it in the same way as the python interface with the same flags
```commandline
sudo bash pima.sh -r <relative path to reference file> -m <relative path to mutations file> -f <relative path to fast5 files directory> -o <relative path to output directory>
```
The flags for -r, -m, -f, -o all have to be set and should be within the current working directory by a reachable relative path.
If an output directory is not provided then running this script will execute pima and output the results to a directory named **out** within the current working directory.
## Direct Access
For finer control, one may pass parameters directly to the docker as though it were [pima](https://github.com/appliedbinf/pima/blob/master/README.md)

The standard format for executing a docker image is as follows:
```commandline
docker run -it --gpus all --mount type=bind,source=<DesiredDirectory>,target=/home/DockerDir/mountpoint/ appliedbioinformaticslab/pima-docker:kraken <any arguments to pima>
```
** A full treatment of how to interact with docker containers via mounting is given [here](https://docs.docker.com/storage/bind-mounts/) **  
** Note: the --gpus all flag denotes that the container may access GPUs on the host device and is required **
# Examples

Consider an example scenario where you want to assemble Bacillus anthracis ont reads. If the reference file is named ref.fasta and the query fast5 files are in the folder named barcodes_folder, the mutation regions bed file is named mutation_regions.bed and the output folder you named is ont_output then your options are as follows:
## Python Interface
You may either provide the reference files:
```commandline
python pima_inteface.py --reference_genome ref.fasta --mutation mutation_regions.bed \
--Fast5 barcodes_folder/ --output ont_outpt
```
Or use the included reference and mutation genome files
```commandline
python pima_inteface.py --Preloded_Reference bacillus_anthracis --Fast5 barcodes_folder/ --output ont_outpt
```
## Direct access
The direct access command essentially appends all the flags for [pima](https://github.com/appliedbinf/pima/blob/master/README.md#quickstart-guide) to the docker command:
```commandline
docker run -it --gpus all --mount type=bind,source=<DesiredDirectory>,target=/home/DockerDir/mountpoint/ appliedbioinformaticslab/pima-docker:kraken \
--out ont_output --ont-fast5 barcodes_folder --threads 16 --overwrite --genome-size 5m \
--verb 3 --reference-genome ref.fasta --mutation-regions mutation_regions.bed
```

# FAQ

## Facing Nvidia or Daemon Issues
There are a myriad of reasons these can occur, but typically result from either the changes to the daemon or the drivers not taking effect.

It is recommended that one reinstalls compatible Nvidia Drivers and then restarts the machine so the changes can take effect.

## Using Mounts to connect spare directories for docker
By default, the interface script mounts the current directory with the docker, therefore only files and dirs within the current directory (and lower) are accessible by Docker.
If files or directories in other parts of the file system they can be temporarily mounted to a folder within the current directory before docker mounts it.

For example, to mount /var/lib to my current directory I would first create a directory.
```commandline
mkdir temp_mount
```
Then bind /var/lib to this directory
```commandline
sudo mount --bind /var/lib/ temp_mount
```
Now when docker mounts my current directory it will also have access to /var/lib by way of temp_mount
