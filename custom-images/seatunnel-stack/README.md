# SeaTunnel Stack

这个目录把 SeaTunnel 相关镜像单独收成一个小项目，避免和其他自定义镜像散落在同一层。

当前包含：

- `apache-seatunnel/`
- `apache-seatunnel-hana/`
- `apache-seatunnel-hana-jdbcplus/`
- `seatunnel-web/`
- `seatunnel-web-jdbcplus/`
- `seatunnel-web-jdbcplus-hana/`

适用场景：

- `SeaTunnel Engine`
- `SAP HANA -> SeaTunnel`
- `SeaTunnel Web`

对应的 GitHub Actions workflow：

- `.github/workflows/build-seatunnel-images.yml`

当前默认版本策略：

- `SeaTunnel Engine 2.3.8`
- `SeaTunnel Web 1.0.2`
- `ngdbc 2.10.14`
- 多架构：`linux/amd64`、`linux/arm64`

## 先看这里

- [00-SeaTunnel 发布导航与补丁同步说明.md](./00-SeaTunnel%20发布导航与补丁同步说明.md)
- Web 源码主仓：[7Yippee/seatunnel-web-custom](https://github.com/7Yippee/seatunnel-web-custom)

## 长期维护建议

当前这个目录更适合作为：

- 统一发布仓
- 多架构构建仓
- 阿里云镜像发布仓

源码主责任建议放在：

- `seatunnel-engine-custom`
- `seatunnel-web-custom`

也就是说，这个目录回答的是：

- 怎么统一构建
- 怎么统一发版
- 怎么把镜像推到阿里云

而不是：

- Web 页面源码从哪里继续改
- Engine 方言从哪里继续修

如果后面 `SeaTunnel Engine` 和 `SeaTunnel Web` 还要继续长期二开，建议把源码主责任拆出去：

- `Engine` 独立一个私有 GitHub 项目
- `Web` 独立一个私有 GitHub 项目

也就是说：

- `custom-images/seatunnel-stack/` 可以继续保留
- 但更适合承接发布和 buildx
- 不建议继续长期充当 `Engine` 和 `Web` 的唯一源码主仓

## 继续开发时的最短路径

1. 先在源码仓改：
   - `seatunnel-web-custom`
   - `seatunnel-engine-custom`
2. 本地验证构建通过
3. 再把发布所需 patch / 版本 / README 同步到这里
4. 最后用 GitHub Actions 发版
