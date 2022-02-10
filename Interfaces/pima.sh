#!/usr/bin/env bash

CORE_PATH="/home/DockerDir/mountpoint/";

while getopts "R:m:r:f:q:o:" flag

#Add a Help flag for usage
#Create a script for loading paths

#Add references files from Vasanta to the docker
#Convert this script to a python file

do
    case "${flag}" in
        f) Fast5="${CORE_PATH}${OPTARG}";;
        q) Fastq="${CORE_PATH}${OPTARG}";;
        r) reference="${CORE_PATH}${OPTARG}";;
        R) reference_base=${OPTARG};;
        m) mutation="${CORE_PATH}${OPTARG}";;
        o) outdir=${OPTARG};;
        *) printf "illegal option: -%s\n" "$OPTARG" >&2
            exit 1
            ;;
    esac
done

case "$reference_base" in
      "")
        true ;;
      bacillus_anthracis)
        reference='/home/DockerDir/References/bacillus_anthracis/bacillus_anthracis.fasta'
        mutation='/home/DockerDir/References/bacillus_anthracis/bacillus_anthracis_r.bed';;
      burkholderia_psuedomallei)
        reference='/home/DockerDir/References/burkholderia_psuedomallei/burkholderia_psuedomallei.fasta'
        mutation='/home/DockerDir/References/burkholderia_psuedomallei/burkholderia_psuedomallei.bed';;
      francisella_tularensis)
        reference='/home/DockerDir/References/francisella_tularensis/francisella_tularensis.fasta'
        mutation='/home/DockerDir/References/francisella_tularensis/francisella_tularensis_r.bed';;
      klebsiella_pneumoniae)
        reference='/home/DockerDir/References/klebsiella_pneumoniae/klebsiella_pneumoniae.fasta'
        mutation='/home/DockerDir/References/klebsiella_pneumoniae/klebsiella_pneumoniae_r.bed';;
      yersinia_pestis)
        reference='/home/DockerDir/References/yersinia_pestis/yersinia_pestis.fasta'
        mutation='/home/DockerDir/References/yersinia_pestis/yersinia_pestis_r.bed';;
      *) printf "illegal option: %s\n" "$reference_base"
            printf "supported organisms: yersinia_pestis,klebsiella_pneumoniae,francisella_tularensis,burkholderia_psuedomallei,bacillus_anthracis"
            exit 1
            ;;
esac

#echo $reference
#echo $mutation
#echo $outdir
#echo $Fastq

mkdir $outdir

if [ ! -n "$reference" ] || [ ! -n "$mutation" ] || [ ! -n "$outdir" ]; then
        echo 'reference nor mutation nor outdir defined ' >&2
        exit 1
fi

if [ ! -n "$Fastq" ] && [ ! -n "$Fast5" ]; then
        echo 'Neither Fastq nor Fast5 file paths defined ' >&2
        exit 1
fi

if [ -n "$Fastq" ] && [ -n "$Fast5" ]; then
        echo 'Both Fastq and Fast5 defined, please select only one ' >&2
        exit 1
fi

echo "All arguments received"

if [ -n "$Fastq" ] && [ ! -n "$Fast5" ]; then
        echo 'Executing Fastq path for pima' >&2
        echo "FASTq: $Fastq";
        echo "reference: $reference";
        echo "mutation: $mutation";

        sudo docker run -it --gpus all --mount type=bind,source=$PWD,target=$CORE_PATH appliedbioinformaticslab/pima-docker:kraken --out $CORE_PATH/$outdir --ont-fastq $Fastq --threads 20 --overwrite --contamination --reference-genome=$reference --mutation-regions=$mutation --genome-size 5.4m --verb 3
        exit 0
fi

if [ ! -n "$Fastq" ] && [ -n "$Fast5" ]; then
        echo 'Executing Fast5 path for pima' >&2
        echo "FAST5: $Fast5";
        echo "reference: $reference";
        echo "mutation: $mutation";

        sudo docker run -it --gpus all --mount type=bind,source=$PWD,target=$CORE_PATH appliedbioinformaticslab/pima-docker:kraken --out $CORE_PATH/$outdir --ont-fast5 $Fast5 --threads 20 --overwrite --contamination --reference-genome=$reference --mutation-regions=$mutation --genome-size 5.4m --verb 3
        exit 0
fi
