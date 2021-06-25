FROM ubuntu:18.04

LABEL maintainer="OA IT-Support <itsupport@openanalytics.eu>"

ENV HUGO_VERSION 0.71.1
ENV AUTOPREFIXER_VERSION 9.8.6
ENV POSTCSSCLI_VERSION 7.1.2

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \ 
  && apt-get install -y --no-install-recommends \
      apt-utils \
      ca-certificates \
      apt-transport-https \
      git \
      wget \
  && rm -rf /var/lib/apt/lists/*

# install recent LTS version of node, see https://nodejs.org/en/about/releases/
RUN wget -qO- https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

# extended version for docsy theme
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb /tmp

RUN dpkg -i /tmp/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb

# for docsy
RUN npm install -D --save autoprefixer@${AUTOPREFIXER_VERSION}
RUN npm install -g -D --save postcss-cli@${POSTCSSCLI_VERSION}

RUN mkdir -p /etc/hugo/themes
COPY . /etc/hugo/themes/docsy

WORKDIR /src

EXPOSE 1313

