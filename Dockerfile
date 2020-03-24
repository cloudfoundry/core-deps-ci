FROM ubuntu:bionic

ENV LANG="C.UTF-8"
ENV DEBIAN_FRONTEND noninteractive

ARG GO_VERSION=1.13.8
ARG GO_SHA256=0567734d558aef19112f2b2873caa0c600f1b4a5827930eb5a7f35235219e9d8
ARG BOSH_VERSION=6.2.1
ARG BBL_VERSION=8.4.0
ARG CREDHUB_VERSION=2.7.0
ARG OM_VERSION=4.6.0

RUN apt-get -qqy update \
  && apt-get -qqy install \
    build-essential \
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

RUN curl -sL -o /usr/local/bin/fly "https://buildpacks.ci.cf-app.com/api/v1/cli?arch=amd64&platform=linux" \
  && chmod +x /usr/local/bin/fly

RUN curl -sL -o /usr/local/bin/bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v${BOSH_VERSION}/bosh-cli-${BOSH_VERSION}-linux-amd64 \
  && chmod +x /usr/local/bin/bosh

RUN curl -sL -o /usr/local/bin/bbl https://github.com/cloudfoundry/bosh-bootloader/releases/download/v${BBL_VERSION}/bbl-v${BBL_VERSION}_linux_x86-64 \
  && chmod +x /usr/local/bin/bbl

RUN curl -sL https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_VERSION}/credhub-linux-${CREDHUB_VERSION}.tgz \
  | tar -C /usr/local/bin -xz

RUN curl -sL -o /usr/local/bin/om https://github.com/pivotal-cf/om/releases/download/${OM_VERSION}/om-linux-${OM_VERSION} \
  && chmod +x /usr/local/bin/om

RUN curl -sL "https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key" | apt-key add - \
  && echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list

RUN apt-get -qqy update \
  && apt-get -qqy install \
    cf-cli \
  && apt-get -qqy clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
