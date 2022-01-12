Docker implementation of a stable pima environment. v1

# Alternative Setup

Download the compressed image file from the group dropbox. 

Call the following to load the image

```commandline
docker load --input <Tar file downloaded>
```

And to interact with it

```commandline
docker run -it test
```

# Setup

Make sure you have docker installed on your system. [Install Instructions](https://docs.docker.com/engine/install/)
Once installed, clone this repository and unpack it. The following assumes your working from inside the directory.

# Download Test set

Make sure to download the [test set](https://www.dropbox.com/sh/ifkinqmhnaag35b/AAC-qlBwO1CPru_RgA9QHmDKa?dl=0), unpack it and place it in the top level of this directory. Rename the directory to testSets.

## Important Note

The testset has a file named **AmesRegions.bed** In order for the script to run properly, its header line must have 6 columns. Either add a header line seperated by spaces, or shift the longest line to the toprow.

# Building docker image

Run the following to build the docker image, it will take a while.
```commandline
docker build -t pima .
```
Once built, to run the environment execute.
```commandline
docker run -it pima
```

# Testing installation
In order to test if the installation was successful, run the following from the interactive docker shell.
```commandline
sh DockerDir/pima_test.sh
```
