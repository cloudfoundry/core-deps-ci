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

RUN curl -sL https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/go.tar.gz \
  && [ ${GO_SHA256} = $(shasum -a 256 /tmp/go.tar.gz | cut -d' ' -f1) ] \
  && tar -C /usr/local -xf /tmp/go.tar.gz \
  && rm /tmp/go.tar.gz

ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN curl -sL -o /usr/local/bin/yj https://github.com/sclevine/yj/releases/latest/download/yj-linux \
  && chmod +x /usr/local/bin/yj
