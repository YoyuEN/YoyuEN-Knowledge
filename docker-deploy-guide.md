# YoyuEN-Knowledge Docker 部署指南

本文档指导你如何在 Ubuntu 云服务器上使用 Docker 部署 YoyuEN-Knowledge 项目。

---

## 一、部署架构

| 服务 | 镜像 | 端口 | 说明 |
|------|------|------|------|
| Nginx | nginx:alpine | 80 / 443 | 反向代理 + 前端静态文件托管 |
| Frontend | 自定义构建 | - | Vite 构建的 Vue3 SPA |
| Backend | eclipse-temurin:21-jre | 12138 | Spring Boot 3 后端服务 |
| PostgreSQL | pgvector/pgvector:pg16 | 5432 | 主数据库（含 PgVector 向量扩展） |
| MongoDB | mongo:7 | 27017 | 聊天记录存储 |
| Redis | redis:7-alpine | 6379 | 缓存 |
| MinIO | minio/minio:latest | 9000 / 9001 | 对象存储 |

---

## 二、服务器环境准备

### 2.1 更新系统

```bash
sudo apt update && sudo apt upgrade -y
```

### 2.2 安装 Docker

```bash
# 卸载旧版本
sudo apt remove docker docker-engine docker.io containerd runc -y

# 安装依赖
sudo apt install ca-certificates curl gnupg lsb-release -y

# 添加 Docker 官方 GPG 密钥
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 添加仓库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# 验证
sudo docker --version
sudo docker compose version
```

### 2.3 配置 Docker 非 root 用户（可选）

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 三、项目目录准备

在服务器上创建部署目录：

```bash
mkdir -p ~/yoyuen-knowledge/{backend,frontend,nginx,postgres-data,mongo-data,redis-data,minio-data,config}
cd ~/yoyuen-knowledge
```

上传项目代码到对应目录：

```bash
# 本地执行（将代码上传到服务器）
scp -r ./Backend root@your-server-ip:~/yoyuen-knowledge/backend
scp -r ./Fronted root@your-server-ip:~/yoyuen-knowledge/frontend
```

最终服务器目录结构：

```
~/yoyuen-knowledge/
├── backend/              # Spring Boot 源码
├── frontend/             # Vue3 源码
├── nginx/
│   └── nginx.conf        # Nginx 配置文件
├── config/
│   └── application-docker.properties  # 后端生产环境配置
├── postgres-data/        # PostgreSQL 数据持久化
├── mongo-data/           # MongoDB 数据持久化
├── redis-data/           # Redis 数据持久化
├── minio-data/           # MinIO 数据持久化
└── docker-compose.yml
```

---

## 四、配置文件

### 4.1 后端生产环境配置

创建 `~/yoyuen-knowledge/config/application-docker.properties`：

```properties
# 端口与上下文
server.port=12138
server.servlet.context-path=/api

# DashScope API Key（必须替换为你的真实 Key）
spring.ai.openai.api-key=${DASHSCOPE_API_KEY}
spring.ai.openai.chat.options.model=qwen-max
spring.ai.openai.base-url=https://dashscope.aliyuncs.com/compatible-mode

# PostgreSQL（使用 Docker 服务名连接）
spring.datasource.url=jdbc:postgresql://postgres:5432/know-ai
spring.datasource.username=postgres
spring.datasource.password=${DB_PASSWORD:yoyuen_pass_2026}
spring.datasource.driver-class-name=org.postgresql.Driver
spring.datasource.type=com.zaxxer.hikari.HikariDataSource

# JPA
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=true

# 连接池
spring.datasource.hikari.pool-name=HikariCP
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.idle-timeout=60000
spring.datasource.hikari.max-lifetime=1800000
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.connection-test-query=SELECT 1

# 文件上传限制
spring.servlet.multipart.max-file-size=500MB
spring.servlet.multipart.max-request-size=500MB

# MyBatis-Plus
mybatis-plus.mapper-locations=classpath*:mapper/*.xml
mybatis-plus.type-aliases-package=com.yoyuen.backend.entity
mybatis-plus.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl
mybatis-plus.global-config.db-config.logic-delete-field=deleted
mybatis-plus.global-config.db-config.logic-delete-value=true
mybatis-plus.global-config.db-config.logic-not-delete-value=false

# Knife4j / Swagger（生产环境建议关闭）
springdoc.api-docs.enabled=true
springdoc.swagger-ui.enabled=true

# MinIO（使用 Docker 内部网络）
minio.endpoint=http://minio:9000
minio.access-key=${MINIO_ROOT_USER:minioadmin}
minio.secret-key=${MINIO_ROOT_PASSWORD:minioadmin}
minio.bucket-name=default

# MongoDB
spring.data.mongodb.uri=mongodb://root:${MONGO_PASSWORD:yoyuen_mongo_2026}@mongodb:27017/chat_db?authSource=admin
spring.data.mongodb.database=backend
spring.data.mongodb.auto-index-creation=true
spring.data.mongodb.auto-create-index=true

# Redis
spring.data.redis.host=redis
spring.data.redis.port=6379
spring.data.redis.password=${REDIS_PASSWORD:yoyuen_redis_2026}
spring.data.redis.database=0
spring.data.redis.timeout=3000ms
spring.data.redis.lettuce.pool.max-active=8
spring.data.redis.lettuce.pool.max-idle=8
spring.data.redis.lettuce.pool.min-idle=1
spring.data.redis.lettuce.pool.max-wait=1000ms

# PgVector
spring.ai.vectorstore.pgvector.initialize-schema=true
spring.ai.vectorstore.pgvector.index-type=HNSW
spring.ai.vectorstore.pgvector.distance-type=COSINE_DISTANCE
spring.ai.vectorstore.pgvector.dimensions=1024

# Security JWT
security.secret=${JWT_SECRET:YoyuEN_JWT_Secret_Key_2026_Change_This}
security.salt=${JWT_SALT:YoyuEN_JWT_Salt_2026_Change_This}
security.allow-list[0]=/v3/**
security.allow-list[1]=/swagger-ui/**
security.allow-list[2]=/doc.html
security.allow-list[3]=/webjars/**
security.allow-list[4]=/auth/login
security.allow-list[5]=/auth/logout
security.allow-list[6]=/ai/chat/**
security.allow-list[7]=/login/oauth2/**
security.allow-list[8]=/conversation/**
security.allow-list[9]=/knowledge/**
security.allow-list[10]=/resource/**
security.allow-list[11]=/comment/**
security.allow-list[12]=/content/**
security.allow-list[13]=/murmur/**
security.allow-list[14]=/photo/**
security.allow-list[15]=/diary/**
security.allow-list[16]=/profile/**
security.admin-init=true
security.password=${ADMIN_PASSWORD:yoyuen_admin_2026}

# Volcengine（可选，按需配置）
volcengine.access-key=${VOLCENGINE_ACCESS_KEY:}
volcengine.secret-key=${VOLCENGINE_SECRET_KEY:}
volcengine.region=cn-north-1
volcengine.cv.endpoint=https://visual.volcengineapi.com
volcengine.ark.endpoint=https://ark.cn-beijing.volces.com/api/v3
volcengine.ark.api-key=${VOLCENGINE_ARK_API_KEY:}
volcengine.ark.model=doubao-seedream-4-5-251128
```

> **注意**：
> 1. 请将 `${DASHSCOPE_API_KEY}` 替换为你的真实 DashScope API Key
> 2. 请将 `JWT_SECRET`、`JWT_SALT` 替换为强密码
> 3. 生产环境建议关闭 Swagger：`springdoc.api-docs.enabled=false`

### 4.2 Nginx 配置

创建 `~/yoyuen-knowledge/nginx/nginx.conf`：

```nginx
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    server {
        listen 80;
        server_name localhost;  # 替换为你的域名

        # 前端静态文件
        location / {
            root /usr/share/nginx/html;
            index index.html;
            try_files $uri $uri/ /index.html;
        }

        # 后端 API 代理
        location /api/ {
            proxy_pass http://backend:12138/api/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_connect_timeout 600;
            proxy_send_timeout 600;
            proxy_read_timeout 600;
        }

        # AI 聊天 SSE 流式响应（长连接）
        location /api/assistant/report {
            proxy_pass http://backend:12138/api/assistant/report;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Connection '';
            proxy_http_version 1.1;
            chunked_transfer_encoding off;
            proxy_buffering off;
            proxy_cache off;
            proxy_read_timeout 86400s;
        }

        # MinIO 文件访问（可选，如需直接暴露）
        location /minio/ {
            proxy_pass http://minio:9001/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

### 4.3 Docker Compose 配置

创建 `~/yoyuen-knowledge/docker-compose.yml`：

```yaml
version: '3.8'

services:
  # PostgreSQL 主数据库（含 PgVector 扩展）
  postgres:
    image: pgvector/pgvector:pg16
    container_name: yoyuen-postgres
    restart: always
    environment:
      POSTGRES_DB: know-ai
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${DB_PASSWORD:-yoyuen_pass_2026}
    volumes:
      - ./postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - yoyuen-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  # MongoDB 聊天记录
  mongodb:
    image: mongo:7
    container_name: yoyuen-mongodb
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD:-yoyuen_mongo_2026}
      MONGO_INITDB_DATABASE: chat_db
    volumes:
      - ./mongo-data:/data/db
    ports:
      - "27017:27017"
    networks:
      - yoyuen-network
    command: mongod --auth
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongosh localhost:27017/chat_db --quiet
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis 缓存
  redis:
    image: redis:7-alpine
    container_name: yoyuen-redis
    restart: always
    command: redis-server --requirepass ${REDIS_PASSWORD:-yoyuen_redis_2026}
    volumes:
      - ./redis-data:/data
    ports:
      - "6379:6379"
    networks:
      - yoyuen-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # MinIO 对象存储
  minio:
    image: minio/minio:latest
    container_name: yoyuen-minio
    restart: always
    environment:
      MINIO_ROOT_USER: ${MINIO_ROOT_USER:-minioadmin}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD:-minioadmin}
    volumes:
      - ./minio-data:/data
    ports:
      - "9000:9000"
      - "9001:9001"
    networks:
      - yoyuen-network
    command: server /data --console-address ":9001"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 20s
      retries: 3

  # Spring Boot 后端
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: yoyuen-backend
    restart: always
    depends_on:
      postgres:
        condition: service_healthy
      mongodb:
        condition: service_healthy
      redis:
        condition: service_healthy
      minio:
        condition: service_healthy
    environment:
      DASHSCOPE_API_KEY: ${DASHSCOPE_API_KEY}
      DB_PASSWORD: ${DB_PASSWORD:-yoyuen_pass_2026}
      MONGO_PASSWORD: ${MONGO_PASSWORD:-yoyuen_mongo_2026}
      REDIS_PASSWORD: ${REDIS_PASSWORD:-yoyuen_redis_2026}
      MINIO_ROOT_USER: ${MINIO_ROOT_USER:-minioadmin}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD:-minioadmin}
      JWT_SECRET: ${JWT_SECRET:-YoyuEN_JWT_Secret_Key_2026_Change_This}
      JWT_SALT: ${JWT_SALT:-YoyuEN_JWT_Salt_2026_Change_This}
      ADMIN_PASSWORD: ${ADMIN_PASSWORD:-yoyuen_admin_2026}
      SPRING_CONFIG_LOCATION: classpath:/,file:/app/config/
    volumes:
      - ./config/application-docker.properties:/app/config/application.properties
    ports:
      - "12138:12138"
    networks:
      - yoyuen-network

  # Vue3 前端（Nginx 托管）
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: yoyuen-frontend
    restart: always
    depends_on:
      - backend
    networks:
      - yoyuen-network

  # Nginx 反向代理
  nginx:
    image: nginx:alpine
    container_name: yoyuen-nginx
    restart: always
    depends_on:
      - frontend
      - backend
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      # SSL 证书（可选，配置 HTTPS 时启用）
      # - ./ssl/cert.pem:/etc/nginx/ssl/cert.pem:ro
      # - ./ssl/key.pem:/etc/nginx/ssl/key.pem:ro
    networks:
      - yoyuen-network

networks:
  yoyuen-network:
    driver: bridge
```

### 4.4 后端 Dockerfile

创建 `~/yoyuen-knowledge/backend/Dockerfile`：

```dockerfile
# 构建阶段
FROM maven:3.9-eclipse-temurin-21-alpine AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

# 打包（跳过测试加速构建）
RUN mvn clean package -DskipTests

# 运行阶段
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# 复制 jar 包
COPY --from=builder /app/target/*.jar app.jar

# 创建配置目录
RUN mkdir -p /app/config

# 暴露端口
EXPOSE 12138

# JVM 参数优化（可根据服务器内存调整）
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:InitialRAMPercentage=50.0 -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar --spring.config.additional-location=file:/app/config/"]
```

### 4.5 前端 Dockerfile

创建 `~/yoyuen-knowledge/frontend/Dockerfile`：

```dockerfile
# 构建阶段
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install --registry=https://registry.npmmirror.com

COPY . .
RUN npm run build

# 运行阶段（Nginx 托管）
FROM nginx:alpine

# 复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制自定义 Nginx 配置（可选，如果使用外部 Nginx 则不需要）
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### 4.6 环境变量文件

创建 `~/yoyuen-knowledge/.env`：

```bash
# 数据库密码
DB_PASSWORD=yoyuen_pass_2026

# MongoDB 密码
MONGO_PASSWORD=yoyuen_mongo_2026

# Redis 密码
REDIS_PASSWORD=yoyuen_redis_2026

# MinIO 账号
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin

# DashScope API Key（必须修改）
DASHSCOPE_API_KEY=your-dashscope-api-key-here

# JWT 密钥（必须修改，生产环境请使用强密码）
JWT_SECRET=YoyuEN_JWT_Secret_Key_2026_Change_This
JWT_SALT=YoyuEN_JWT_Salt_2026_Change_This

# 管理员初始密码
ADMIN_PASSWORD=yoyuen_admin_2026

# 火山引擎（可选）
VOLCENGINE_ACCESS_KEY=
VOLCENGINE_SECRET_KEY=
VOLCENGINE_ARK_API_KEY=
```

> **安全提示**：`.env` 文件包含敏感信息，请勿提交到 Git 仓库。

---

## 五、构建与启动

### 5.1 首次部署

```bash
cd ~/yoyuen-knowledge

# 1. 加载环境变量
export $(cat .env | xargs)

# 2. 构建并启动所有服务（后台运行）
sudo docker compose up -d --build

# 3. 查看启动日志
sudo docker compose logs -f backend

# 4. 等待所有服务健康检查通过
sudo docker compose ps
```

### 5.2 初始化数据库（首次部署必需）

```bash
# 进入 PostgreSQL 容器执行初始化 SQL
sudo docker compose exec -it postgres psql -U postgres -d know-ai

# 在 psql 中执行以下命令（或提前准备好 SQL 文件导入）
# 例如：
# \i /docker-entrypoint-initdb.d/init.sql
```

如果你本地有初始化 SQL 文件（如 `init.sql`），可以放到 `~/yoyuen-knowledge/postgres-data/` 目录下，然后：

```bash
sudo docker cp ./init.sql yoyuen-postgres:/tmp/init.sql
sudo docker compose exec -it postgres psql -U postgres -d know-ai -f /tmp/init.sql
```

### 5.3 初始化 MinIO Bucket

```bash
# 进入 MinIO 容器创建默认 bucket 并设置公开读
sudo docker compose exec -it minio mc alias set local http://localhost:9000 minioadmin minioadmin
sudo docker compose exec -it minio mc mb local/default --ignore-existing
sudo docker compose exec -it minio mc anonymous set download local/default
```

---

## 六、验证部署

### 6.1 服务健康检查

```bash
# 查看所有容器状态
sudo docker compose ps

# 检查后端接口
curl http://localhost/api/content/list

# 检查前端页面
curl -I http://localhost

# 检查 Swagger 文档（如需外网访问请替换为服务器 IP）
# http://your-server-ip/api/doc.html
```

### 6.2 登录后台

1. 访问 `http://your-server-ip`
2. 使用管理员账号登录：
   - 用户名：`admin`
   - 密码：`.env` 中配置的 `ADMIN_PASSWORD`

---

## 七、HTTPS 配置（推荐）

### 7.1 使用 Let's Encrypt 免费证书

```bash
# 安装 Certbot
sudo apt install certbot python3-certbot-nginx -y

# 申请证书（替换为你的域名）
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# 自动续期测试
sudo certbot renew --dry-run
```

### 7.2 手动配置 SSL

将证书文件放入 `~/yoyuen-knowledge/ssl/` 目录：

```bash
mkdir -p ~/yoyuen-knowledge/ssl
# 上传你的证书和私钥
# ssl/cert.pem
# ssl/key.pem
```

修改 `docker-compose.yml` 中 nginx 服务的 volumes 注释：

```yaml
volumes:
  - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
  - ./ssl/cert.pem:/etc/nginx/ssl/cert.pem:ro
  - ./ssl/key.pem:/etc/nginx/ssl/key.pem:ro
```

修改 `nginx/nginx.conf` 添加 HTTPS server 块：

```nginx
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;  # HTTP 强制跳转 HTTPS
}

server {
    listen 443 ssl;
    server_name your-domain.com;

    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # ... 其他 location 配置与之前相同
}
```

重启 Nginx：

```bash
sudo docker compose restart nginx
```

---

## 八、日常运维命令

### 8.1 查看日志

```bash
# 查看所有服务日志
sudo docker compose logs -f

# 查看指定服务日志
sudo docker compose logs -f backend
sudo docker compose logs -f nginx
sudo docker compose logs -f postgres

# 查看最近 100 行日志
sudo docker compose logs --tail=100 backend
```

### 8.2 重启服务

```bash
# 重启所有服务
sudo docker compose restart

# 重启单个服务
sudo docker compose restart backend
sudo docker compose restart nginx
```

### 8.3 更新部署

```bash
cd ~/yoyuen-knowledge

# 1. 拉取最新代码
git pull origin main

# 2. 重新构建并启动
sudo docker compose up -d --build

# 3. 清理旧镜像（可选）
sudo docker image prune -f
```

### 8.4 备份数据

```bash
# 备份 PostgreSQL
sudo docker compose exec postgres pg_dump -U postgres know-ai > backup_$(date +%Y%m%d).sql

# 备份 MongoDB
sudo docker compose exec mongodb mongodump --uri="mongodb://root:your-password@localhost:27017/chat_db?authSource=admin" --out=/tmp/backup
sudo docker cp yoyuen-mongodb:/tmp/backup ./mongo-backup-$(date +%Y%m%d)

# 备份 Redis（RDB 文件已持久化到 ./redis-data）
cp -r ~/yoyuen-knowledge/redis-data ./redis-backup-$(date +%Y%m%d)

# 备份 MinIO 数据
cp -r ~/yoyuen-knowledge/minio-data ./minio-backup-$(date +%Y%m%d)
```

### 8.5 进入容器调试

```bash
# 进入后端容器
sudo docker compose exec -it backend sh

# 进入 PostgreSQL
sudo docker compose exec -it postgres psql -U postgres -d know-ai

# 进入 Redis
sudo docker compose exec -it redis redis-cli -a your-password

# 进入 MongoDB
sudo docker compose exec -it mongodb mongosh -u root -p your-password --authenticationDatabase admin
```

### 8.6 停止和清理

```bash
# 停止所有服务（保留数据）
sudo docker compose down

# 停止并删除所有数据（⚠️ 危险操作）
sudo docker compose down -v
rm -rf ~/yoyuen-knowledge/postgres-data ~/yoyuen-knowledge/mongo-data ~/yoyuen-knowledge/redis-data ~/yoyuen-knowledge/minio-data
```

---

## 九、常见问题

### Q1: 前端页面刷新后 404

A: Nginx 已配置 `try_files $uri $uri/ /index.html;`，确保 Vue Router 的 history 模式正常工作。如果仍出现 404，检查 nginx.conf 是否正确挂载。

### Q2: 后端连接数据库失败

A: 检查以下几点：
1. PostgreSQL 容器是否健康：`sudo docker compose ps`
2. `application-docker.properties` 中的连接地址是否为 `postgres:5432`
3. 密码是否正确匹配 `.env` 文件

### Q3: AI 聊天功能无法使用

A: 确保：
1. `DASHSCOPE_API_KEY` 已正确设置
2. MongoDB 已正常启动
3. PgVector 扩展已安装（使用 `pgvector/pgvector:pg16` 镜像已自带）

### Q4: 上传文件失败

A: 检查：
1. MinIO 容器是否正常运行
2. 默认 bucket `default` 是否已创建
3. Nginx 的 `client_max_body_size` 是否足够大（已在 docker-compose 中通过 `spring.servlet.multipart.max-file-size` 配置）

### Q5: 内存不足导致构建失败

A: 如果服务器内存较小（< 2GB），建议增加 Swap：

```bash
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

或在 Maven 构建时限制内存：修改 backend Dockerfile 中的 `JAVA_OPTS` 和 Maven 参数。

---

## 十、安全建议

1. **修改默认密码**：所有 `.env` 中的默认密码都应在生产环境中修改
2. **关闭 Swagger**：生产环境建议设置 `springdoc.api-docs.enabled=false`
3. **配置防火墙**：仅开放 80/443 端口，数据库端口建议不暴露到公网（删除 docker-compose 中的 ports 映射或配置安全组）
4. **定期备份**：设置定时任务自动备份数据库
5. **启用 HTTPS**：生产环境必须使用 HTTPS
6. **JWT 密钥**：定期更换 `JWT_SECRET` 和 `JWT_SALT`

---

## 附录：一键部署脚本

创建 `~/yoyuen-knowledge/deploy.sh`：

```bash
#!/bin/bash
set -e

echo "=== YoyuEN-Knowledge Docker 部署脚本 ==="

# 加载环境变量
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo "[OK] 环境变量加载完成"
else
    echo "[ERROR] .env 文件不存在"
    exit 1
fi

# 构建并启动
echo "[INFO] 开始构建 Docker 镜像..."
sudo docker compose up -d --build

echo "[INFO] 等待服务启动..."
sleep 10

# 初始化 MinIO bucket
echo "[INFO] 初始化 MinIO..."
sudo docker compose exec -T minio mc alias set local http://localhost:9000 ${MINIO_ROOT_USER:-minioadmin} ${MINIO_ROOT_PASSWORD:-minioadmin} || true
sudo docker compose exec -T minio mc mb local/default --ignore-existing || true
sudo docker compose exec -T minio mc anonymous set download local/default || true

echo "[OK] 部署完成！"
echo "访问地址: http://$(curl -s ifconfig.me)"
echo "Swagger: http://$(curl -s ifconfig.me)/api/doc.html"
echo ""
echo "查看日志: sudo docker compose logs -f backend"
```

赋予执行权限：

```bash
chmod +x ~/yoyuen-knowledge/deploy.sh
~/yoyuen-knowledge/deploy.sh
```
