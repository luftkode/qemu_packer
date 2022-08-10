FROM python:3

# Install QEMU
RUN apt-get update && \
  apt -y install qemu-kvm qemu virt-manager virt-viewer cifs-utils && \
  apt-get autoclean && \
  apt-get autoremove


# Install Packer
RUN apt -y install curl gnupg software-properties-common && \
  curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
  apt-get -y install packer

# Install Ansible
RUN pip3 install ansible

# Install required python modules
RUN pip3 install typer pathspec

# Install rsync required when provisioning:
RUN apt -y install rsync

# Add GitHub SSH key to authorized_keys
RUN mkdir -p -m 0600 ~/.ssh
COPY known_hosts ~/.ssh/known_hosts

# Create directory for tem_os:
RUN mkdir /work

# Set cache dir for packer locally to reuse downloads across runs:
ENV PACKER_CACHE_DIR=/work/.packer_cache

ENV TERM xterm-256color

WORKDIR /work

CMD ["bash", "-l"]