# SAP Kafka Connect HANA Image

这个目录用于构建带 SAP HANA Connector 的 Kafka Connect 镜像。

镜像内容来自：

- `debezium/connect:1.7.0.Final`
- `kafka-connector-hana_2.12-0.9.4.jar`
- `ngdbc-2.10.14.jar`
- `guava-31.0.1-jre.jar`

对应的 GitHub Actions workflow：

- `.github/workflows/build-sap-kafka-connect-hana.yml`

运行 workflow 时会在当前目录下临时生成 `target/`，下载依赖后构建并推送镜像。
