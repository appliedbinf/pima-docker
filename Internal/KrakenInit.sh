#!/usr/bin/env bash

#create folders
mkdir /home/DockerDir/Database
mkdir /home/DockerDir/pima/data/kraken2

#create plasmid database
wget http://pima.appliedbinf.com/data/plasmids_and_vectors.fasta
mv plasmids_and_vectors.fasta /home/DockerDir/Database

#create kraken standard database
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20210517.tar.gz
mv k2_standard_20210517.tar.gz /home/DockerDir/pima/data/kraken2/kraken.tar.gz
tar -xvf /home/DockerDir/pima/data/kraken2/kraken.tar.gz --directory /home/DockerDir/pima/data/kraken2
rm /home/DockerDir/pima/data/kraken2/kraken.tar.gz