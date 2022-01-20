#!/usr/bin/env bash

while getopts m:r:f: flag

do
    case "${flag}" in
        f) Fast5=${OPTARG};;
        r) reference=${OPTARG};;
        m) mutation=${OPTARG};;
    esac
done

echo "FAST5: $Fast5";
echo "reference: $reference";
echo "mutation: $mutation";

CORE_PATH="/home/DockerDir/mountpoint";


sudo docker run -it --gpus all --mount type=bind,source=$PWD,target=$CORE_PATH kyxsune/pima-docker:kraken --out $CORE_PATH/out/ --ont-fast5 $CORE_PATH/$Fast5 --threads 20 --overwrite --contamination --reference-genome=$CORE_PATH/$reference --mutation-regions=$CORE_PATH/$mutation --genome-size 5.4m --verb 3