FROM ubuntu:latest

# Install QEMU and essential packages.
RUN apt-get update \
  && apt -y install qemu-kvm qemu virt-manager virt-viewer cifs-utils \
  curl gnupg software-properties-common rsync python3-pip git \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Packer and set up HashiCorp repository.
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
  && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  && apt-get update \
  && apt-get install -y --no-install-recommends packer \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Create dev user
RUN groupadd -g 1024 dev \
    && useradd -u 1024 -g dev -ms $(which bash) -d /home/dev dev \
    && mkdir -p /work && chown -R dev:dev /work

ENV PATH="${PATH}:/home/dev/.local/bin"

USER dev

# Install additional tools
RUN pip3 install --no-cache-dir ansible typer pathspec

# Add GitHub SSH key to authorized keys
RUN mkdir -p /home/dev/.ssh && touch /home/dev/.ssh/config && echo "StrictHostKeyChecking no" >> /home/dev/.ssh/config
COPY --chown=dev known_hosts /home/dev/.ssh/known_hosts

# Set cache dir for packer locally to reuse downloads across runs
ENV PACKER_CACHE_DIR=/work/.packer_cache

ENV TERM xterm-256color

WORKDIR /work

CMD ["bash", "-l"]