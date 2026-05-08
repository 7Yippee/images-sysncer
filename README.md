# images-sysncer

容器镜像管理仓库，包含两大功能：

1. **镜像同步** — 把公网镜像搬运到阿里云私有仓库
2. **自定义构建** — 从 Dockerfile 构建私有镜像并推送

## 目录结构

```text
images-sysncer/
├── .github/workflows/
│   ├── sync-image.yml                    # 镜像同步 workflow
│   ├── build-sap-kafka-connect-hana.yml  # SAP Kafka Connect 构建
│   └── build-seatunnel-images.yml        # SeaTunnel 全套构建
├── custom-images/                        # 自定义镜像构建区
│   ├── README.md                         # 构建区说明
│   ├── sap-kafka-connect-hana/           # SAP HANA Kafka Connect
│   └── seatunnel-stack/                  # SeaTunnel 全套镜像
├── image-list.txt                        # 需要同步的镜像清单
├── image-alias.txt                       # 别名发布映射表
└── README.md
```

---

## 一、镜像同步

### 工作原理

采用两层模式，通过 `skopeo` 实现 registry 到 registry 的直接复制：

| 层 | 说明 | 示例 |
|---|------|------|
| 完整名同步层 | 保留源 registry 信息，扁平化命名 | `busybox:1.36` → `tools_y/docker-io_library_busybox:1.36` |
| 别名发布层 | 根据映射表发布短名字 | → `tools_y/busybox:1.36` |

### 使用方式

#### 添加新镜像

编辑 `image-list.txt`，一行一个镜像：

```text
# 分类注释
docker.io/library/redis:7.2
registry.k8s.io/ingress-nginx/controller:v1.10.0
```

如果需要短名字，同时编辑 `image-alias.txt`：

```text
docker.io/library/redis:7.2 => redis:7.2
```

#### 触发方式

| 方式 | 行为 |
|------|------|
| Push 到 main | 自动同步 + 别名发布 |
| Pull Request | 仅校验格式，不推送 |
| 手动触发 | 可选 `sync_and_alias` / `sync_only` / `alias_only` |

### 命名规则

完整名同步层会保留源 registry 信息并做扁平化：

```text
registry.k8s.io/sig-storage/snapshot-controller:v6.3.3
→ registry.cn-guangzhou.aliyuncs.com/tools_y/registry-k8s-io_sig-storage_snapshot-controller:v6.3.3
```

别名发布层再给一份短名字：

```text
→ registry.cn-guangzhou.aliyuncs.com/tools_y/snapshot-controller:v6.3.3
```

### Workflow 特性

- PR 只做校验，不真正推送
- 自动规范化镜像名
- 目标已存在时自动跳过
- 同步失败自动重试（默认 3 次）
- 并行同步（默认 4 路）
- 别名在阿里云仓库内部复制，比重新拉外网更快
- 生成 Summary + 上传日志 artifact

---

## 二、自定义镜像构建

详细说明见 [custom-images/README.md](./custom-images/README.md)。

### SAP Kafka Connect HANA

带 SAP HANA Connector 的 Kafka Connect 镜像。

- Workflow: `build-sap-kafka-connect-hana.yml`
- 详情: [custom-images/sap-kafka-connect-hana/README.md](./custom-images/sap-kafka-connect-hana/README.md)

### SeaTunnel Stack

Apache SeaTunnel 数据集成平台全套镜像（Engine + Web，共 6 个变体），支持多架构。

- Workflow: `build-seatunnel-images.yml`
- 详情: [custom-images/seatunnel-stack/README.md](./custom-images/seatunnel-stack/README.md)
- 发布导航: [00-SeaTunnel 发布导航与补丁同步说明.md](./custom-images/seatunnel-stack/00-SeaTunnel%20发布导航与补丁同步说明.md)

> **注意**: 本仓库是 SeaTunnel 的**发布仓**，不是源码主仓。源码修改请去 [7Yippee/seatunnel-web-custom](https://github.com/7Yippee/seatunnel-web-custom)。

---

## 三、配置

### 必需的 Secrets

在 GitHub 仓库 `Settings > Secrets and variables > Actions` 中配置：

| Secret | 说明 |
|--------|------|
| `DOCKER_USERNAME` | 阿里云镜像仓库用户名 |
| `DOCKER_PASSWORD` | 阿里云镜像仓库密码 |

### 可调参数（在 workflow 中修改）

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `ALI_REGISTRY` | `registry.cn-guangzhou.aliyuncs.com` | 阿里云 registry 地址 |
| `ALI_NAMESPACE` | `tools_y` | 完整名同步命名空间 |
| `ALI_ALIAS_NAMESPACE` | `tools_y` | 别名发布命名空间 |
| `MAX_PARALLEL` | `4` | 并行同步数（被限流可降到 3） |
| `RETRY_TIMES` | `3` | 失败重试次数 |
