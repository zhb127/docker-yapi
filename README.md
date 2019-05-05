## 构建容器镜像

通过 git submodule 方式，提前下载 [yapi 源码](git@github.com:YMFE/yapi.git) 到 `code` 目录：

```bash
# 需要将 .gitmodules 替换为你有权限访问的 git 仓库地址
git submodule update
```

构建容器镜像：

```bash
docker build -t zhb127/yapi ./
```

## 运行容器镜像

运行依赖容器镜像：

```bash
# 创建 mongodb 存储卷（持久化）
docker volume create yapi-mongodb

# 运行 mongodb 镜像容器，挂载存储卷，并映射服务端口到宿主机 27017 端口
docker run -d --name yapi-mongodb -v yapi-mongodb:/data/db -p 27017:27017 mongo:latest
```

创建 yapi 配置文件 config.json ：

```bash
cat > config.json <<EOF
{
  "port": "3000",
  "adminAccount": "admin@admin",
  "versionNotify": true,
  "db": {
    "servername": "yapi-mongodb",
    "DATABASE": "yapi",
    "port": 27017
  },
  "mail": {
    "enable": false
  }
}
EOF
```

> 注意！由于 yapi 默认是内网部署的，管理员密码统一为 `ymfe.org`，不能通过配置文件修改（可自行修改代码或数据库）。完整的配置项可到源码目录中查看 config.json.example 文件。

运行 yapi 容器镜像：

```bash
docker run -d --name yapi -p 3000:3000 -v $(pwd)/config.json:/yapi/config.json --link yapi-mongodb zhb127/yapi
```