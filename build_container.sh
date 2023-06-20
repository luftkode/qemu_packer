#!/bin/bash

# Script for building container with environment for building TEM OS Images

export DOCKER_BUILDKIT=1
docker build --build-arg uid=$(id -u) --build-arg gid=$(id -g)-t airit/qemu_packer .