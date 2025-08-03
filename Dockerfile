FROM ubuntu:22.04

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wine64 steamcmd && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
    
RUN groupadd -g 1000 sysuser \
 && useradd -m -d /home/sysuser -s /bin/bash -u 1000 -g 1000 sysuser
RUN mkdir -p /home/sysuser/steamcmd && \
    chown 1000:1000 -R /home/sysuser

WORKDIR /home/sysuser/steamcmd

ENV PATH="$PATH:/usr/games"

COPY ./entrypoint.sh /entrypoint.sh

USER 1000

ENTRYPOINT ["bash", "/entrypoint.sh"]
