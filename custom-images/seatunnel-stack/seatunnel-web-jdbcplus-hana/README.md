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

当前推荐验证版：

- `registry.cn-guangzhou.aliyuncs.com/tools_y/seatunnel-web:1.0.2-2.3.8-jdbcplus-hana-fix20260424f`

这版额外确认过：

- `JDBC-Hana` 页面可见
- `StarRocks JDBC Url` 带参数时能正确处理
- `StarRocks` sink 的 `Target Table` 可以手工输入
- `StarRocks` sink 不再只依赖精确值 `StarRocks`，实例名或 datasource 类型名里包含 `starrocks` 也能命中输入模式

这个目录是发布构建入口，不是源码主仓。

如果要继续改页面逻辑、datasource 逻辑或配置生成逻辑，优先去：

- `seatunnel-web-custom`

改完再把发布所需 patch 同步回这里。

这版的目标不是只跑命令行任务，而是让 `SeaTunnel Web` 页面里真正出现 `JDBC-Hana`，后面可以直接在 Web 页面上新建、修改和重跑同步任务。
