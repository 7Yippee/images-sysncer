# Apache SeaTunnel HANA JDBCPlus Image

这个目录用于构建一版额外的 `Apache SeaTunnel HANA` 镜像。

它保留：

- `ngdbc.jar`

同时额外加入：

- `mysql-connector-java-8.0.28.jar`
- `ojdbc8-21.5.0.0.jar`
- `mssql-jdbc-9.2.1.jre8.jar`

目标：

- 在维持 `HANA` 能力的前提下
- 额外试一版常用 JDBC 驱动更全的运行镜像
- 方便后面继续尝试 `MySQL / Oracle / SQL Server`

镜像 tag：

- `registry.cn-guangzhou.aliyuncs.com/tools_y/apache_seatunnel_hana:2.3.8-ngdbc-jdbcplus`
