FROM ubuntu:latest


# Install QEMU and essential packages.
RUN apt-get update && \
  apt -y install qemu-kvm qemu virt-manager virt-viewer cifs-utils \
    curl gnupg software-properties-common rsync python3-pip

#RUN apt-get update && \ 
#  apt-get install -y --no-install-recommends \
#      qemu-kvm qemu virt-manager virt-viewer cifs-utils curl gnupg \
#      libvirt-daemon-system virtinst libvirt-clients bridge-utils \
#      software-properties-common rsync

# Install Packer and set up HashiCorp repository.
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
  apt-get update && \
  apt-get install -y --no-install-recommends packer

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Create dev user
RUN useradd -ms $(which bash) dev && mkdir -p /work /artifacts && chown -R dev:dev /work && adduser dev kvm
ENV PATH="${PATH}:/home/dev/.local/bin"

USER dev

# Install additional tools
RUN pip3 install ansible typer pathspec

# Add GitHub SSH key to authorized keys
RUN mkdir -p /home/dev/.ssh && touch /home/dev/.ssh/config && echo "StrictHostKeyChecking no" >> /home/dev/.ssh/config
COPY --chown=dev known_hosts /home/dev/.ssh/known_hosts

# Set cache dir for packer locally to reuse downloads across runs
ENV PACKER_CACHE_DIR=/work/.packer_cache

ENV TERM xterm-256color

WORKDIR /work

CMD ["bash", "-l"]