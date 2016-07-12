FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends --no-install-suggests \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    clang \
    llvm-dev \
    g++ \
    gcc \
    git \
    gzip \
    libtool \
    make \
    nasm \
    procps \
    tar \
    wget \
  && cd /usr/local/src \
  && wget 'http://lcamtuf.coredump.cx/afl/releases/afl-2.19b.tgz' -O- | tar zxvf - \
  && cd afl-* \
  && sed -rie 's/\\x1b\[1;90m/\\x1b[1;96m/' debug.h \
  && make \
  && cd llvm_mode \
  && make \
  && cd .. \
  && make install \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV AFL_EXIT_WHEN_DONE=1
ENV AFL_HARDEN=1
