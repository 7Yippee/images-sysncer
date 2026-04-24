# SeaTunnel Web JDBCPlus Image

这个目录用于构建一版额外的 `SeaTunnel Web` 镜像。

在现有 `StarRocks` 支持之外，额外加入：

- `datasource-jdbc-mysql`
- `datasource-jdbc-oracle`
- `datasource-jdbc-sqlserver`
- `mysql-connector-java-8.0.28.jar`
- `ojdbc8-21.5.0.0.jar`
- `mssql-jdbc-9.2.1.jre8.jar`

这个版本继续保留：

- `seatunnel-app` 作业配置补丁
- `datasource-starrocks`
- `datasource-jdbc-starrocks`

镜像 tag：

- `registry.cn-guangzhou.aliyuncs.com/tools_y/seatunnel-web:1.0.2-2.3.8-jdbcplus`
