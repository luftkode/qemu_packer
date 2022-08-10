#!/bin/bash

# Run container with typical arguments

ENTRYPOINT=${@:-bash}

if [ -t 1 ]; then
  IT="-it"
else
  IT=""
fi

USER_ID=$(id -u $USER)

docker run -v ${PWD}:/work \
  -v ${SSH_AUTH_SOCK}:/ssh-agent `# Map SSH Agent` \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -e HOST_USER=$USER_ID `# Used to set correct ownership of files in the container` \
  --device=/dev/kvm `# Map Virtulization` \
  $IT \
  airit/qemu_packer \
  $ENTRYPOINT

  