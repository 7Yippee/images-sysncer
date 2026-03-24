# images-sysncer

把 `image-list.txt` 里的镜像同步到阿里云容器仓库。

当前仓库已经内置 GitHub Actions 自动流程：

- `pull_request`
  - 只校验 `image-list.txt`
  - 不真正推送镜像
- `push main`
  - 校验通过后自动同步到阿里云仓库
- `workflow_dispatch`
  - 手动触发同步

## 目录说明

```text
images-sysncer/
├── .github/workflows/sync-image.yml
├── image-list.txt
└── README.md
```

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

## 需要配置的 Secrets

在 GitHub 仓库 `Settings > Secrets and variables > Actions` 里至少配置：

- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

它们对应的是你的阿里云镜像仓库账号和密码。

## 当前 workflow 的改进点

这版 workflow 已经做了这些增强：

- 修正了 workflow 文件路径触发错误
- `PR` 只做校验，不真正推送
- 去掉了没实际用到的 `buildx`
- 自动规范化镜像名
- 保留源 registry 信息，降低不同镜像源撞名风险
- 目标镜像已存在时自动跳过
- 同步失败自动重试
- 生成日志和 `GitHub Actions Summary`
- 上传 `logs/` 作为 artifact

## 使用方式

### 方式一：改 image-list.txt 后直接 push 到 main

```bash
git add image-list.txt
git commit -m "Update image-list.txt"
git push
```

### 方式二：手动触发

进入 GitHub 仓库页面：

- `Actions`
- 选择 `Sync Images to Aliyun`
- 点击 `Run workflow`

## 命名规则说明

为了减少不同源镜像撞名，目标镜像会保留源 registry 信息并做扁平化，例如：

```text
busybox:1.36
-> registry.cn-guangzhou.aliyuncs.com/tools_y/docker-io_library_busybox:1.36

registry.k8s.io/sig-storage/snapshot-controller:v6.3.3
-> registry.cn-guangzhou.aliyuncs.com/tools_y/registry-k8s-io_sig-storage_snapshot-controller:v6.3.3
```

## 建议

- `MAX_PARALLEL` 先保持 `4`
- 如果后面发现经常被限流，再降到 `3`
- 如果镜像越来越多，建议把 `image-list.txt` 按业务分类写注释，后面更好维护
