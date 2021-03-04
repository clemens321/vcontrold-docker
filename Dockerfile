
ARG FROM_IMAGE=debian:buster

FROM ${FROM_IMAGE} as builder

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git \
    libxml2-dev \
    && echo "installed, no need to clean up here"

ARG VCONTROLD_VERSION=v0.98.10

COPY ./bin /target/usr/local/bin

RUN cd /usr/local/src && \
    git clone --single-branch --branch ${VCONTROLD_VERSION} https://github.com/openv/vcontrold.git && \
    mkdir -p vcontrold/build && cd vcontrold/build && \
    cmake -DMANPAGES=OFF -DCMAKE_INSTALL_PREFIX=/target/usr .. && \
    make && \
    make install && \
    mkdir -p /target/etc/vcontrold /target/var/log/vcontrold && \
    sed -i -e 's!<file>vcontrold.log</file>!<file>/dev/stdout</file>!' \
    /usr/local/src/vcontrold/xml/300/vcontrold.xml && \
    cp /usr/local/src/vcontrold/xml/300/vcontrold.xml /target/etc/vcontrold/ && \
    cp /usr/local/src/vcontrold/xml/300/vito.xml /target/etc/vcontrold/

FROM ${FROM_IMAGE}

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    libxml2 \
    telnet \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /target /

ENTRYPOINT ["/usr/sbin/vcontrold", "-n"]
