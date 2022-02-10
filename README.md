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
2. Directly calling it
## Python Interface
After running that install there should be two files created in the installation directory.
```
pima_interface.py <- This is the python interface script
Preloaded.json <- This json file denotes reference files that are preloaded in the docker
```
The python Interface manages calling the docker and handling standard arguments.

**note to run this script, you may require elevated permissions depending on how docker was installed**
### Quickstart
A typical fastq run can be executed with given reference & mutation files
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
usage: pima_interface.py [-h] (-f FAST5 | -q FASTQ) [-r REFERENCE_GENOME]
                         [-m MUTATION]
                         [-R {bacillus_anthracis,bacillus_anthracis_STERNE,burkholderia_psuedomallei,francisella_tularensis,francisella_tulare
nsis_LVS,klebsiella_pneumoniae,yersinia_pestis,yersinia_pestis_KIM10+,yersinia_pestis_KIM5}]
                         -o OUTPUT

Pima docker python interface

optional arguments:
  -h, --help            show this help message and exit
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
                        Path to output file
```
## Direct Access
For finer control, one may pass parameters directly to the docker as though it were [pima](https://github.com/appliedbinf/pima/blob/master/README.md)

The standard format for executing a docker image is as follows:
```commandline
   docker run -it --gpus all --mount type=bind,source=<DesiredDirectory>,target=/home/DockerDir/mountpoint/ appliedbioinformaticslab/pima-docker:kraken <any arguments to pima>
```
** a full treatment of how to interact with docker containers via mounting is given [here](https://docs.docker.com/storage/bind-mounts/) **
** note the --gpus all flag denotes that the container may access GPUs on the host device and is required **
# Examples

Consider an example scenario where you want to assemble Bacillus anthracis ont reads. If the reference file is named ref.fasta and the query fast5 files are in the folder named barcodes_folder, the mutation regions bed file is named mutation_regions.bed and the output folder you named is ont_output then your options are as follows:
## Python Interface
You may either provide the reference files:
```commandline
python pima_inteface --reference_genome ref.fasta --mutation mutation_regions.bed \
--Fast5 barcodes_folder/ --output ont_outpt
```
Or use the included reference and mutation genome files
```commandline
python pima_inteface --Preloded_Reference bacillus_anthracis --Fast5 barcodes_folder/ --output ont_outpt
```
## Direct access
The direct access command essentially appends all the flags for [pima](https://github.com/appliedbinf/pima/blob/master/README.md#quickstart-guide) to the docker command:
```commandline
    docker run -it --gpus all --mount type=bind,source=<DesiredDirectory>,target=/home/DockerDir/mountpoint/ appliedbioinformaticslab/pima-docker:kraken \
    --out ont_output --ont-fast5 barcodes_folder --threads 16 --overwrite --genome-size 5m \
    --verb 3 --reference-genome ref.fasta --mutation-regions mutation_regions.bed
```