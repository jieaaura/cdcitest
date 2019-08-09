#! /bin/bash -xe

curl -o helm-v2.12.3-darwin-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-darwin-amd64.tar.gz
tar xvf ./helm-v2.12.3-darwin-amd64.tar.gz
mv darwin-amd64/ /usr/local/bin/
alias helm-eks="/usr/local/bin/darwin-amd64/helm"
alias helm="/usr/local/bin/darwin-amd64/helm"
