#!/usr/bin/env bash

CORE_PATH="/home/DockerDir/mountpoint";

while getopts "m:r:f:q:o:" flag

do
    case "${flag}" in
        f) Fast5=${OPTARG};;
        q) Fastq=${OPTARG};;
        r) reference=${OPTARG};;
        m) mutation=${OPTARG};;
        o) outdir=${OPTARG};;
        *) printf "illegal option: -%s\n" "$OPTARG" >&2
            exit 1
            ;;
    esac
done

if [ ! -e "$reference" ] || [ ! -e "$mutation" ]|| [ ! -e "$outdir" ]; then
        echo 'reference nor mutation nor outdir defined ' >&2
        exit 1
fi

if [ ! -e "$Fastq" ] && [ ! -e "$Fast5" ]; then
        echo 'Neither Fastq nor Fast5 file paths defined ' >&2
        exit 1
fi

if [ -e "$Fastq" ] && [ -e "$Fast5" ]; then
        echo 'Both Fastq and Fast5 defined, please select only one ' >&2
        exit 1
fi
echo "All arguments received"

if [ -e "$Fastq" ] && [ ! -e "$Fast5" ]; then
        echo 'Executing Fastq path for pima' >&2
        echo "FASTq: $Fastq";
        echo "reference: $reference";
        echo "mutation: $mutation";

        sudo docker run -it --gpus all --mount type=bind,source=$PWD,target=$CORE_PATH appliedbioinformaticslab/pima-docker:kraken --out $CORE_PATH/$outdir --ont-fastq $CORE_PATH/$Fastq --threads 20 --overwrite --contamination --reference-genome=$CORE_PATH/$reference --mutation-regions=$CORE_PATH/$mutation --genome-size 5.4m --verb 3
        exit 0
fi

if [ ! -e "$Fastq" ] && [ -e "$Fast5" ]; then
        echo 'Executing Fast5 path for pima' >&2
        echo "FAST5: $Fast5";
        echo "reference: $reference";
        echo "mutation: $mutation";

        sudo docker run -it --gpus all --mount type=bind,source=$PWD,target=$CORE_PATH appliedbioinformaticslab/pima-docker:kraken --out $CORE_PATH/$outdir --ont-fast5 $CORE_PATH/$Fast5 --threads 20 --overwrite --contamination --reference-genome=$CORE_PATH/$reference --mutation-regions=$CORE_PATH/$mutation --genome-size 5.4m --verb 3
        exit 0
fi
