FROM openjdk:18-jdk-alpine3.14
LABEL maintainer="Tamás Hugyák <desoft@outlook.com>"
WORKDIR /opt

ENV ARTEMIS_USER artemis
ENV ARTEMIS_PASSWORD artemis
ENV ANONYMOUS_LOGIN false
ENV EXTRA_ARGS --http-host 0.0.0.0 --relax-jolokia

# add user and group for artemis
RUN addgroup -g 1000 -S artemis && adduser -u 1000 -S -G artemis artemis && \
    apk add --no-cache libaio

USER artemis

ADD . /opt/activemq-artemis

# Web Server
EXPOSE 8161 \
# JMX Exporter
    9404 \
# Port for CORE,MQTT,AMQP,HORNETQ,STOMP,OPENWIRE
    61616 \
# Port for HORNETQ,STOMP
    5445 \
# Port for AMQP
    5672 \
# Port for MQTT
    1883 \
#Port for STOMP
    61613

USER root

RUN rm -Rf /opt/activemq-artemis/docker && \
    mkdir /var/lib/artemis-instance && \
    chown -R artemis.artemis /var/lib/artemis-instance

COPY ./docker/alpine.docker-run.sh /docker-run.sh

USER artemis

# Expose some outstanding folders
VOLUME ["/var/lib/artemis-instance"]
WORKDIR /var/lib/artemis-instance

ENTRYPOINT ["/docker-run.sh"]
CMD ["run"]
