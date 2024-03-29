FROM ubuntu:18.04
ARG TERRAFORM_VERSION=0.14.7
ARG K8S_VERSION=v1.17.9
ARG HELM_VERSION=v3.2.4


# Update apt and Install dependencies
RUN apt-get update \
    && apt-get install -y \
    curl \
    dnsutils \
    git \
    jq \
    libssl-dev \
    init \
    python3-pip \
    screen \
    vim \
    wget \
    zip \
    wireguard \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install tools and configure the environment
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin/ \
    && rm /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x kubectl && mv kubectl /usr/local/bin/kubectl 
    
RUN curl -O https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod +x ./get-helm-3 && ./get-helm-3 -v ${HELM_VERSION}

#RUN pip3 install --upgrade pip \
#    && mkdir /workdir && cd /workdir \
#    && mkdir keys \
#    && python3 -m pip install netaddr awscli

RUN pip3 install "setuptools==40.3.0" "ansible==2.9.14"
RUN mkdir /workdir && cd /workdir && mkdir keys && pip3 install netaddr awscli
RUN ansible-galaxy install codecap.kubectl

COPY . k3s-boot