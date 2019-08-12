FROM ubuntu:18.04
COPY . /app
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y apt-utils && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && apt-get install -y sudo 
RUN curl -o  helm-v2.12.3-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz
RUN tar xvf ./helm-v2.12.3-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
WORKDIR /app
RUN ls -la /app
CMD /app/entrypoint.sh
