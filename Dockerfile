FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN mkdir /app/trivy

COPY popeye-script.sh kubescape.sh trivy.sh ./

RUN chmod +x /app/*.sh

RUN apt-get update && apt-get install -y \
    curl wget unzip jq vim \
    aha # Converts ANSI output to HTML

# Install Popeye

RUN curl -sL -O https://github.com/derailed/popeye/releases/download/v0.22.1/popeye_linux_amd64.tar.gz && \
    mkdir popeye && \
    tar -xvzf popeye_linux_amd64.tar.gz -C popeye && \
    chmod +x popeye/popeye && \
    mv popeye/popeye /usr/local/bin/

# Install kubescape

RUN curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash

# Install trivy

RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh && \
    mv ./bin/trivy /usr/local/bin/

# Install az CLI

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install kubectl

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin


ENTRYPOINT ["/bin/bash"]