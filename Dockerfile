FROM ummsbiocore/dolphinnext-studio:2.0
MAINTAINER Alper Kucukural <alper.kucukural@umassmed.edu>

# nodejs
RUN apt-get update
RUN apt-get -y install apt-transport-https sudo apt-utils
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN dpkg --remove --force-remove-reinstreq libnode-dev
RUN dpkg --remove --force-remove-reinstreq libnode72:amd64
RUN apt-get install -y nodejs
RUN npm install nodemon -g
RUN npm install -g n
RUN npm install pm2 -g
RUN n 14.2.0
RUN npm install -g npm@6.14.4
RUN PATH="$PATH"

ARG MONGO_PACKAGE=mongodb-org
ARG MONGO_REPO=repo.mongodb.org
ENV MONGO_PACKAGE=${MONGO_PACKAGE} MONGO_REPO=${MONGO_REPO}

ENV MONGO_MAJOR 4.4
ENV MONGO_VERSION 4.4.0

RUN apt-get update && apt-get install -y lsb-release
RUN sudo apt -y install dirmngr gnupg apt-transport-https ca-certificates software-properties-common
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1-1ubuntu2.1\~18.04.20_amd64.deb && sudo dpkg -i libssl1.1_1.1.1-1ubuntu2.1~18.04.20_amd64.deb


RUN wget -qO - https://www.mongodb.org/static/pgp/server-${MONGO_MAJOR}.asc | sudo apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/${MONGO_MAJOR} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGO_MAJOR}.list
RUN sudo apt-get update
RUN sudo apt-get install -y mongodb-org


#install mkcert
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E52529D4
#RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran40/'
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
#RUN apt update 
#RUN apt-get install -y wget  libnspr4 libnss3 libnss3-nssdb libnss3-tools
RUN export VER="v1.4.3" && wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/${VER}/mkcert-${VER}-linux-amd64 && \
    chmod +x mkcert && mv mkcert /usr/local/bin
ADD startup /usr/local/bin/startup
ADD mongoinit.js /usr/local/bin/mongoinit.js

EXPOSE 27017

RUN echo "DONE!"

