# 自定义镜像构建区

这个目录存放需要**自行构建**的镜像定义（独立或共享 Dockerfile + 版本配置 + 构建说明）。

> 与仓库根目录的"镜像同步"职责不同，这里的镜像**不是从公网搬运的**，而是在 GitHub Actions 中从源码/安装包构建后推送到阿里云。

## 目录结构

```text
custom-images/
└── seatunnel-stack/             # SeaTunnel 镜像（Engine + Web）
```

## 与镜像同步的区别

| 维度 | 镜像同步（仓库根） | 自定义构建（本目录） |
|------|-------------------|---------------------|
| 做什么 | 把外部公网镜像搬到阿里云 | 从 Dockerfile 构建私有镜像 |
| 触发方式 | 修改 `image-list.txt` / `image-alias.txt` | 修改 `custom-images/` 下的文件 |
| 工具 | `skopeo copy` | `docker buildx` |
| 对应 workflow | `sync-image.yml` | `build-seatunnel-images.yml` |

## 当前包含的自定义镜像

### SeaTunnel Stack

- 路径: `seatunnel-stack/`
- 用途: Apache SeaTunnel 数据集成平台多架构镜像（`linux/amd64` + `linux/arm64`）
- Workflow: `.github/workflows/build-seatunnel-images.yml`
- 详细说明: 见 [seatunnel-stack/README.md](./seatunnel-stack/README.md)

## 添加新的自定义镜像

1. 在 `custom-images/` 下新建目录
2. 至少包含: `versions.env`、`README.md`
3. 如果是独立构建，目录内放 `Dockerfile`
4. 如果多个变体共用同一个 Dockerfile，把共享 Dockerfile 放到上层公共目录，并在 workflow 的 `dockerfile` 字段中显式指定
5. 在 `.github/workflows/` 下新增或扩展对应的构建 workflow
6. 在本文件中补充说明
