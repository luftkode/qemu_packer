#!/bin/bash

# Script for building container with environment for building TEM OS Images

export DOCKER_BUILDKIT=1
export UID_V=$(id -u)
export GID_V=$(id -g)
docker build --build-arg uid=$UID_V --build-arg gid=$GID_V -t airit/qemu_packer .