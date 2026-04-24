# Apache SeaTunnel HANA Image

这个目录用于构建带 `SAP HANA JDBC Driver (ngdbc.jar)` 的 `Apache SeaTunnel` 镜像。

当前策略：

- 基础引擎版本：`2.3.8`
- 驱动版本：`ngdbc 2.10.14`
- 架构：`linux/amd64`、`linux/arm64`
- 目标：用于 `HANA -> SeaTunnel -> StarRocks` 的私有 K8s 集群部署

设计原则：

- 继续沿用和 `SeaTunnel Web 1.0.2` 兼容的稳定 Engine 版本
- 在 GitHub Actions 中自动下载官方 `SeaTunnel` 包和 `ngdbc.jar`
- 通过 `docker buildx` 一次构建 `amd64` 和 `arm64`

对应 workflow：

- `.github/workflows/build-seatunnel-images.yml`

