-- ============================================
-- 标签系统数据库表创建脚本
-- 数据库: PostgreSQL
-- 执行方式: psql -U postgres -d know-ai -f create_tag_tables.sql
-- ============================================

-- 1. 创建内容标签表
CREATE TABLE IF NOT EXISTS content_tag (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    usage_count BIGINT DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    creator VARCHAR(50),
    updater VARCHAR(50),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 2. 创建内容标签关联表
CREATE TABLE IF NOT EXISTS content_tag_relation (
    id BIGSERIAL PRIMARY KEY,
    content_id VARCHAR(50) NOT NULL,
    tag_id BIGINT NOT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_content FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE,
    CONSTRAINT fk_tag FOREIGN KEY (tag_id) REFERENCES content_tag(id) ON DELETE CASCADE,
    CONSTRAINT uk_content_tag UNIQUE (content_id, tag_id)
);

-- 3. 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_content_tag_name ON content_tag(name);
CREATE INDEX IF NOT EXISTS idx_content_tag_usage_count ON content_tag(usage_count DESC);
CREATE INDEX IF NOT EXISTS idx_content_tag_relation_content_id ON content_tag_relation(content_id);
CREATE INDEX IF NOT EXISTS idx_content_tag_relation_tag_id ON content_tag_relation(tag_id);

-- 4. 添加表和字段注释
COMMENT ON TABLE content_tag IS '内容标签表';
COMMENT ON COLUMN content_tag.id IS '标签ID';
COMMENT ON COLUMN content_tag.name IS '标签名称';
COMMENT ON COLUMN content_tag.usage_count IS '使用次数（冗余字段，用于快速查询）';
COMMENT ON COLUMN content_tag.create_time IS '创建时间';
COMMENT ON COLUMN content_tag.update_time IS '更新时间';
COMMENT ON COLUMN content_tag.creator IS '创建者';
COMMENT ON COLUMN content_tag.updater IS '更新者';
COMMENT ON COLUMN content_tag.is_deleted IS '是否删除';

COMMENT ON TABLE content_tag_relation IS '内容标签关联表';
COMMENT ON COLUMN content_tag_relation.id IS '关联ID';
COMMENT ON COLUMN content_tag_relation.content_id IS '内容ID';
COMMENT ON COLUMN content_tag_relation.tag_id IS '标签ID';
COMMENT ON COLUMN content_tag_relation.create_time IS '创建时间';

-- 5. 插入一些示例标签（可选）
INSERT INTO content_tag (name, usage_count) VALUES
    ('Vue3', 0),
    ('TypeScript', 0),
    ('Java', 0),
    ('Spring Boot', 0),
    ('PostgreSQL', 0),
    ('Redis', 0),
    ('前端开发', 0),
    ('后端开发', 0),
    ('数据库', 0),
    ('AI', 0)
ON CONFLICT (name) DO NOTHING;

-- 6. 查看创建结果
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name IN ('content_tag', 'content_tag_relation')
ORDER BY table_name, ordinal_position;

-- 7. 查看索引
SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename IN ('content_tag', 'content_tag_relation')
ORDER BY tablename, indexname;

-- 完成提示
SELECT '标签表创建完成！' AS status;
