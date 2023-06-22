FROM python:3

# Install QEMU and essential packages.
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
      qemu-kvm virt-manager virt-viewer cifs-utils curl gnupg software-properties-common rsync uuid-dev

# Install Packer and set up HashiCorp repository.
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
  apt-get update && \
  apt-get install -y --no-install-recommends packer

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Configure user settings
RUN useradd -m -s $(which bash) skytemdev && mkdir -p /work && chown skytemdev:skytemdev /work && echo "export PS1='\$(whoami)@ [\$(pwd)]# '" >> /etc/bashrc
ARG HOME=/home/skytemdev 
ENV PATH="${PATH}:$HOME/.local/bin"

# Updating User and Group IDs for skytemdev. UID_V and GID_V are set in build_container.sh'
ARG uid
ARG gid
RUN usermod -u $uid skytemdev
RUN groupmod -g $gid skytemdev && usermod -a -G $gid skytemdev

USER skytemdev

# Install additional tools
RUN pip3 install ansible typer pathspec

WORKDIR $HOME

# Add GitHub SSH key to authorized keys
RUN mkdir -p ${HOME}/.ssh 
# COPY known_hosts ${HOME}/.ssh/known_hosts
# USER root
# RUN chown skytemdev:skytemdev ~/.ssh/known_hosts
# USER skytemdev

# Create directory for tem_os:
RUN mkdir -p ${HOME}/work

# Set cache dir for packer locally to reuse downloads across runs
ENV PACKER_CACHE_DIR=/work/.packer_cache

ENV TERM xterm-256color

WORKDIR ${HOME}/work

CMD ["bash", "-l"]