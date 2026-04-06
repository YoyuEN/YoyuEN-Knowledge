# 标签系统数据库迁移指南

## 概述

将标签数据从 Redis 迁移到 PostgreSQL 数据库，使用数据库作为主存储，Redis 作为缓存。

## 改造内容

### 1. 新增实体类
- `ContentTag.java` - 标签实体
- `ContentTagRelation.java` - 内容与标签关联关系实体

### 2. 新增 Mapper
- `ContentTagMapper.java` - 标签数据访问层
- `ContentTagRelationMapper.java` - 关联关系数据访问层

### 3. 新增 Service
- `ContentTagService.java` - 标签服务接口
- `ContentTagServiceImpl.java` - 标签服务实现

### 4. 修改 Controller
- `ContentController.java` - 修改标签相关方法使用数据库
- `MigrationController.java` - 新增数据迁移接口

### 5. 数据库脚本
- `V1__create_content_tag_tables.sql` - 创建标签表和关联表

## 迁移步骤

### 步骤 1: 执行数据库脚本

```bash
# 连接到 PostgreSQL 数据库
psql -U postgres -d know-ai

# 执行建表脚本
\i Backend/src/main/resources/db/migration/V1__create_content_tag_tables.sql
```

或者让 JPA 自动创建表（application.properties 中 `spring.jpa.hibernate.ddl-auto=update`）

### 步骤 2: 启动应用

```bash
cd Backend
mvn spring-boot:run
```

### 步骤 3: 执行数据迁移

调用迁移接口将 Redis 中的标签数据迁移到数据库：

```bash
# 迁移标签数据
curl -X POST http://localhost:12138/api/admin/migration/tags

# 返回示例：
{
  "code": 0,
  "data": {
    "totalTags": 15,
    "createdTags": 15,
    "existingTags": 0,
    "totalContent": 50,
    "contentWithTags": 45,
    "totalRelations": 120,
    "message": "标签迁移完成"
  },
  "message": "success"
}
```

### 步骤 4: 验证迁移结果

```bash
# 查看标签列表
curl http://localhost:12138/api/content/tags

# 查看某篇文章的详情（包含标签）
curl http://localhost:12138/api/content/{contentId}
```

### 步骤 5: 清理 Redis 旧数据（可选）

确认迁移成功后，可以清理 Redis 中的旧数据：

```bash
# 清理 Redis 标签数据
curl -X POST http://localhost:12138/api/admin/migration/tags/cleanup
```

或手动清理：

```bash
redis-cli -h localhost -p 6379 -a 242431
> DEL content:tag:all
> KEYS content:tags:*
> DEL content:tags:xxx  # 逐个删除或使用脚本批量删除
```

## 数据库表结构

### content_tag 表
```sql
id              BIGSERIAL PRIMARY KEY
name            VARCHAR(50) NOT NULL UNIQUE  -- 标签名称
usage_count     BIGINT DEFAULT 0             -- 使用次数
create_time     TIMESTAMP
update_time     TIMESTAMP
creator         VARCHAR(50)
updater         VARCHAR(50)
is_deleted      BOOLEAN DEFAULT FALSE
```

### content_tag_relation 表
```sql
id              BIGSERIAL PRIMARY KEY
content_id      VARCHAR(50) NOT NULL         -- 内容ID
tag_id          BIGINT NOT NULL              -- 标签ID
create_time     TIMESTAMP
```

## 新功能特性

### 1. 数据持久化
- 标签数据存储在数据库中，不会因 Redis 重启而丢失
- 支持事务，保证数据一致性

### 2. 缓存机制
- 标签列表缓存 10 分钟
- 单个标签缓存 30 分钟
- 文章标签关联缓存 30 分钟
- 修改操作自动清除相关缓存

### 3. 自动维护
- 创建文章时自动创建不存在的标签
- 删除文章时自动删除标签关联
- 自动更新标签使用次数

### 4. 数据完整性
- 外键约束确保数据一致性
- 唯一约束防止重复标签
- 级联删除自动清理关联数据

## API 变化

### 标签管理 API（无变化）
- `GET /api/content/tags` - 获取所有标签
- `POST /api/content/tag/create` - 创建标签
- `POST /api/content/tag/update` - 更新标签
- `POST /api/content/tag/remove` - 删除标签

### 内容管理 API（无变化）
- `POST /api/content/create` - 创建内容（自动处理标签）
- `POST /api/content/update` - 更新内容（自动处理标签）
- `POST /api/content/remove` - 删除内容（自动删除标签关联）

### 新增迁移 API
- `POST /api/admin/migration/tags` - 迁移标签数据
- `POST /api/admin/migration/tags/cleanup` - 清理 Redis 旧数据

## 注意事项

1. **迁移前备份**
   - 备份 Redis 数据：`redis-cli --rdb /backup/dump.rdb`
   - 备份数据库：`pg_dump know-ai > backup.sql`

2. **迁移时机**
   - 建议在低峰期执行迁移
   - 迁移过程中标签功能正常可用

3. **回滚方案**
   - 如果迁移失败，可以回滚代码到旧版本
   - Redis 数据不会被自动删除，可以继续使用

4. **性能优化**
   - 已添加数据库索引优化查询性能
   - 使用 Redis 缓存减少数据库访问
   - 批量操作使用事务提高效率

## 故障排查

### 问题 1: 标签不显示
- 检查数据库表是否创建成功
- 检查是否执行了数据迁移
- 查看应用日志是否有错误

### 问题 2: 迁移失败
- 检查数据库连接是否正常
- 检查 Redis 连接是否正常
- 查看迁移接口返回的错误信息

### 问题 3: 性能问题
- 检查数据库索引是否创建
- 检查 Redis 缓存是否生效
- 考虑增加数据库连接池大小

## 后续优化建议

1. **标签推荐**
   - 基于使用频率推荐热门标签
   - 基于文章内容智能推荐标签

2. **标签管理**
   - 支持标签合并
   - 支持标签别名
   - 支持标签分类

3. **性能优化**
   - 实现标签的全文搜索
   - 优化标签统计查询
   - 实现标签云展示
