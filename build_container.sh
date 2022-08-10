#!/bin/bash

# Script for building container with environment for building TEM OS Images

export DOCKER_BUILDKIT=1
docker build -t airit/qemu_packer . 