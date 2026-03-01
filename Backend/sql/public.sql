-- 基础字段说明
-- create_time TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
-- update_time TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
-- deleted     BOOLEAN               DEFAULT FALSE,
-- creator     VARCHAR(255),
-- updater     VARCHAR(255)

-- 创建数据库
-- CREATE DATABASE "know-ai";

-- 创建向量扩展
CREATE EXTENSION IF NOT EXISTS vector;

-- 创建系统用户表
CREATE TABLE "system_user" (
                               id          BIGSERIAL PRIMARY KEY,
                               username    VARCHAR(255) NOT NULL,
                               password    VARCHAR(255) NOT NULL,
                               create_time TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               update_time TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               deleted     BOOLEAN               DEFAULT FALSE,
                               creator     VARCHAR(255),
                               updater     VARCHAR(255)
);

COMMENT ON TABLE "system_user" IS '系统用户表';
COMMENT ON COLUMN "system_user".id IS '用户id';
COMMENT ON COLUMN "system_user".username IS '用户名';
COMMENT ON COLUMN "system_user".password IS '密码';
COMMENT ON COLUMN "system_user".create_time IS '创建时间';
COMMENT ON COLUMN "system_user".update_time IS '更新时间';
COMMENT ON COLUMN "system_user".deleted IS '是否删除（false-未删除，true-已删除）';
COMMENT ON COLUMN "system_user".creator IS '创建人';
COMMENT ON COLUMN "system_user".updater IS '更新人';

-- 创建系统角色表
CREATE TABLE "system_role" (
                               id          BIGSERIAL PRIMARY KEY,
                               name        VARCHAR(255) NOT NULL,
                               description VARCHAR(500),
                               create_time TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               update_time TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               deleted     BOOLEAN               DEFAULT FALSE,
                               creator     VARCHAR(255),
                               updater     VARCHAR(255)
);

COMMENT ON TABLE "system_role" IS '系统角色表';
COMMENT ON COLUMN "system_role".id IS '角色id';
COMMENT ON COLUMN "system_role".name IS '角色名';
COMMENT ON COLUMN "system_role".description IS '角色描述';
COMMENT ON COLUMN "system_role".create_time IS '创建时间';
COMMENT ON COLUMN "system_role".update_time IS '更新时间';
COMMENT ON COLUMN "system_role".deleted IS '是否删除（false-未删除，true-已删除）';
COMMENT ON COLUMN "system_role".creator IS '创建人';
COMMENT ON COLUMN "system_role".updater IS '更新人';

-- 创建系统权限表
CREATE TABLE "system_permission" (
                                     id          BIGSERIAL PRIMARY KEY,
                                     name        VARCHAR(255) NOT NULL,
                                     description VARCHAR(500),
                                     create_time TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     update_time TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     deleted     BOOLEAN               DEFAULT FALSE,
                                     creator     VARCHAR(255),
                                     updater     VARCHAR(255)
);

COMMENT ON TABLE "system_permission" IS '系统权限表';
COMMENT ON COLUMN "system_permission".id IS '权限ID';
COMMENT ON COLUMN "system_permission".name IS '权限名称';
COMMENT ON COLUMN "system_permission".description IS '权限描述';
COMMENT ON COLUMN "system_permission".create_time IS '创建时间';
COMMENT ON COLUMN "system_permission".update_time IS '更新时间';
COMMENT ON COLUMN "system_permission".deleted IS '是否删除（false-未删除，true-已删除）';
COMMENT ON COLUMN "system_permission".creator IS '创建人';
COMMENT ON COLUMN "system_permission".updater IS '更新人';

-- 创建用户-角色关联表
CREATE TABLE "system_user_role" (
                                    id          BIGSERIAL PRIMARY KEY,
                                    user_id     BIGINT    NOT NULL REFERENCES "system_user"(id),
                                    role_id     BIGINT    NOT NULL REFERENCES "system_role"(id),
                                    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    deleted     BOOLEAN   DEFAULT FALSE,
                                    creator     VARCHAR(255),
                                    updater     VARCHAR(255)
);

COMMENT ON TABLE "system_user_role" IS '用户-角色关联表';
COMMENT ON COLUMN "system_user_role".user_id IS '用户ID';
COMMENT ON COLUMN "system_user_role".role_id IS '角色ID';
COMMENT ON COLUMN "system_user_role".create_time IS '创建时间';
COMMENT ON COLUMN "system_user_role".creator IS '创建人';

-- 创建角色-权限关联表
CREATE TABLE "system_role_permission" (
                                          id            BIGSERIAL PRIMARY KEY,
                                          role_id       BIGINT    NOT NULL REFERENCES "system_role"(id),
                                          permission_id BIGINT    NOT NULL REFERENCES "system_permission"(id),
                                          create_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          update_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          deleted       BOOLEAN   DEFAULT FALSE,
                                          creator       VARCHAR(255),
                                          updater       VARCHAR(255)
);

COMMENT ON TABLE "system_role_permission" IS '角色-权限关联表';
COMMENT ON COLUMN "system_role_permission".role_id IS '角色ID';
COMMENT ON COLUMN "system_role_permission".permission_id IS '权限ID';
COMMENT ON COLUMN "system_role_permission".create_time IS '创建时间';
COMMENT ON COLUMN "system_role_permission".creator IS '创建人';

-- 创建原始文件资源表
CREATE TABLE "origin_file_source" (
                                      id            TEXT PRIMARY KEY,                          -- 文件唯一标识
                                      file_name     TEXT    NOT NULL,                          -- 文件名
                                      path          TEXT    NOT NULL,                          -- 文件存储路径
                                      is_image      BOOLEAN NOT NULL,                          -- 是否为图片文件
                                      bucket_name   TEXT    NOT NULL,                          -- 对象存储桶名称
                                      object_name   TEXT    NOT NULL,                          -- 对象存储中的文件名
                                      content_type  TEXT    NOT NULL,                          -- 文件的 MIME 类型
                                      size          BIGINT  NOT NULL,                          -- 文件大小（字节）
                                      md5           TEXT    NOT NULL,                          -- 文件 MD5 哈希值
                                      images        TEXT    NOT NULL DEFAULT '[]',             -- 文档内包含的图片列表（JSON 数组）
                                      create_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      update_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      deleted       BOOLEAN   DEFAULT FALSE,
                                      creator       VARCHAR(255),
                                      updater       VARCHAR(255)
);

COMMENT ON TABLE "origin_file_source" IS '存储原始文件资源的表';
COMMENT ON COLUMN "origin_file_source".id IS '文件唯一标识';
COMMENT ON COLUMN "origin_file_source".file_name IS '文件名';
COMMENT ON COLUMN "origin_file_source".path IS '文件存储路径';
COMMENT ON COLUMN "origin_file_source".is_image IS '是否为图片文件';
COMMENT ON COLUMN "origin_file_source".bucket_name IS '对象存储桶名称';
COMMENT ON COLUMN "origin_file_source".object_name IS '对象存储中的文件名';
COMMENT ON COLUMN "origin_file_source".content_type IS '文件的 MIME 类型';
COMMENT ON COLUMN "origin_file_source".size IS '文件大小（字节）';
COMMENT ON COLUMN "origin_file_source".md5 IS '文件 MD5 哈希值';
COMMENT ON COLUMN "origin_file_source".images IS '文档内包含的图片列表（JSON 数组）';
COMMENT ON COLUMN "origin_file_source".create_time IS '记录创建时间';
COMMENT ON COLUMN "origin_file_source".update_time IS '记录更新时间';
COMMENT ON COLUMN "origin_file_source".deleted IS '是否被逻辑删除（软删除）';

-- 创建聊天消息表
CREATE TABLE "chat_message" (
                                id               TEXT PRIMARY KEY,                          -- 信息ID，唯一标识
                                conversation_id  TEXT    NOT NULL,                          -- 对话ID
                                message_no       INT     NOT NULL,                          -- 对话序号
                                has_media        BOOLEAN NOT NULL,                          -- 是否携带附件
                                content          TEXT    NOT NULL,                          -- 对话内容
                                role             TEXT    NOT NULL,                          -- 角色
                                resource_ids     TEXT    NOT NULL DEFAULT '[]',             -- 附件列表
                                is_clean         BOOLEAN DEFAULT FALSE,
                                create_time      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                update_time      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                deleted          BOOLEAN   DEFAULT FALSE,
                                creator          VARCHAR(255),
                                updater          VARCHAR(255)
);

COMMENT ON TABLE "chat_message" IS '对话消息';
COMMENT ON COLUMN "chat_message".id IS '信息ID，唯一标识';
COMMENT ON COLUMN "chat_message".conversation_id IS '对话ID';
COMMENT ON COLUMN "chat_message".message_no IS '消息序列号';
COMMENT ON COLUMN "chat_message".has_media IS '是否携带附件';
COMMENT ON COLUMN "chat_message".content IS '内容';
COMMENT ON COLUMN "chat_message".role IS '角色';
COMMENT ON COLUMN "chat_message".resource_ids IS '资源ID';
COMMENT ON COLUMN "chat_message".create_time IS '记录创建时间';
COMMENT ON COLUMN "chat_message".update_time IS '记录更新时间';
COMMENT ON COLUMN "chat_message".deleted IS '是否被逻辑删除（软删除）';

-- 创建聊天会话表
CREATE TABLE "chat_conversation" (
                                     id             TEXT PRIMARY KEY,                     -- 对话ID
                                     title          TEXT   NOT NULL,                      -- 标题
                                     user_id        BIGINT NOT NULL REFERENCES "system_user"(id), -- 发起人
                                     create_time    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     update_time    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     deleted        BOOLEAN   DEFAULT FALSE,
                                     creator        VARCHAR(255),
                                     updater        VARCHAR(255)
);

COMMENT ON TABLE "chat_conversation" IS '对话会话';
COMMENT ON COLUMN "chat_conversation".id IS '会话ID，唯一标识';
COMMENT ON COLUMN "chat_conversation".title IS '会话标题';
COMMENT ON COLUMN "chat_conversation".user_id IS '用户ID';
COMMENT ON COLUMN "chat_conversation".create_time IS '记录创建时间';
COMMENT ON COLUMN "chat_conversation".update_time IS '记录更新时间';
COMMENT ON COLUMN "chat_conversation".deleted IS '是否被逻辑删除（软删除）';

-- 创建知识库表
CREATE TABLE "knowledge_base" (
                                  id            varchar(32) PRIMARY KEY NOT NULL,
                                  name          varchar(100) NOT NULL,
                                  description   TEXT,
                                  create_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  update_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  deleted       BOOLEAN   DEFAULT FALSE,
                                  creator       VARCHAR(255),
                                  updater       VARCHAR(255)
);

-- 创建文档实体表
CREATE TABLE "document_entity" (
                                   id             BIGSERIAL PRIMARY KEY,
                                   file_name      VARCHAR(512) NOT NULL,
                                   path           TEXT NOT NULL,
                                   base_id        varchar(32) NOT NULL REFERENCES "knowledge_base"(id),
                                   is_embedding   BOOLEAN DEFAULT FALSE,
                                   resource_id    varchar(64) NOT NULL,
                                   create_time    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   update_time    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   deleted        BOOLEAN   DEFAULT FALSE,
                                   creator        VARCHAR(255),
                                   updater        VARCHAR(255)
);

-- 创建索引
CREATE INDEX "idx_chat_message_conversation_id" ON "chat_message"(conversation_id);
CREATE INDEX "idx_chat_conversation_user_id" ON "chat_conversation"(user_id);
CREATE INDEX "idx_document_entity_base_id" ON "document_entity"(base_id);
CREATE INDEX "idx_origin_file_source_md5" ON "origin_file_source"(md5);

-- 更新时间自动触发函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.update_time = now();
RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- 为所有表添加自动更新时间触发器
CREATE TRIGGER "update_system_user_updated_at"
    BEFORE UPDATE ON "system_user"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_system_role_updated_at"
    BEFORE UPDATE ON "system_role"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_system_permission_updated_at"
    BEFORE UPDATE ON "system_permission"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_system_user_role_updated_at"
    BEFORE UPDATE ON "system_user_role"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_system_role_permission_updated_at"
    BEFORE UPDATE ON "system_role_permission"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_origin_file_source_updated_at"
    BEFORE UPDATE ON "origin_file_source"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_chat_message_updated_at"
    BEFORE UPDATE ON "chat_message"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_chat_conversation_updated_at"
    BEFORE UPDATE ON "chat_conversation"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_knowledge_base_updated_at"
    BEFORE UPDATE ON "knowledge_base"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_document_entity_updated_at"
    BEFORE UPDATE ON "document_entity"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================
-- 内容表 (文章/游戏/学习/视频)
-- ================================
CREATE TABLE "content" (
                           id            VARCHAR(32) PRIMARY KEY NOT NULL,
                           title         VARCHAR(255) NOT NULL,
                           description   TEXT,
                           category      VARCHAR(50) NOT NULL,
                           cover         TEXT,
                           content       TEXT,
                           comment_count INT DEFAULT 0,
                           view_count    INT DEFAULT 0,
                           is_recommend  BOOLEAN DEFAULT FALSE,
                           create_time   TIMESTAMP NOT NULL DEFAULT
                                                         CURRENT_TIMESTAMP,
                           update_time   TIMESTAMP NOT NULL DEFAULT
                                                         CURRENT_TIMESTAMP,
                           deleted       BOOLEAN DEFAULT FALSE,
                           creator       VARCHAR(255),
                           updater       VARCHAR(255)
);

COMMENT ON TABLE "content" IS '内容表（文章/游戏/学习/视频）';
COMMENT ON COLUMN "content".id IS '内容ID';
COMMENT ON COLUMN "content".title IS '标题';
COMMENT ON COLUMN "content".description IS '简介/描述';
COMMENT ON COLUMN "content".category IS '分
类（article-文章, game-游戏, study-学习, video-视频）';
COMMENT ON COLUMN "content".cover IS '封面图片URL';
COMMENT ON COLUMN "content".content IS '正文内容（HTML格式）';
COMMENT ON COLUMN "content".comment_count IS
    '评论数';
COMMENT ON COLUMN "content".view_count IS ' 浏览量';
COMMENT ON COLUMN "content".is_recommend IS '是否推荐';
COMMENT ON COLUMN "content".create_time IS '创建时间';
COMMENT ON COLUMN "content".update_time IS '更新时间';
COMMENT ON COLUMN "content".deleted IS '是否删除';
COMMENT ON COLUMN "content".creator IS '创建人';
COMMENT ON COLUMN "content".updater IS '更新人';

-- ================================
-- 碎碎念表
-- ================================
CREATE TABLE "murmur" (
                          id          VARCHAR(32) PRIMARY KEY NOT NULL,
                          text        TEXT NOT NULL,
                          create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          deleted     BOOLEAN DEFAULT FALSE,
                          creator     VARCHAR(255),
                          updater     VARCHAR(255)
);

COMMENT ON TABLE "murmur" IS '碎碎念/动态表';
COMMENT ON COLUMN "murmur".id IS '碎碎念ID';
COMMENT ON COLUMN "murmur".text IS '碎碎念内容';
COMMENT ON COLUMN "murmur".create_time IS ' 创建时间';
COMMENT ON COLUMN "murmur".update_time IS ' 更新时间';
COMMENT ON COLUMN "murmur".deleted IS '是否 删除';
COMMENT ON COLUMN "murmur".creator IS '创建 人';
COMMENT ON COLUMN "murmur".updater IS '更新 人';

-- ================================
-- 评论表
-- ================================
CREATE TABLE "comment" (
                           id           VARCHAR(32) PRIMARY KEY NOT
                                                                    NULL,
                           content_id   VARCHAR(32) NOT NULL,
                           content_type VARCHAR(50) NOT NULL,
                           avatar       TEXT,
                           author       VARCHAR(255),
                           user_id      VARCHAR(255),
                           content      TEXT NOT NULL,
                           parent_id    VARCHAR(32),
                           is_recommend BOOLEAN DEFAULT FALSE,
                           create_time  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           update_time  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           deleted      BOOLEAN DEFAULT FALSE,
                           creator      VARCHAR(255),
                           updater      VARCHAR(255)
);

COMMENT ON TABLE "comment" IS '评论表';
COMMENT ON COLUMN "comment".id IS '评论ID';
COMMENT ON COLUMN "comment".content_id IS ' 关联内容ID';
COMMENT ON COLUMN "comment".content_type IS '内容类型（article/game/study/video）';
COMMENT ON COLUMN "comment".avatar IS '评论 者头像';
COMMENT ON COLUMN "comment".author IS '评论 者昵称';
COMMENT ON COLUMN "comment".user_id IS '评论者用户ID';
COMMENT ON COLUMN "comment".content IS '评论内容';
COMMENT ON COLUMN "comment".parent_id IS '父评论ID（用于回复，顶级评论为NULL）';
COMMENT ON COLUMN "comment".create_time IS '创建时间';
COMMENT ON COLUMN "comment".update_time IS '更新时间';
COMMENT ON COLUMN "comment".deleted IS '是否删除';
COMMENT ON COLUMN "comment".creator IS '创建人';
COMMENT ON COLUMN "comment".updater IS '更新人';

-- ================================
-- 创建索引
-- ================================
CREATE INDEX "idx_content_category" ON "content"(category);
CREATE INDEX "idx_content_is_recommend" ON "content"(is_recommend);
CREATE INDEX "idx_murmur_create_time" ON "murmur"(create_time DESC);
CREATE INDEX "idx_comment_content" ON "comment"(content_id, content_type);
CREATE INDEX "idx_comment_parent" ON "comment"(parent_id);

-- ================================
-- 创建更新时间触发器
-- ================================
CREATE TRIGGER "update_content_updated_at"
    BEFORE UPDATE ON "content"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_murmur_updated_at"
    BEFORE UPDATE ON "murmur"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_comment_updated_at"
    BEFORE UPDATE ON "comment"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================
-- 照片表
-- ================================
CREATE TABLE "photo" (
                         id          VARCHAR(32) PRIMARY KEY NOT NULL,
                         bucket_name VARCHAR(100) NOT NULL,
                         object_name TEXT NOT NULL,
                         description TEXT,
                         create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         deleted     BOOLEAN DEFAULT FALSE,
                         creator     VARCHAR(255),
                         updater     VARCHAR(255)
);

COMMENT ON TABLE "photo" IS '照片表';
COMMENT ON COLUMN "photo".id IS '照片ID';
COMMENT ON COLUMN "photo".bucket_name IS 'MinIO存储桶名称';
COMMENT ON COLUMN "photo".object_name IS 'MinIO对象名称';
COMMENT ON COLUMN "photo".description IS '照片描述';
COMMENT ON COLUMN "photo".create_time IS '创建时间';
COMMENT ON COLUMN "photo".update_time IS '更新时间';
COMMENT ON COLUMN "photo".deleted IS '是否删除';

CREATE TRIGGER "update_photo_updated_at"
    BEFORE UPDATE ON "photo"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX "idx_photo_create_time" ON "photo"(create_time DESC);

ALTER TABLE "comment" ADD COLUMN is_recommend BOOLEAN DEFAULT FALSE;