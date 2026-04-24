# Apache SeaTunnel Engine Image

这个目录用于构建 `Apache SeaTunnel Engine` 基础镜像。

当前策略：

- 版本：`2.3.8`
- 架构：`linux/amd64`、`linux/arm64`
- 目的：优先保证和 `SeaTunnel Web 1.0.2` 的官方稳定兼容
- 内置连接器：`connector-jdbc`、`connector-starrocks`

对应 workflow：

- `.github/workflows/build-seatunnel-images.yml`

为什么先用 `2.3.8`：

- 官方最新 SeaTunnel release 已经更高
- 但官方 `SeaTunnel Web` 当前公开 release 还是 `1.0.2`
- 官方兼容表明确给出的稳定组合，是 `SeaTunnel 2.3.8 + SeaTunnel Web 1.0.2`

如果后面你们确认要切到更新的 Engine 版本，建议和 Web 兼容性一起评估，不要只升其中一端。
