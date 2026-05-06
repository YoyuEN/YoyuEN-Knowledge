# 阿里云 Docker 部署指南

> 项目：YoyuEN-Knowledge（Spring Boot 3.3.5 + Vue3/Vite + PostgreSQL/pgvector + Redis + MinIO）
> 目标：阿里云 ECS（Ubuntu 22.04 / CentOS 7+，建议 4C8G + 50G 系统盘 + 100G 数据盘）

---

## 一、阿里云服务器准备

### 1. ECS 实例与安全组
- 购买一台 ECS（Ubuntu 22.04 LTS，4C8G，公网带宽 ≥ 5Mbps）
- **安全组**放行端口（仅放必要的）：
  - `22` SSH
  - `80` / `443` Nginx（前端 + 反向代理后端）
  - `9000` / `9001` MinIO（生产建议只开 9001 控制台给特定 IP，9000 通过 nginx 代理）
  - 其余端口（5432/6379/12138）**不要**对公网开放，仅 docker 内部互通

### 2. 安装 Docker & Docker Compose

```bash
# Ubuntu 22.04
sudo apt update && sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

# 配置阿里云镜像加速（替换为你自己控制台 → 容器镜像服务 → 镜像加速器 的地址）
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<'EOF'
{
  "registry-mirrors": ["https://<your-id>.mirror.aliyuncs.com"]
}
EOF
sudo systemctl restart docker
docker --version && docker compose version
```

### 3. 项目目录结构（服务器上）
```
~/yoyuen-knowledge/
├── docker-compose.yml
├── .env                    # 所有密钥 / 密码
├── nginx/
│   ├── conf.d/default.conf
│   └── certs/              # https 证书（可选）
├── backend/
│   ├── Dockerfile
│   └── Backend-0.0.1-SNAPSHOT.jar
├── fronted/
│   ├── Dockerfile
│   └── dist/               # vite build 产物
└── data/                   # 持久化卷挂载点
    ├── pg/
    ├── redis/
    └── minio/
```

---

## 二、改造代码（关键：把硬编码改成环境变量）

### 1. 后端 `application.properties` 改造
当前 [Backend/src/main/resources/application.properties](Backend/src/main/resources/application.properties) 里数据库、Redis、MinIO 全是 `localhost` 和明文密码，必须改成可被环境变量覆盖：

```properties
# postgres
spring.datasource.url=jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:know-ai}
spring.datasource.username=${DB_USER:postgres}
spring.datasource.password=${DB_PASSWORD:242431}

# Redis
spring.data.redis.host=${REDIS_HOST:localhost}
spring.data.redis.port=${REDIS_PORT:6379}
spring.data.redis.password=${REDIS_PASSWORD:}

# MinIO
minio.endpoint=${MINIO_ENDPOINT:http://118.89.135.164:9000}
minio.access-key=${MINIO_ACCESS_KEY:minioadmin}
minio.secret-key=${MINIO_SECRET_KEY:minioadmin}
minio.bucket-name=${MINIO_BUCKET:default}

# Volcengine ARK key 也建议挪到环境变量
volcengine.ark.api-key=${VOLCENGINE_ARK_API_KEY}
```

### 2. 本地打包
```bash
# 后端（项目根 Backend 目录）
./mvnw clean package -DskipTests
# 产物：Backend/target/Backend-0.0.1-SNAPSHOT.jar

# 前端
cd Fronted
npm install
npm run build
# 产物：Fronted/dist/
```

---

## 三、Dockerfile

### 1. 后端 `backend/Dockerfile`
```dockerfile
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY Backend-0.0.1-SNAPSHOT.jar app.jar
ENV TZ=Asia/Shanghai \
    JAVA_OPTS="-Xms512m -Xmx2g -Dfile.encoding=UTF-8"
EXPOSE 12138
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar app.jar"]
```

### 2. 前端 `frontend/Dockerfile`（用 nginx 直接出静态资源）
```dockerfile
FROM nginx:1.27-alpine
COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

`frontend/nginx.conf`：

```nginx
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 反代后端 API（前端 axios baseURL = /api）
    location /api/ {
        proxy_pass http://backend:12138/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_read_timeout 300s;
        # SSE/流式输出
        proxy_buffering off;
        proxy_cache off;
        chunked_transfer_encoding on;
    }

    # MinIO 资源
    location /minio/ {
        proxy_pass http://118.89.135.164:9000/;
        proxy_set_header Host $host;
    }

    client_max_body_size 600M;
}
```

---

## 四、`docker-compose.yml`（完整编排）

`~/yoyuen-knowledge/docker-compose.yml`：
```yaml
services:
  postgres:
    image: pgvector/pgvector:pg16
    container_name: yoyuen-pg
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      TZ: Asia/Shanghai
    volumes:
      - ./data/pg:/var/lib/postgresql/data
      - ./Backend/sql:/docker-entrypoint-initdb.d:ro   # 首次启动自动执行 SQL
    networks: [yoyuen-net]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 10

  redis:
    image: redis:7-alpine
    container_name: yoyuen-redis
    restart: unless-stopped
    command: ["redis-server", "--requirepass", "${REDIS_PASSWORD}", "--appendonly", "yes"]
    volumes:
      - ./data/redis:/data
    networks: [yoyuen-net]

  minio:
    image: minio/minio:latest
    container_name: yoyuen-minio
    restart: unless-stopped
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: ${MINIO_ACCESS_KEY}
      MINIO_ROOT_PASSWORD: ${MINIO_SECRET_KEY}
    volumes:
      - ./data/minio:/data
    ports:
      - "9001:9001"          # 控制台（建议安全组限制 IP）
    networks: [yoyuen-net]

  backend:
    build: ./backend
    image: yoyuen-backend:latest
    container_name: yoyuen-backend
    restart: unless-stopped
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started
      minio:
        condition: service_started
    environment:
      DB_HOST: postgres
      DB_PORT: 5432
      DB_NAME: ${DB_NAME}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      REDIS_HOST: redis
      REDIS_PORT: 6379
      REDIS_PASSWORD: ${REDIS_PASSWORD}
      MINIO_ENDPOINT: http://118.89.135.164:9000
      MINIO_ACCESS_KEY: ${MINIO_ACCESS_KEY}
      MINIO_SECRET_KEY: ${MINIO_SECRET_KEY}
      MINIO_BUCKET: ${MINIO_BUCKET}
      DASHSCOPE_API_KEY: ${DASHSCOPE_API_KEY}
      VOLCENGINE_ACCESS_KEY: ${VOLCENGINE_ACCESS_KEY}
      VOLCENGINE_SECRET_KEY: ${VOLCENGINE_SECRET_KEY}
      VOLCENGINE_ARK_API_KEY: ${VOLCENGINE_ARK_API_KEY}
      TZ: Asia/Shanghai
    networks: [yoyuen-net]

  frontend:
    build: ./fronted
    image: yoyuen-fronted:latest
    container_name: yoyuen-fronted
    restart: unless-stopped
    depends_on: [backend]
    ports:
      - "80:80"
      # - "443:443"   # 启用 HTTPS 时再开
    networks: [yoyuen-net]

networks:
  yoyuen-net:
    driver: bridge
```

`~/yoyuen-knowledge/.env`（**严格保密、不要进 git**）：
```env
DB_NAME=know-ai
DB_USER=postgres
DB_PASSWORD=改成强密码

REDIS_PASSWORD=改成强密码

MINIO_ACCESS_KEY=改成强 AK
MINIO_SECRET_KEY=改成强 SK（≥8位）
MINIO_BUCKET=default

DASHSCOPE_API_KEY=sk-xxx
VOLCENGINE_ACCESS_KEY=xxx
VOLCENGINE_SECRET_KEY=xxx
VOLCENGINE_ARK_API_KEY=xxx
```

---

## 五、部署步骤

### 1. 上传文件到服务器
```bash
# 本地（项目根目录）
scp Backend/target/Backend-0.0.1-SNAPSHOT.jar root@<ECS-IP>:~/yoyuen-knowledge/backend/
scp -r Fronted/dist root@<ECS-IP>:~/yoyuen-knowledge/frontend/
scp -r Backend/sql root@<ECS-IP>:~/yoyuen-knowledge/Backend/
scp docker-compose.yml .env root@<ECS-IP>:~/yoyuen-knowledge/
# Dockerfile / nginx.conf 同样上传到对应子目录
```

### 2. 启动

```bash
ssh root@<ECS-IP>
cd ~/yoyuen-knowledge
docker compose build
docker compose up -d
docker compose ps
docker compose logs -f backend     # 看启动日志
```

### 3. 初始化 pgvector & MinIO bucket
```bash
# 进入 pg 启用 vector 扩展（若 sql 脚本里没写）
docker exec -it yoyuen-pg psql -U postgres -d know-ai -c "CREATE EXTENSION IF NOT EXISTS vector;"

# 创建 MinIO bucket（用 mc 客户端）
docker run --rm --network yoyuen-knowledge_yoyuen-net minio/mc \
  alias set local http://minio:9000 ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY} && \
docker run --rm --network yoyuen-knowledge_yoyuen-net minio/mc mb local/default || true
```

### 4. 验证
- 浏览器访问 `http://<ECS-IP>/` → 前端应正常加载
- `http://<ECS-IP>/api/doc.html` → Knife4j 接口文档
- `http://<ECS-IP>:9001` → MinIO 控制台

---

## 六、HTTPS（可选，备案后再做）

1. 域名解析 A 记录到 ECS 公网 IP
2. 用 certbot 申请证书或上传阿里云免费 SSL：
```bash
docker run --rm -v ~/yoyuen-knowledge/nginx/certs:/etc/letsencrypt \
  certbot/certbot certonly --standalone -d your.domain.com
```
3. 修改 `frontend/nginx.conf` 增加 443 server，挂载 `./nginx/certs:/etc/nginx/certs:ro`，重新 `docker compose up -d`

---

## 七、运维命令速查

```bash
# 重新部署后端（更新 jar 后）
docker compose build backend && docker compose up -d backend

# 查看日志
docker compose logs -f --tail=200 backend

# 备份数据库
docker exec yoyuen-pg pg_dump -U postgres know-ai | gzip > backup_$(date +%F).sql.gz

# 备份 MinIO
tar -czf minio_$(date +%F).tar.gz ./data/minio

# 完全重启
docker compose down && docker compose up -d
```

---

## 八、常见坑

| 现象 | 原因 / 解决 |
|---|---|
| 后端连不上 pg | compose 内 host 必须是 `postgres`（服务名），不是 `localhost` |
| 上传大视频 413 | 前端 nginx `client_max_body_size` 已设 600M；阿里云 SLB 也要调 |
| SSE 流式断流 | nginx `proxy_buffering off` 必须开（已配置） |
| MinIO 文件外链是 `minio:9000` | endpoint 在生成预签名时建议改成公网域名/IP，否则前端访问不到 |
| pgvector 扩展未启用 | 用 `pgvector/pgvector:pg16` 镜像 + 手动 `CREATE EXTENSION vector` |
| ARK / DashScope 调用失败 | `.env` 里的 key 是否正确传入；`docker exec backend env` 检查 |

---

## 九、CI/CD 进阶（可选）

后续可用 **GitHub Actions / 阿里云效**：
1. push → 自动 `mvn package` + `npm run build`
2. 构建镜像推送到**阿里云容器镜像服务 ACR**
3. ssh 到 ECS 执行 `docker compose pull && docker compose up -d`

至此部署完成。
