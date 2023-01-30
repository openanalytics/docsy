FROM public.ecr.aws/docker/library/ubuntu:22.04 

LABEL maintainer="OA IT-Support <itsupport@openanalytics.eu>"

ENV HUGO_VERSION 0.104.3
ENV AUTOPREFIXER_VERSION 10.4.13
ENV POSTCSSCLI_VERSION 10.1.0 
ENV POSTCSS_VERSION 8.4.21 

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
RUN wget -qO- https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

# extended version for docsy theme
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb /tmp

RUN dpkg -i /tmp/hugo_extended_${HUGO_VERSION}_linux-amd64.deb

RUN npm install -g postcss@${POSTCSS_VERSION}
RUN npm install -g postcss-cli@${POSTCSSCLI_VERSION}
RUN npm install -g @fortawesome/fontawesome-free@6.2.0
RUN npm install -g bootstrap@4.6.2

RUN mkdir -p /etc/hugo/themes
COPY . /etc/hugo/themes/docsy
WORKDIR /etc/hugo/themes/docsy
RUN npm install autoprefixer@${AUTOPREFIXER_VERSION}
RUN npm install 

WORKDIR /src

EXPOSE 1313

