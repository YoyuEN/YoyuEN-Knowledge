# 用户头像功能实现指南

## 1. 数据库修改

执行 SQL 脚本添加头像字段：

```bash
psql -h localhost -U postgres -d know-ai -f Backend/add_avatar_column.sql
```

或者手动执行：

```sql
-- 添加头像字段
ALTER TABLE system_user ADD COLUMN IF NOT EXISTS avatar VARCHAR(500);

-- 为现有用户设置头像
UPDATE system_user
SET avatar = 'http://118.89.135.164:9000/default/avatars/YoyuEN.png'
WHERE username = 'YoyuEN';
```

## 2. 上传头像到 MinIO

### 方法一：使用 MinIO Web 控制台

1. 访问 MinIO 控制台：http://118.89.135.164:9000
2. 登录（用户名：minioadmin，密码：minioadmin）
3. 进入 `default` bucket
4. 创建 `avatars` 文件夹
5. 上传头像图片（如 YoyuEN.png）

### 方法二：使用 MinIO 客户端命令

```bash
# 安装 MinIO 客户端
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/

# 配置 MinIO 服务器
mc alias set myminio http://118.89.135.164:9000 minioadmin minioadmin

# 创建 avatars 目录并上传文件
mc mb myminio/default/avatars
mc cp /path/to/YoyuEN.png myminio/default/avatars/

# 设置公开访问权限
mc anonymous set download myminio/default/avatars
```

### 方法三：使用 curl 上传

```bash
# 上传文件到 MinIO
curl -X PUT \
  -H "Host: 118.89.135.164:9000" \
  -H "Content-Type: image/png" \
  --user "minioadmin:minioadmin" \
  --data-binary "@/path/to/YoyuEN.png" \
  "http://118.89.135.164:9000/default/avatars/YoyuEN.png"
```

## 3. 头像 URL 格式

上传后的头像 URL 格式：
```
http://118.89.135.164:9000/default/avatars/YoyuEN.png
```

## 4. 后端修改（已完成）

- ✅ SystemUser 实体添加 avatar 字段
- ✅ LoginResponse 添加 avatar 字段
- ✅ AuthController 返回用户头像
- ✅ SystemUserMapper.xml 查询头像字段

## 5. 前端修改（已完成）

- ✅ AdminLayout 组件获取并显示用户头像
- ✅ 头像加载失败时显示用户名首字母

## 6. 测试步骤

1. 执行数据库脚本添加 avatar 字段
2. 上传头像到 MinIO
3. 更新数据库中的 avatar URL
4. 重启后端服务
5. 清除浏览器缓存：`localStorage.clear()`
6. 重新登录
7. 查看右上角是否显示真实头像

## 7. 注意事项

- 头像文件建议大小：< 500KB
- 支持格式：jpg, jpeg, png, gif
- 建议尺寸：200x200 像素
- MinIO bucket 需要设置公开读取权限
- 头像 URL 存储在数据库中，实际文件存储在 MinIO
