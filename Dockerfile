FROM ubuntu:bionic

ENV LANG="C.UTF-8"
ENV DEBIAN_FRONTEND noninteractive

ARG GO_VERSION=1.13.8
ARG GO_SHA256=0567734d558aef19112f2b2873caa0c600f1b4a5827930eb5a7f35235219e9d8

RUN apt-get -qqy update \
  && apt-get -qqy install \
    curl \
    git \
    jq \
    vim \
  && apt-get -qqy clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git config --global user.email "buildpacks-releng@pivotal.io"
RUN git config --global user.name "Buildpacks Releng CI"

RUN cd /usr/local \
  && curl -L https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -o go.tar.gz \
  && [ ${GO_SHA256} = $(shasum -a 256 go.tar.gz | cut -d' ' -f1) ] \
  && tar xf go.tar.gz \
  && rm go.tar.gz

ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
