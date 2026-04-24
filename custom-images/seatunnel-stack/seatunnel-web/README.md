# SeaTunnel Web Image

这个目录用于构建 `SeaTunnel Web` 镜像，并且和 `SeaTunnel Engine` 一起按多架构推送到阿里云。

当前策略：

- `SeaTunnel Web`：`1.0.2`
- `SeaTunnel Engine`：`2.3.8`
- 架构：`linux/amd64`、`linux/arm64`
- 目标：优先保证 Web 可用性和私有 K8s 集群落地稳定性
- 构建方式：官方 `apache-seatunnel-web-1.0.2-bin.tar.gz` + `seatunnel-web 1.0.2` 源码补丁产物组装
- CI 打包参数：`-DskipUT=true -Dmaven.test.skip=true -Dskip.spotless=true`

为什么这里没有直接追更高的 Engine：

- 官方 `Apache SeaTunnel` release 目前已经更新到更高版本
- 但 `SeaTunnel Web` 官方公开 release 仍是 `1.0.2`
- 官方兼容表对稳定组合给出的口径，是 `SeaTunnel 2.3.8 + SeaTunnel Web 1.0.2`

这个镜像已经内置：

- 官方 `SeaTunnel Web 1.0.2` 运行包
- 源码补丁替换后的 `seatunnel-app`
- `datasource-jdbc-starrocks`、`datasource-starrocks`
- `mysql-connector-java-8.0.28.jar`

补充说明：

- `seatunnel-web 1.0.2` 源码 tag 带有历史 `spotless` 校验噪音
- 老依赖链里 `surefire` 解析也可能抖动
- 这套源码自己的 `skipUT` 开关也要一起带上
- 直接依赖 `seatunnel-web-dist` 全量发包，链路偏长也更容易被老依赖拖慢
- 所以 CI 现在改成更稳妥的 `hybrid_patch` 路线：
  - 先下载官方 Web 二进制包
  - 再从源码构建补丁后的 `seatunnel-app` 和 StarRocks datasource jar
  - 最后把这些 jar 组装进最终镜像
