#!/usr/bin/env bash

#create folders
mkdir /DockerDir/Database
mkdir /DockerDir/Database/Standard

#create plasmid database
wget http://pima.appliedbinf.com/data/plasmids_and_vectors.fasta
mv plasmids_and_vectors.fasta /DockerDir/Database

#create kraken standard database
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20210517.tar.gz
mv k2_standard_20210517.tar.gz /DockerDir/Database/Standard/kraken.tar.gz
tar -xvf /DockerDir/Database/Standard/kraken.tar.gz --directory /DockerDir/Database/Standard/
rm /DockerDir/Database/Standard/kraken.tar.gz