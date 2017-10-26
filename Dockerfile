FROM alpine:3.6
MAINTAINER Nathan Catania <nathan@nathancatania.com>

ENV NAPALM_DOCKER_VERSION 0.1.1

# Copy script to generate Napalm-logs configuration dynamically
ADD     startnapalm.sh /usr/bin/startnapalm.sh
COPY    napalm.tmpl /usr/bin/napalm.tmpl

RUN apk add --no-cache \
    libffi \
    libffi-dev \
    python \
    python-dev \
    py-pip \
    build-base \
    && pip install envtpl \
    && pip install cffi \
    && pip install kafka \
    && pip install napalm-logs \
    && chmod 777 /usr/bin/startnapalm.sh

EXPOSE 6000/udp

ENV LISTEN_PORT=6000 \
    PUBLISH_PORT=49017 \
    KAFKA_BROKER_HOST=127.0.0.1 \
    KAFKA_BROKER_PORT=9094 \
    KAFKA_TOPIC=syslog_napalm

CMD /usr/bin/startnapalm.sh
