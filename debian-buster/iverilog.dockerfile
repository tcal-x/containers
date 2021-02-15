FROM hdlc/build:build AS build

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    autoconf \
    automake \
    bison \
    flex \
    gperf \
    libreadline-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/steveicarus/iverilog \
 && cd iverilog \
 && autoconf \
 && ./configure \
 && make -j$(nproc) check \
 && make DESTDIR=/opt/iverilog install

#---

FROM scratch AS pkg
COPY --from=build /opt/iverilog /iverilog

#---

FROM hdlc/build:base

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    perl \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/iverilog /
CMD ["iverilog"]
