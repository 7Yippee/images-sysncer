# images-sysncer

把 `image-list.txt` 里的镜像同步到阿里云容器仓库。

这版已经升级成两层模式：

- 完整名同步层
  - 保留源 registry 信息，避免撞名
- 别名发布层
  - 根据 `image-alias.txt` 再发布一份短名字镜像，适合正式私有仓库使用

## 目录说明

```text
images-sysncer/
├── .github/workflows/sync-image.yml
├── .github/workflows/build-sap-kafka-connect-hana.yml
├── .github/workflows/build-seatunnel-images.yml
├── custom-images/
│   ├── sap-kafka-connect-hana/
│   └── seatunnel-stack/
│       ├── apache-seatunnel/
│       ├── apache-seatunnel-hana/
│       └── seatunnel-web/
├── image-list.txt
├── image-alias.txt
└── README.md
```

## 当前 workflow 行为

- `pull_request`
  - 校验 `image-list.txt` 和 `image-alias.txt`
  - 不真正推送镜像
- `push main`
  - 先同步完整名镜像
  - 如果存在 `image-alias.txt`，继续发布短名字镜像
- `workflow_dispatch`
  - 支持手动选择模式
  - `sync_and_alias`
  - `sync_only`
  - `alias_only`

## image-list.txt 格式

一行一个镜像，支持：

```text
busybox:1.36
docker.io/library/mysql:5.7
registry.k8s.io/sig-storage/snapshot-controller:v6.3.3
rancher/mirrored-library-busybox:1.34.1
ccr.ccs.tencentyun.com/looloodebug/looloodebug
```

也支持注释：

```text
# 工具类
busybox:1.36
```

## image-alias.txt 格式

一行一个映射：

```text
docker.io/library/mysql:5.7 => mysql:5.7
tailscale/tailscale:v1.94.2 => tailscale:v1.94.2
headscale/headscale:v0.28.0 => headscale:v0.28.0
```

含义：

- 左边：源镜像
- 右边：你想发布成的短名字

默认别名会发布到：

```text
registry.cn-guangzhou.aliyuncs.com/tools_y/<alias_repo:tag>
```

如果你想换命名空间，可以改 workflow 里的：

```text
ALI_ALIAS_NAMESPACE
```

如果你想直接写完整目标地址，也支持：

```text
docker.io/library/mysql:5.7 => registry.cn-guangzhou.aliyuncs.com/tools_y_private/mysql:5.7
```

## 需要配置的 Secrets

在 GitHub 仓库 `Settings > Secrets and variables > Actions` 里至少配置：

- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

它们对应阿里云镜像仓库账号和密码。

## 自定义镜像构建

这个仓库现在除了“同步外部镜像”，也支持“构建自定义镜像并推送到阿里云”。

当前已经整理好的自定义镜像包括：

- `SAP Kafka Connect HANA`
- `SeaTunnel 独立项目`

其中 SeaTunnel 相关文件已经单独放到：

- `custom-images/seatunnel-stack/`

这里要特别区分两个角色：

- `seatunnel-web-custom`
  - 是 `Web` 的源码主仓
  - 负责页面、datasource、配置生成、源码级二开
- `images-sysncer`
  - 是发布仓 / buildx 仓
  - 负责 GitHub Actions、多架构构建、阿里云推送

也就是说：

- 先在源码主仓改
- 再把“发布需要的 patch / 版本 / README”同步回这个仓

不要反过来把这个仓当成唯一源码入口。

### SeaTunnel 版本策略

如果目标是：

- 尽量走 `SeaTunnel Web`
- 还要稳定
- 还要适配私有 K8s 集群上的 `AMD` / `ARM`

当前建议先走官方稳定兼容组合：

- `SeaTunnel Engine 2.3.8`
- `SeaTunnel Web 1.0.2`

原因是：

- 官方 `SeaTunnel` 主线 release 比它更新
- 但 `SeaTunnel Web` 官方公开 release 目前还是 `1.0.2`
- 兼容表里明确给出的稳定组合，是 `2.3.8 + 1.0.2`

### SeaTunnel 多架构构建 workflow

对应 workflow：

- `.github/workflows/build-seatunnel-images.yml`

支持：

- `linux/amd64`
- `linux/arm64`

支持构建目标：

- `seatunnel`
- `seatunnel_hana`
- `seatunnel_hana_jdbcplus`
- `seatunnel_web`
- `seatunnel_web_jdbcplus`
- `seatunnel_web_jdbcplus_hana`

支持手动触发：

- `all`
- `seatunnel`
- `seatunnel_hana`
- `seatunnel_hana_jdbcplus`
- `seatunnel_web`
- `seatunnel_web_jdbcplus`
- `seatunnel_web_jdbcplus_hana`

### SeaTunnel 镜像说明

- `custom-images/seatunnel-stack/apache-seatunnel/`
  - SeaTunnel Engine 基础镜像
- `custom-images/seatunnel-stack/apache-seatunnel-hana/`
  - 在 Engine 基础上加入 `ngdbc.jar`
- `custom-images/seatunnel-stack/apache-seatunnel-hana-jdbcplus/`
  - 在 HANA Engine 基础上继续加入 MySQL / Oracle / SQLServer JDBC 驱动
- `custom-images/seatunnel-stack/seatunnel-web/`
  - SeaTunnel Web 镜像，内置 Engine 运行库与 `plugin-mapping.properties`
- `custom-images/seatunnel-stack/seatunnel-web-jdbcplus/`
  - SeaTunnel Web JDBCPlus 镜像，额外带 MySQL / Oracle / SQLServer Web datasource
- `custom-images/seatunnel-stack/seatunnel-web-jdbcplus-hana/`
  - SeaTunnel Web HANA 可视化版，额外带 HANA datasource 与 `ngdbc.jar`

### 当前 SeaTunnel Web 已做过的关键增强

这套构建链当前已经覆盖的核心增强包括：

- `JDBC-Hana` datasource
- `seatunnel-datasource-client` 补齐后的 datasource 枚举
- `StarRocks JDBC Url` 数据库路径拼接修复
- `StarRocks` sink `Target Table` 手工输入
- `StarRocks` sink 识别条件放宽，不再只认精确值 `StarRocks`
- Web 镜像内带 `/opt/seatunnel`、`plugin-mapping.properties` 和运行库

如果后面你在 `seatunnel-web-custom` 又做了新的页面能力或源码修补，记得同步回来至少这几处：

- `custom-images/seatunnel-stack/seatunnel-web-jdbcplus-hana/patches/0001-seatunnel-web-hana-ui.patch`
- `custom-images/seatunnel-stack/*/versions.env`
- `custom-images/seatunnel-stack/*/README.md`
- 本仓根 README

这些镜像都采用“workflow 自动下载官方安装包”的方式，不把大体积二进制包直接塞进 Git 仓库里，后续维护更轻。

## 命名规则说明

完整名同步层会保留源 registry 信息并做扁平化，例如：

```text
busybox:1.36
-> registry.cn-guangzhou.aliyuncs.com/tools_y/docker-io_library_busybox:1.36

registry.k8s.io/sig-storage/snapshot-controller:v6.3.3
-> registry.cn-guangzhou.aliyuncs.com/tools_y/registry-k8s-io_sig-storage_snapshot-controller:v6.3.3
```

别名发布层再给你一份更短的名字，例如：

```text
docker.io/library/mysql:5.7
-> registry.cn-guangzhou.aliyuncs.com/tools_y/docker-io_library_mysql:5.7
-> registry.cn-guangzhou.aliyuncs.com/tools_y/mysql:5.7
```

## 使用方式

### 方式一：改文件后直接 push 到 main

```bash
git add image-list.txt image-alias.txt
git commit -m "Update image sync config"
git push
```

### 方式二：手动触发

进入 GitHub 仓库页面：

- `Actions`
- 选择 `Sync Images to Aliyun`
- 点击 `Run workflow`

推荐这样用：

- 只想同步完整名仓库：`sync_only`
- 今天完整名已经同步好了，只想再推一份短名字：`alias_only`
- 两层都一起跑：`sync_and_alias`

## 这版 workflow 的增强点

- `PR` 只做校验，不真正推送
- 自动规范化镜像名
- 保留源 registry 信息，降低撞名风险
- 完整名镜像已存在时自动跳过
- 同步失败自动重试
- 支持 `image-alias.txt` 别名发布
- 支持手动选择 `sync_only` / `alias_only`
- 别名发布直接在阿里云仓库内部复制，通常比重新拉外网更快
- 生成日志和 `GitHub Actions Summary`
- 上传 `logs/` 作为 artifact

## 建议

- `MAX_PARALLEL` 先保持 `4`
- 如果经常被限流，再降到 `3`
- 完整名同步层不要截断，保持唯一性
- 正式私有仓库用 `image-alias.txt` 发短名字，更适合日常使用
