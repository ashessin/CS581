# syntax=docker/dockerfile:1
FROM ubuntu:focal

ENV DEBIAN_FRONTEND="noninteractive"
ENV MONGODB_REPO="https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4"

RUN apt update
RUN apt install -y wget gnupg python3 python3-pip
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc \
    | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] $MONGODB_REPO multiverse" \
    | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

RUN apt update
RUN apt install -y mongodb-org

RUN mkdir -p /src/notebooks
RUN mkdir -p /data/db

RUN pip3 -q install pip --upgrade
RUN pip3 install jupyterlab

WORKDIR /src
CMD mongod --dbpath /data/db/ --port 27017 --bind_ip_all --logpath mongod.log --fork; jupyter lab --port=8888 --no-browser --ip=* --allow-root --notebook-dir=/src/notebooks/ --NotebookApp.token=""

EXPOSE 27017/tcp
EXPOSE 8888/udp
