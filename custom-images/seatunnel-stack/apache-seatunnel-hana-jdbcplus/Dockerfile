ARG JAVA_IMAGE=eclipse-temurin:8-jre-jammy
FROM ${JAVA_IMAGE}

ARG SEATUNNEL_DIR=apache-seatunnel-2.3.8

ENV TZ=Asia/Shanghai
ENV SEATUNNEL_HOME=/opt/seatunnel

WORKDIR /opt

COPY dist/${SEATUNNEL_DIR}/ /opt/seatunnel/
COPY target/ngdbc.jar /opt/seatunnel/lib/ngdbc.jar
COPY target/mysql-connector-java-8.0.28.jar /opt/seatunnel/lib/mysql-connector-java-8.0.28.jar
COPY target/ojdbc8-21.5.0.0.jar /opt/seatunnel/lib/ojdbc8-21.5.0.0.jar
COPY target/mssql-jdbc-9.2.1.jre8.jar /opt/seatunnel/lib/mssql-jdbc-9.2.1.jre8.jar

RUN chmod +x /opt/seatunnel/bin/*.sh && \
    chmod 644 /opt/seatunnel/lib/ngdbc.jar \
      /opt/seatunnel/lib/mysql-connector-java-8.0.28.jar \
      /opt/seatunnel/lib/ojdbc8-21.5.0.0.jar \
      /opt/seatunnel/lib/mssql-jdbc-9.2.1.jre8.jar && \
    mkdir -p /opt/seatunnel/logs

WORKDIR /opt/seatunnel
