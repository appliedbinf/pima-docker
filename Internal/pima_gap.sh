#!/usr/bin/env bash

# This script pulls the latest version of pima from github then passes all arguments to python

git -C pima pull

python /home/DockerDir/pima/pima.py "$@"