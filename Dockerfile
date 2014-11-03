# Dockerfile to quickly test the repository
FROM ubuntu:14.10
MAINTAINER Guillaume Claret

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gcc make git
RUN apt-get install -y curl ocaml
RUN apt-get install -y m4 aspcud

# OPAM from Ubuntu
# RUN apt-get install -y opam

# OPAM from the sources
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

# Stable and testing repositories
RUN opam repo add coq-stable https://github.com/coq/repo-stable.git
RUN opam repo add coq-testing https://github.com/coq/repo-testing.git

# This repository
ADD . /root/repo-unstable
RUN opam repo add --kind git coq-unstable /root/repo-unstable