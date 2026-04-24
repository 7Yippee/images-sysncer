# SeaTunnel Web JDBCPlus HANA Image

这个目录用于构建一版面向 `HANA -> StarRocks` 可视化维护场景的 `SeaTunnel Web` 镜像。

在现有 `JDBCPlus` 版本基础上，额外加入：

- `datasource-jdbc-hana`
- `ngdbc-2.10.14.jar`
- `HANA datasource` 后端适配补丁

同时继续保留：

- `seatunnel-app` 作业配置补丁
- `datasource-starrocks`
- `datasource-jdbc-starrocks`
- `datasource-jdbc-mysql`
- `datasource-jdbc-oracle`
- `datasource-jdbc-sqlserver`
- `mysql-connector-java-8.0.28.jar`
- `ojdbc8-21.5.0.0.jar`
- `mssql-jdbc-9.2.1.jre8.jar`

镜像 tag：

- `registry.cn-guangzhou.aliyuncs.com/tools_y/seatunnel-web:1.0.2-2.3.8-jdbcplus-hana`

这版的目标不是只跑命令行任务，而是让 `SeaTunnel Web` 页面里真正出现 `JDBC-Hana`，后面可以直接在 Web 页面上新建、修改和重跑同步任务。
