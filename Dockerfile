# Dockerfile to quickly test the repository
FROM ubuntu:14.10
MAINTAINER Guillaume Claret

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gcc make git
RUN apt-get install -y curl m4 ruby

# OCaml 4.02.0
WORKDIR /root
RUN curl -L https://github.com/ocaml/ocaml/archive/4.02.0.tar.gz |tar -xz
WORKDIR /root/ocaml-4.02.0
RUN ./configure
RUN make world.opt
RUN make install

# Camlp4 4.02
WORKDIR /root
RUN curl -L https://github.com/ocaml/camlp4/archive/4.02.0+1.tar.gz |tar -xz
WORKDIR /root/camlp4-4.02.0-1
RUN ./configure
RUN make all
RUN make install

# OPAM 1.2
WORKDIR /root
RUN curl -L https://github.com/ocaml/opam/archive/1.2.0.tar.gz |tar -xz
WORKDIR opam-1.2.0
RUN ./configure
RUN make lib-ext
RUN make
RUN make install

# Initialize OPAM
RUN opam init
ENV OPAMJOBS 4

# Coq
RUN opam install -y coq

# Tools
RUN apt-get install -y nano

# Stable and testing repositories
RUN opam repo add coq-stable https://github.com/coq/repo-stable.git
RUN opam repo add coq-testing https://github.com/coq/repo-testing.git

# This repository
ADD . /root/repo-unstable
WORKDIR /root/repo-unstable
RUN opam repo add --kind git coq-unstable .