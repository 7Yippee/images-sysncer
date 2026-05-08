ARG JAVA_IMAGE=eclipse-temurin:8-jre-jammy
FROM ${JAVA_IMAGE}

ARG SEATUNNEL_WEB_DIR=apache-seatunnel-web-1.0.2-bin

ENV TZ=Asia/Shanghai
ENV SEATUNNEL_WEB_HOME=/opt/seatunnel-web
ENV ST_WEB_BASEDIR_PATH=/opt/seatunnel-web

WORKDIR /opt

COPY dist/${SEATUNNEL_WEB_DIR}/ /opt/seatunnel-web/

RUN mkdir -p /opt/seatunnel-web/logs /opt/seatunnel-web/plugins && \
    chmod +x /opt/seatunnel-web/bin/*.sh

WORKDIR /opt/seatunnel-web

EXPOSE 8801

CMD ["sh", "-c", "mkdir -p /opt/seatunnel-web/logs /opt/seatunnel-web/plugins && java -server -Xms1g -Xmx1g -Xmn512m -Dseatunnel-web.logs.path=/opt/seatunnel-web/logs -Dspring.config.location=/opt/seatunnel-web/conf/application.yml -cp \"/opt/seatunnel-web/libs/*:/opt/seatunnel-web/datasource/*:/opt/seatunnel-web/conf\" org.apache.seatunnel.app.SeatunnelApplication"]
