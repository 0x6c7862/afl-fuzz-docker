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
  && wget 'http://lcamtuf.coredump.cx/afl/releases/afl-2.23b.tgz' -O- | tar zxvf - \
  && cd afl-* \
  && sed -rie 's/^(#[[:space:]]*define[[:space:]]+KEEP_UNIQUE_CRASH[[:space:]]+).*$/\120000/' config.h \
  && sed -rie 's/^(#[[:space:]]*define[[:space:]]+KEEP_UNIQUE_HANG[[:space:]]+).*$/\120000/' config.h \
  && sed -rie 's/^(#[[:space:]]*define[[:space:]]+PLOT_UPDATE_SEC[[:space:]]+).*$/\1900/' config.h \
  && sed -rie 's/^(#[[:space:]]*define[[:space:]]+STATS_UPDATE_SEC[[:space:]]+).*$/\1900/' config.h \
  && sed -rie 's/^(#[[:space:]]*define[[:space:]]+UI_TARGET_HZ[[:space:]]+).*$/\11/' config.h \
  && sed -rie 's/^(#[[:space:]]*define[[:space:]]+USE_COLOR.*$)/\/* \1 *\//' config.h \
  && make \
  && cd llvm_mode \
  && make \
  && cd .. \
  && make install \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV AFL_EXIT_WHEN_DONE=1
ENV AFL_HARDEN=1
