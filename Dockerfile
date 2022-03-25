FROM ummsbiocore/dolphinnext-studio:latest
MAINTAINER Alper Kucukural <alper.kucukural@umassmed.edu>

# nodejs
RUN apt-get install -y apt-transport-https ca-certificates sudo
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install nodemon -g
RUN npm install -g n
RUN npm install pm2 -g
RUN n 14.2.0
RUN PATH="$PATH"

# mongodb  https://github.com/docker-library/mongo/blob/1fe97dd9ab8e8db7224a84345583bb415d83f602/4.4-rc/Dockerfile
ARG MONGO_PACKAGE=mongodb-org
ARG MONGO_REPO=repo.mongodb.org
ENV MONGO_PACKAGE=${MONGO_PACKAGE} MONGO_REPO=${MONGO_REPO}

ENV MONGO_MAJOR 4.0
ENV MONGO_VERSION 4.0.19
# bashbrew-architectures:amd64 arm64v8
RUN echo "deb http://$MONGO_REPO/apt/ubuntu xenial/${MONGO_PACKAGE%-unstable}/$MONGO_MAJOR multiverse" | tee "/etc/apt/sources.list.d/${MONGO_PACKAGE%-unstable}.list"

RUN set -x \
# installing "mongodb-enterprise" pulls in "tzdata" which prompts for input
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	&& apt-get install -y --allow-unauthenticated \
		${MONGO_PACKAGE}=$MONGO_VERSION \
		${MONGO_PACKAGE}-server=$MONGO_VERSION \
		${MONGO_PACKAGE}-shell=$MONGO_VERSION \
		${MONGO_PACKAGE}-mongos=$MONGO_VERSION \
		${MONGO_PACKAGE}-tools=$MONGO_VERSION \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mongodb


#install mkcert
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E52529D4
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran40/'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN apt update 
RUN apt-get install -y wget  libnspr4 libnss3 libnss3-nssdb libnss3-tools
RUN export VER="v1.4.3" && wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/${VER}/mkcert-${VER}-linux-amd64 && \
    chmod +x mkcert && mv mkcert /usr/local/bin
ADD startup /usr/local/bin/startup
ADD mongoinit.js /usr/local/bin/mongoinit.js

EXPOSE 27017

RUN echo "DONE!"

