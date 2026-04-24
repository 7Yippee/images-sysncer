ARG JAVA_IMAGE=eclipse-temurin:8-jre-jammy
FROM ${JAVA_IMAGE}

ARG SEATUNNEL_DIR=apache-seatunnel-2.3.8

ENV TZ=Asia/Shanghai
ENV SEATUNNEL_HOME=/opt/seatunnel

WORKDIR /opt

COPY dist/${SEATUNNEL_DIR}/ /opt/seatunnel/
COPY plugin_config.connectors-minimal /tmp/plugin_config.connectors-minimal

RUN chmod +x /opt/seatunnel/bin/*.sh /opt/seatunnel/mvnw && \
    cp /tmp/plugin_config.connectors-minimal /opt/seatunnel/config/plugin_config && \
    cd /opt/seatunnel && /opt/seatunnel/bin/install-plugin.sh 2.3.8 && \
    rm -rf /root/.m2 /opt/seatunnel/.mvn && \
    rm -f /opt/seatunnel/mvnw /opt/seatunnel/mvnw.cmd && \
    mkdir -p /opt/seatunnel/logs

WORKDIR /opt/seatunnel
