FROM nvidia/cuda:11.4.2-devel-ubuntu20.04

RUN apt-get update

ENV PATH="/home/miniconda/bin:${PATH}"
ARG PATH="/home/miniconda/bin:${PATH}"

RUN apt-get install -y libgd-perl
RUN apt-get install -y git

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    #&& mkdir /home/miniconda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/miniconda \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

RUN conda config --prepend channels conda-forge
RUN conda config --prepend channels bioconda

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

RUN mkdir /home/DockerDir

# Pull The latest In

ADD ./ /home/DockerDir

WORKDIR /home/DockerDir/

RUN conda env update -n base --file /home/DockerDir/environment.yml

RUN sed -i 's/cgi/html/g' /home/miniconda/lib/python3.8/site-packages/quast_libs/site_packages/jsontemplate/jsontemplate.py

RUN medaka tools download_models

# Pull The latest In
RUN git clone https://github.com/appliedbinf/pima.git

RUN tar -xvf ont-guppy_6.0.1_linux64.tar.gz && mv ont-guppy /home/DockerDir/guppy && rm ont-guppy_6.0.1_linux64.tar.gz

ENV PATH /home/DockerDir/guppy/bin:$PATH
ENV PATH /home/DockerDir/pima:$PATH
ENV PATH /home/DockerDir/:$PATH
ENV REFERENCE="/home/DockerDir/References"

SHELL ["/bin/bash", "-c"]

#Set Pimascript as the entrypoint
ENTRYPOINT ["/bin/bash", "/home/DockerDir/pima_gap.sh"]
#Set the Default parameters for testing
#CMD ["--reference-genome","testSets/AmesAndPlasmids.fasta","--ont-fastq","testSets/bAnthracis.fastq","--output","Workdir","--mutation","testSets/AmesRegions.bed","--verb","3","--genome-size","5m","--overwrite"]
CMD ["--help"]