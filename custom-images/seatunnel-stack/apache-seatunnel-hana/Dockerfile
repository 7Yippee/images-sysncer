ARG JAVA_IMAGE=eclipse-temurin:8-jre-jammy
FROM ${JAVA_IMAGE}

ARG SEATUNNEL_DIR=apache-seatunnel-2.3.8

ENV TZ=Asia/Shanghai
ENV SEATUNNEL_HOME=/opt/seatunnel

WORKDIR /opt

COPY dist/${SEATUNNEL_DIR}/ /opt/seatunnel/
COPY target/ngdbc.jar /opt/seatunnel/lib/ngdbc.jar

RUN chmod +x /opt/seatunnel/bin/*.sh && \
    chmod 644 /opt/seatunnel/lib/ngdbc.jar && \
    mkdir -p /opt/seatunnel/logs

WORKDIR /opt/seatunnel

