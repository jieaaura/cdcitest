FROM ubuntu:18.04
COPY . /app
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y apt-utils && apt-get install -y sudo && apt-get install -y curl 
RUN curl -o  helm-v2.12.3-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz
RUN tar xvf ./helm-v2.12.3-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm
WORKDIR /app
RUN ls -la /app
CMD /app/entrypoint.sh
