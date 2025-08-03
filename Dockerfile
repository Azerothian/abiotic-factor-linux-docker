FROM ubuntu:22.04

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wine64 steamcmd && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN RUN useradd -m -d /home/sysuser -s /bin/bash -u 1000 -g 1000 sysuser

ENV PATH="$PATH:/usr/games"

WORKDIR /steamcmd

COPY ./entrypoint.sh /entrypoint.sh

USER sysuser

ENTRYPOINT ["bash", "/entrypoint.sh"]
