# SeaTunnel 发布导航与补丁同步说明

这份文档是给“打开 `images-sysncer` 想继续维护 SeaTunnel 镜像的人”准备的。

一句话先说清：

- 这个目录是发布仓
- 不是 `Web` 和 `Engine` 的唯一源码主仓

## 1. 这个目录负责什么

`custom-images/seatunnel-stack/` 负责：

- 多架构构建
- GitHub Actions 发版
- 阿里云镜像推送
- 自定义镜像目录收口

它不负责长期承接下面这些源码主责任：

- `SeaTunnel Web` 页面逻辑
- datasource 注册逻辑
- 作业配置生成逻辑
- `Engine` 的方言修补源码

## 2. 想改功能，先去哪里

如果你想改：

- `Web` 页面
- HANA datasource
- `StarRocks` 目标表输入逻辑
- Web 配置生成逻辑

优先去源码主仓：

- [7Yippee/seatunnel-web-custom](https://github.com/7Yippee/seatunnel-web-custom)

## 3. 这个发布仓当前承接了哪些定制结果

当前 `seatunnel-web-jdbcplus-hana` 这条发布链已经承接了这些定制能力：

- `JDBC-Hana` datasource
- `seatunnel-datasource-client` 补齐后的 datasource 注册结果
- `StarRocks JDBC Url` 数据库路径拼接修复
- `StarRocks` sink `Target Table` 手工输入
- `StarRocks` sink 识别条件放宽
- Web 镜像内带 `/opt/seatunnel`、`plugin-mapping.properties` 和运行库

## 4. 后面发新版镜像，建议怎么做

推荐顺序：

1. 先在 `seatunnel-web-custom` 改源码
2. 在源码仓本地构建验证
3. 把发布所需文件同步到这里
4. 再从本仓走 `build-seatunnel-images.yml`

## 5. 每次从源码仓同步回来，至少检查这些文件

- `custom-images/seatunnel-stack/seatunnel-web-jdbcplus-hana/patches/0001-seatunnel-web-hana-ui.patch`
- `custom-images/seatunnel-stack/seatunnel-web-jdbcplus-hana/versions.env`
- `custom-images/seatunnel-stack/seatunnel-web-jdbcplus-hana/README.md`
- `custom-images/seatunnel-stack/README.md`
- 仓库根 `README.md`

## 6. 目录怎么理解

- `apache-seatunnel/`
  - Engine 基础镜像
- `apache-seatunnel-hana/`
  - Engine + `ngdbc`
- `apache-seatunnel-hana-jdbcplus/`
  - Engine + HANA + MySQL/Oracle/SQLServer JDBC
- `seatunnel-web/`
  - Web 基础镜像
- `seatunnel-web-jdbcplus/`
  - Web + MySQL/Oracle/SQLServer datasource
- `seatunnel-web-jdbcplus-hana/`
  - Web + HANA datasource + HANA 驱动 + StarRocks 相关页面修补

## 7. 一句话记住

源码在源码仓改，发布在这个仓做。
