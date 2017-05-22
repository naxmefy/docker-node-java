# DOCKER-VERSION 1.9.1
# https://github.com/naxmefy/docker-node-java

FROM ubuntu

MAINTAINER MRW Neundorf <m.neundorf@live.de>

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# make sure apt is up to date
RUN apt-get update -y --fix-missing

# install software-properties
RUN apt-get install -y software-properties-common python-software-properties

# install curl, build essentials and clang compiler
RUN apt-get -y install curl build-essential automake gcc g++ clang libssl-dev

# Install Java.
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y
RUN apt-get install -y oracle-java8-installer
# RUN apt install oracle-java8-set-default
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable and update PATH
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH ${JAVA_HOME}/bin:$PATH
RUN java -version

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 7.10.0

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN node --version

ENV USER=root
