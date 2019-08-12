FROM ubuntu:18.04
COPY . /app
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y apt-utils && apt-get install -y sudo && apt-get install -y curl 
RUN curl -o  helm-v2.12.3-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz
RUN tar xvf ./helm-v2.12.3-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm
WORKDIR /app
RUN ls -la /app
CMD /app/entrypoint.sh


FROM python:3.6-slim

ADD ./requirements.txt /app/requirements.txt
ADD .modules/etl/requirements.txt /app/.modules/etl/requirements.txt
ADD .modules/etl/.modules/svc/requirements.txt /app/.modules/etl/.modules/svc/requirements.txt
ADD .modules/etl/.modules/svc/.modules/auth/requirements.txt /app/.modules/etl/.modules/svc/.modules/auth/requirements.txt
ADD .modules/etl/.modules/svc/.modules/auth/.modules/python/requirements.txt /app/.modules/etl/.modules/svc/.modules/auth/.modules/python/requirements.txt
WORKDIR /app

RUN /usr/local/bin/pip3 install --upgrade pip setuptools
RUN /usr/local/bin/pip3 install gunicorn
RUN apt-get update -yqq && \
    apt-get install -yqq --force-yes --no-install-recommends default-libmysqlclient-dev && \
    apt-get install -yqq --force-yes --no-install-recommends build-essential && \
    /usr/local/bin/pip3 install -r requirements.txt && \
    apt-get purge -yqq --force-yes build-essential && \
    apt-get autoremove -yqq --force-yes

ADD . /app
RUN rm -rf /app/lvt_common && mv /app/.modules/etl/.modules/svc/.modules/python/lvt_common /app
RUN rm -rf /app/lvt_sso && mv /app/.modules/etl/.modules/svc/.modules/auth/lvt_sso /app
RUN rm -rf /app/lvt_svc && mv /app/.modules/etl/.modules/svc/lvt_svc /app
RUN rm -rf /app/lvt_etl && mv /app/.modules/etl/lvt_etl /app
ADD deploy/entrypoint.sh /app/entrypoint.sh
CMD /app/entrypoint.sh
