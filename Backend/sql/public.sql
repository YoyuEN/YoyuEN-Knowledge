/*
 Navicat Premium Data Transfer

 Source Server         : postgres
 Source Server Type    : PostgreSQL
 Source Server Version : 170005 (170005)
 Source Host           : localhost:5432
 Source Catalog        : know-ai
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 170005 (170005)
 File Encoding         : 65001

 Date: 25/02/2026 16:30:32
*/


-- ----------------------------
-- Type structure for ghstore
-- ----------------------------
DROP TYPE IF EXISTS "public"."ghstore";
CREATE TYPE "public"."ghstore" (
  INPUT = "public"."ghstore_in",
  OUTPUT = "public"."ghstore_out",
  INTERNALLENGTH = VARIABLE,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "public"."ghstore" OWNER TO "postgres";

-- ----------------------------
-- Type structure for halfvec
-- ----------------------------
DROP TYPE IF EXISTS "public"."halfvec";
CREATE TYPE "public"."halfvec" (
  INPUT = "public"."halfvec_in",
  OUTPUT = "public"."halfvec_out",
  RECEIVE = "public"."halfvec_recv",
  SEND = "public"."halfvec_send",
  TYPMOD_IN = "public"."halfvec_typmod_in",
  INTERNALLENGTH = VARIABLE,
  STORAGE = external,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "public"."halfvec" OWNER TO "postgres";

-- ----------------------------
-- Type structure for hstore
-- ----------------------------
DROP TYPE IF EXISTS "public"."hstore";
CREATE TYPE "public"."hstore" (
  INPUT = "public"."hstore_in",
  OUTPUT = "public"."hstore_out",
  RECEIVE = "public"."hstore_recv",
  SEND = "public"."hstore_send",
  INTERNALLENGTH = VARIABLE,
  STORAGE = extended,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "public"."hstore" OWNER TO "postgres";

-- ----------------------------
-- Type structure for sparsevec
-- ----------------------------
DROP TYPE IF EXISTS "public"."sparsevec";
CREATE TYPE "public"."sparsevec" (
  INPUT = "public"."sparsevec_in",
  OUTPUT = "public"."sparsevec_out",
  RECEIVE = "public"."sparsevec_recv",
  SEND = "public"."sparsevec_send",
  TYPMOD_IN = "public"."sparsevec_typmod_in",
  INTERNALLENGTH = VARIABLE,
  STORAGE = external,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "public"."sparsevec" OWNER TO "postgres";

-- ----------------------------
-- Type structure for vector
-- ----------------------------
DROP TYPE IF EXISTS "public"."vector";
CREATE TYPE "public"."vector" (
  INPUT = "public"."vector_in",
  OUTPUT = "public"."vector_out",
  RECEIVE = "public"."vector_recv",
  SEND = "public"."vector_send",
  TYPMOD_IN = "public"."vector_typmod_in",
  INTERNALLENGTH = VARIABLE,
  STORAGE = external,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "public"."vector" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for document_entity_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."document_entity_id_seq";
CREATE SEQUENCE "public"."document_entity_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for system_permission_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."system_permission_id_seq";
CREATE SEQUENCE "public"."system_permission_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for system_role_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."system_role_id_seq";
CREATE SEQUENCE "public"."system_role_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for system_role_permission_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."system_role_permission_id_seq";
CREATE SEQUENCE "public"."system_role_permission_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for system_user_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."system_user_id_seq";
CREATE SEQUENCE "public"."system_user_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for system_user_role_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."system_user_role_id_seq";
CREATE SEQUENCE "public"."system_user_role_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Table structure for chat_conversation
-- ----------------------------
DROP TABLE IF EXISTS "public"."chat_conversation";
CREATE TABLE "public"."chat_conversation" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "title" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" int8 NOT NULL,
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."chat_conversation"."id" IS '会话ID，唯一标识';
COMMENT ON COLUMN "public"."chat_conversation"."title" IS '会话标题';
COMMENT ON COLUMN "public"."chat_conversation"."user_id" IS '用户ID';
COMMENT ON COLUMN "public"."chat_conversation"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "public"."chat_conversation"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "public"."chat_conversation"."deleted" IS '是否被逻辑删除（软删除）';
COMMENT ON TABLE "public"."chat_conversation" IS '对话会话';

-- ----------------------------
-- Records of chat_conversation
-- ----------------------------
INSERT INTO "public"."chat_conversation" VALUES ('1', 'YoyuEN', 1, '2026-02-25 09:14:02.717323', '2026-02-25 09:14:02.717323', 'f', NULL, NULL);
INSERT INTO "public"."chat_conversation" VALUES ('2026547537487147009', '新会话', 1, '2026-02-25 14:39:19.090026', '2026-02-25 14:39:19.090026', 'f', NULL, NULL);
INSERT INTO "public"."chat_conversation" VALUES ('2026566360894312449', '你好！', 1, '2026-02-25 15:54:06.952301', '2026-02-25 15:54:06.952301', 'f', NULL, NULL);
INSERT INTO "public"."chat_conversation" VALUES ('2026573474320658434', '我的职业是？', 1, '2026-02-25 16:22:22.895619', '2026-02-25 16:22:22.895619', 'f', NULL, NULL);
INSERT INTO "public"."chat_conversation" VALUES ('2026573754282061826', '你好！', 1, '2026-02-25 16:23:29.599717', '2026-02-25 16:23:29.599717', 'f', NULL, NULL);

-- ----------------------------
-- Table structure for chat_message
-- ----------------------------
DROP TABLE IF EXISTS "public"."chat_message";
CREATE TABLE "public"."chat_message" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "conversation_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "message_no" int4 NOT NULL,
  "has_media" bool NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "role" text COLLATE "pg_catalog"."default" NOT NULL,
  "resource_ids" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '[]'::text,
  "is_clean" bool DEFAULT false,
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."chat_message"."id" IS '信息ID，唯一标识';
COMMENT ON COLUMN "public"."chat_message"."conversation_id" IS '对话ID';
COMMENT ON COLUMN "public"."chat_message"."message_no" IS '消息序列号';
COMMENT ON COLUMN "public"."chat_message"."has_media" IS '是否携带附件';
COMMENT ON COLUMN "public"."chat_message"."content" IS '内容';
COMMENT ON COLUMN "public"."chat_message"."role" IS '角色';
COMMENT ON COLUMN "public"."chat_message"."resource_ids" IS '资源ID';
COMMENT ON COLUMN "public"."chat_message"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "public"."chat_message"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "public"."chat_message"."deleted" IS '是否被逻辑删除（软删除）';
COMMENT ON TABLE "public"."chat_message" IS '对话消息';

-- ----------------------------
-- Records of chat_message
-- ----------------------------
INSERT INTO "public"."chat_message" VALUES ('2026227972664258561', '1', 1, 'f', '你好！', 'USER', '[]', 'f', '2026-02-24 17:29:28.8662', '2026-02-24 17:29:28.8662', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026227983535894529', '1', 2, 'f', '你好！很高兴见到你，有什么我可以帮忙的吗？😊', 'ASSISTANT', '[]', 'f', '2026-02-24 17:29:31.433134', '2026-02-24 17:29:31.433134', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026235841006571521', '1', 3, 'f', '你好！', 'USER', '[]', 'f', '2026-02-24 18:00:44.829691', '2026-02-24 18:00:44.829691', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026465748806533121', '1', 4, 'f', '你好！', 'USER', '[]', 'f', '2026-02-25 09:14:19.096601', '2026-02-25 09:14:19.096601', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026467619885621249', '1', 5, 'f', '你好！', 'USER', '[]', 'f', '2026-02-25 09:21:45.213934', '2026-02-25 09:21:45.213934', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026469570857668609', '1', 6, 'f', '你好！', 'USER', '[]', 'f', '2026-02-25 09:29:30.349724', '2026-02-25 09:29:30.349724', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026469580085137410', '1', 7, 'f', '你好！', 'ASSISTANT', '[]', 'f', '2026-02-25 09:29:32.531637', '2026-02-25 09:29:32.531637', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026471089380265985', '1', 8, 'f', '你好！我的职业是什么？', 'USER', '[]', 'f', '2026-02-25 09:35:32.390504', '2026-02-25 09:35:32.390504', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026471096267313153', '1', 9, 'f', '不知道。', 'ASSISTANT', '[]', 'f', '2026-02-25 09:35:34.018174', '2026-02-25 09:35:34.018174', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026482351292149762', '1', 10, 'f', '你好！我的职业是什么？', 'USER', '[]', 'f', '2026-02-25 10:20:17.432204', '2026-02-25 10:20:17.432204', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026482360246988801', '1', 11, 'f', '你是一个前端工作者。', 'ASSISTANT', '[]', 'f', '2026-02-25 10:20:19.571521', '2026-02-25 10:20:19.571521', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026501792889360385', '1', 12, 'f', '你好！我的职业是什么？', 'USER', '[]', 'f', '2026-02-25 11:37:32.689234', '2026-02-25 11:37:32.689234', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026501807221297153', '1', 13, 'f', '你是一个前端工作者。', 'ASSISTANT', '[]', 'f', '2026-02-25 11:37:36.083528', '2026-02-25 11:37:36.083528', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026532142487240706', '1', 14, 'f', '你好！', 'USER', '[]', 'f', '2026-02-25 13:38:08.635489', '2026-02-25 13:38:08.635489', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026532158337515522', '1', 15, 'f', '你好！😊  
有什么我可以帮你的吗？或者今天想聊点什么？', 'ASSISTANT', '[]', 'f', '2026-02-25 13:38:12.352044', '2026-02-25 13:38:12.352044', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026547539718516737', '2026547537487147009', 1, 'f', '你好！', 'USER', '[]', 'f', '2026-02-25 14:39:19.590114', '2026-02-25 14:39:19.590114', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026547551047331841', '2026547537487147009', 2, 'f', '你好！很高兴见到你，有什么我可以帮忙的吗？😊', 'ASSISTANT', '[]', 'f', '2026-02-25 14:39:22.260471', '2026-02-25 14:39:22.260471', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026566363742244865', '2026566360894312449', 1, 'f', '你好！', 'USER', '[]', 'f', '2026-02-25 15:54:07.569762', '2026-02-25 15:54:07.569762', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026566372881633282', '2026566360894312449', 2, 'f', '你好！很高兴见到你，有什么我可以帮忙的吗？😊', 'ASSISTANT', '[]', 'f', '2026-02-25 15:54:09.73882', '2026-02-25 15:54:09.73882', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026566473666564098', '2026566360894312449', 3, 'f', '请问你是？', 'USER', '[]', 'f', '2026-02-25 15:54:33.77116', '2026-02-25 15:54:33.77116', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026566484689195009', '2026566360894312449', 4, 'f', '你好！我是通义千问（Qwen），是由通义实验室研发的超大规模语言模型。我可以回答问题、创作文字，比如写故事、写公文、写邮件、写剧本、逻辑推理、编程等等，还能表达观点，玩游戏等。如果你有任何问题或需要帮助，尽管告诉我！😊', 'ASSISTANT', '[]', 'f', '2026-02-25 15:54:36.396706', '2026-02-25 15:54:36.396706', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026566539366141953', '2026566360894312449', 5, 'f', '帮我写一段简单的代码', 'USER', '[]', 'f', '2026-02-25 15:54:49.435964', '2026-02-25 15:54:49.435964', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026566561923108865', '2026566360894312449', 6, 'f', '当然可以！以下是一段简单的 Python 代码，它会打印“你好，世界！”并计算两个数字的和：

```python
# 打印欢迎信息
print("你好，世界！")

# 定义两个数字
a = 10
b = 20

# 计算它们的和
sum_result = a + b

# 输出结果
print(f"{a} + {b} = {sum_result}")
```

运行这段代码，你会看到输出：
```
你好，世界！
10 + 20 = 30
```

如果你有特定的需求（比如用其他语言、实现某个功能等），告诉我，我可以为你定制一段代码！ 😊', 'ASSISTANT', '[]', 'f', '2026-02-25 15:54:54.809369', '2026-02-25 15:54:54.809369', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026573477969702914', '2026573474320658434', 1, 'f', '我的职业是？', 'USER', '[]', 'f', '2026-02-25 16:22:23.740972', '2026-02-25 16:22:23.740972', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026573489319489537', '2026573474320658434', 2, 'f', '前端工作者', 'ASSISTANT', '[]', 'f', '2026-02-25 16:22:26.439432', '2026-02-25 16:22:26.439432', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026573755267723265', '2026573754282061826', 1, 'f', '你好！', 'USER', '[]', 'f', '2026-02-25 16:23:29.847355', '2026-02-25 16:23:29.847355', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026573759789182978', '2026573754282061826', 2, 'f', '你好！', 'ASSISTANT', '[]', 'f', '2026-02-25 16:23:30.922855', '2026-02-25 16:23:30.922855', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026573784275529730', '2026573754282061826', 3, 'f', '我是什么职业？', 'USER', '[]', 'f', '2026-02-25 16:23:36.755956', '2026-02-25 16:23:36.755956', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026573787651944450', '2026573754282061826', 4, 'f', '你是一个前端工作者。', 'ASSISTANT', '[]', 'f', '2026-02-25 16:23:37.561014', '2026-02-25 16:23:37.561014', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026574167249039361', '2026573754282061826', 5, 'f', '你是谁？', 'USER', '[]', 'f', '2026-02-25 16:25:08.071732', '2026-02-25 16:25:08.071732', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026574172965875714', '2026573754282061826', 6, 'f', '我是一个前端工作者。', 'ASSISTANT', '[]', 'f', '2026-02-25 16:25:09.431293', '2026-02-25 16:25:09.431293', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026574262145167362', '2026573754282061826', 7, 'f', '你可以做什么？', 'USER', '[]', 'f', '2026-02-25 16:25:30.686357', '2026-02-25 16:25:30.686357', 'f', NULL, NULL);
INSERT INTO "public"."chat_message" VALUES ('2026574265995538434', '2026573754282061826', 8, 'f', '我是一个前端工作者。', 'ASSISTANT', '[]', 'f', '2026-02-25 16:25:31.598465', '2026-02-25 16:25:31.598465', 'f', NULL, NULL);

-- ----------------------------
-- Table structure for document_entity
-- ----------------------------
DROP TABLE IF EXISTS "public"."document_entity";
CREATE TABLE "public"."document_entity" (
  "id" int8 NOT NULL DEFAULT nextval('document_entity_id_seq'::regclass),
  "file_name" varchar(512) COLLATE "pg_catalog"."default" NOT NULL,
  "path" text COLLATE "pg_catalog"."default" NOT NULL,
  "base_id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "is_embedding" bool DEFAULT false,
  "resource_id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of document_entity
-- ----------------------------
INSERT INTO "public"."document_entity" VALUES (6, 'message.md', 'knowledge-file/message.md/49ce20e8f1611451', '79a0baee5adbf82a7b29fb79f32ac551', 't', 'e694f73ec758a1d0', '2026-02-25 10:19:31.14368', '2026-02-25 10:19:31.14368', 'f', NULL, NULL);

-- ----------------------------
-- Table structure for knowledge_base
-- ----------------------------
DROP TABLE IF EXISTS "public"."knowledge_base";
CREATE TABLE "public"."knowledge_base" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of knowledge_base
-- ----------------------------
INSERT INTO "public"."knowledge_base" VALUES ('79a0baee5adbf82a7b29fb79f32ac551', 'YoyuEN', 'Profile', '2026-02-24 17:39:40.042181', '2026-02-24 17:39:40.042181', 'f', NULL, NULL);

-- ----------------------------
-- Table structure for origin_file_source
-- ----------------------------
DROP TABLE IF EXISTS "public"."origin_file_source";
CREATE TABLE "public"."origin_file_source" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "file_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "path" text COLLATE "pg_catalog"."default" NOT NULL,
  "is_image" bool NOT NULL,
  "bucket_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "object_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "content_type" text COLLATE "pg_catalog"."default" NOT NULL,
  "size" int8 NOT NULL,
  "md5" text COLLATE "pg_catalog"."default" NOT NULL,
  "images" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '[]'::text,
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."origin_file_source"."id" IS '文件唯一标识';
COMMENT ON COLUMN "public"."origin_file_source"."file_name" IS '文件名';
COMMENT ON COLUMN "public"."origin_file_source"."path" IS '文件存储路径';
COMMENT ON COLUMN "public"."origin_file_source"."is_image" IS '是否为图片文件';
COMMENT ON COLUMN "public"."origin_file_source"."bucket_name" IS '对象存储桶名称';
COMMENT ON COLUMN "public"."origin_file_source"."object_name" IS '对象存储中的文件名';
COMMENT ON COLUMN "public"."origin_file_source"."content_type" IS '文件的 MIME 类型';
COMMENT ON COLUMN "public"."origin_file_source"."size" IS '文件大小（字节）';
COMMENT ON COLUMN "public"."origin_file_source"."md5" IS '文件 MD5 哈希值';
COMMENT ON COLUMN "public"."origin_file_source"."images" IS '文档内包含的图片列表（JSON 数组）';
COMMENT ON COLUMN "public"."origin_file_source"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "public"."origin_file_source"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "public"."origin_file_source"."deleted" IS '是否被逻辑删除（软删除）';
COMMENT ON TABLE "public"."origin_file_source" IS '存储原始文件资源的表';

-- ----------------------------
-- Records of origin_file_source
-- ----------------------------
INSERT INTO "public"."origin_file_source" VALUES ('06bf3bac62bcd099', 'message.md', 'origin-file/message.md/4a1361a0071d62ba', 'f', 'origin-file', 'message.md/4a1361a0071d62ba', 'text/x-web-markdown', 30, 'e79e40458425ca90', '[]', '2026-02-25 10:03:03.86701', '2026-02-25 10:03:03.86701', 'f', NULL, NULL);
INSERT INTO "public"."origin_file_source" VALUES ('e694f73ec758a1d0', 'message.md', 'knowledge-file/message.md/49ce20e8f1611451', 'f', 'knowledge-file', 'message.md/49ce20e8f1611451', 'text/x-web-markdown', 30, 'e79e40458425ca90', '[]', '2026-02-25 10:19:31.14368', '2026-02-25 10:19:31.14368', 'f', NULL, NULL);

-- ----------------------------
-- Table structure for system_permission
-- ----------------------------
DROP TABLE IF EXISTS "public"."system_permission";
CREATE TABLE "public"."system_permission" (
  "id" int8 NOT NULL DEFAULT nextval('system_permission_id_seq'::regclass),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(500) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."system_permission"."id" IS '权限ID';
COMMENT ON COLUMN "public"."system_permission"."name" IS '权限名称';
COMMENT ON COLUMN "public"."system_permission"."description" IS '权限描述';
COMMENT ON COLUMN "public"."system_permission"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."system_permission"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."system_permission"."deleted" IS '是否删除（false-未删除，true-已删除）';
COMMENT ON COLUMN "public"."system_permission"."creator" IS '创建人';
COMMENT ON COLUMN "public"."system_permission"."updater" IS '更新人';
COMMENT ON TABLE "public"."system_permission" IS '系统权限表';

-- ----------------------------
-- Records of system_permission
-- ----------------------------

-- ----------------------------
-- Table structure for system_role
-- ----------------------------
DROP TABLE IF EXISTS "public"."system_role";
CREATE TABLE "public"."system_role" (
  "id" int8 NOT NULL DEFAULT nextval('system_role_id_seq'::regclass),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(500) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."system_role"."id" IS '角色id';
COMMENT ON COLUMN "public"."system_role"."name" IS '角色名';
COMMENT ON COLUMN "public"."system_role"."description" IS '角色描述';
COMMENT ON COLUMN "public"."system_role"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."system_role"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."system_role"."deleted" IS '是否删除（false-未删除，true-已删除）';
COMMENT ON COLUMN "public"."system_role"."creator" IS '创建人';
COMMENT ON COLUMN "public"."system_role"."updater" IS '更新人';
COMMENT ON TABLE "public"."system_role" IS '系统角色表';

-- ----------------------------
-- Records of system_role
-- ----------------------------

-- ----------------------------
-- Table structure for system_role_permission
-- ----------------------------
DROP TABLE IF EXISTS "public"."system_role_permission";
CREATE TABLE "public"."system_role_permission" (
  "id" int8 NOT NULL DEFAULT nextval('system_role_permission_id_seq'::regclass),
  "role_id" int8 NOT NULL,
  "permission_id" int8 NOT NULL,
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."system_role_permission"."role_id" IS '角色ID';
COMMENT ON COLUMN "public"."system_role_permission"."permission_id" IS '权限ID';
COMMENT ON COLUMN "public"."system_role_permission"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."system_role_permission"."creator" IS '创建人';
COMMENT ON TABLE "public"."system_role_permission" IS '角色-权限关联表';

-- ----------------------------
-- Records of system_role_permission
-- ----------------------------

-- ----------------------------
-- Table structure for system_user
-- ----------------------------
DROP TABLE IF EXISTS "public"."system_user";
CREATE TABLE "public"."system_user" (
  "id" int8 NOT NULL DEFAULT nextval('system_user_id_seq'::regclass),
  "username" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."system_user"."id" IS '用户id';
COMMENT ON COLUMN "public"."system_user"."username" IS '用户名';
COMMENT ON COLUMN "public"."system_user"."password" IS '密码';
COMMENT ON COLUMN "public"."system_user"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."system_user"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."system_user"."deleted" IS '是否删除（false-未删除，true-已删除）';
COMMENT ON COLUMN "public"."system_user"."creator" IS '创建人';
COMMENT ON COLUMN "public"."system_user"."updater" IS '更新人';
COMMENT ON TABLE "public"."system_user" IS '系统用户表';

-- ----------------------------
-- Records of system_user
-- ----------------------------
INSERT INTO "public"."system_user" VALUES (1, 'YoyuEN', '242431', '2026-02-25 09:13:52.247648', '2026-02-25 09:13:52.247648', 'f', NULL, NULL);

-- ----------------------------
-- Table structure for system_user_role
-- ----------------------------
DROP TABLE IF EXISTS "public"."system_user_role";
CREATE TABLE "public"."system_user_role" (
  "id" int8 NOT NULL DEFAULT nextval('system_user_role_id_seq'::regclass),
  "user_id" int8 NOT NULL,
  "role_id" int8 NOT NULL,
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."system_user_role"."user_id" IS '用户ID';
COMMENT ON COLUMN "public"."system_user_role"."role_id" IS '角色ID';
COMMENT ON COLUMN "public"."system_user_role"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."system_user_role"."creator" IS '创建人';
COMMENT ON TABLE "public"."system_user_role" IS '用户-角色关联表';

-- ----------------------------
-- Records of system_user_role
-- ----------------------------

-- ----------------------------
-- Table structure for vector_store
-- ----------------------------
DROP TABLE IF EXISTS "public"."vector_store";
CREATE TABLE "public"."vector_store" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "content" text COLLATE "pg_catalog"."default",
  "metadata" json,
  "embedding" "public"."vector"
)
;

-- ----------------------------
-- Records of vector_store
-- ----------------------------
INSERT INTO "public"."vector_store" VALUES ('80d5c7bd-3c63-4891-a1ae-d60f1018cec7', '我是一个前端工作者。', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "document_id": 6, "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[0.014330987,-0.01316571,-0.0068693454,-0.044293437,0.004464753,-0.016365396,-0.0053306636,0.10414108,-0.03322008,0.09481886,0.029434534,0.023640335,-0.0021100545,0.036799606,-0.010577633,-0.038576495,0.0048703467,-0.028945247,-0.046688374,-0.024966562,-0.025893634,0.011530457,0.057941996,0.0071268654,0.0021197114,-0.006363963,0.00039654053,-0.05049967,-0.031906728,0.020047931,-0.043134596,0.034198653,0.014433995,0.01229658,-0.070045434,-0.0030516118,-0.02281627,0.014717267,0.03170071,0.04148647,-0.0074423277,-0.0056107165,-0.011581961,-0.055727325,-0.020073682,0.019391255,-0.0056686588,0.039271798,-0.027039599,-0.022957906,-0.024322763,0.034996968,-0.0056783156,0.026151154,0.0069144117,-0.017820382,-0.0047737765,-0.022146719,-0.019378379,0.025030943,0.029846566,-0.024734795,-0.031777967,0.03785544,-0.008878002,-0.09203764,-0.0695304,-0.008923068,0.03813871,-0.059950653,0.0065120365,-0.02667907,0.0010324942,0.019275371,-0.03334884,0.04094568,-0.037082877,0.010139849,-0.0041331956,0.0060613765,0.018258167,-0.044937238,0.06329841,-0.039941348,0.08704176,0.035460502,0.0057909805,0.032396015,0.007860797,0.066028126,0.0031224298,0.02356308,-0.030438863,0.01567009,-0.06741873,0.0721571,-0.085342124,0.028146934,-0.02732287,0.010635575,-0.013880327,0.0090196375,0.01921099,-0.054336715,-0.0077191615,0.020060807,-0.029305775,0.014150723,-0.0059841205,0.013532675,-0.0070496094,-0.05049967,0.004577418,0.04792447,0.02094925,0.019893419,-0.030567622,-0.021593051,-0.037288893,0.019429883,0.025236959,-0.013674311,-0.025185455,-0.007873674,0.009811511,-0.004361745,0.017820382,-0.040224623,-0.0045098187,-0.015798852,-0.018515687,-0.042877078,0.024837803,0.022455743,0.028558966,-0.0032801607,0.023357064,0.022661759,-0.0115690855,0.011401697,0.01615938,-0.027425878,0.054079197,0.011150615,0.010886657,0.024721919,-0.04756394,-0.010648452,-0.023447195,-0.0034700818,-0.07792555,0.026859334,-0.040379133,0.0107192695,0.0030854114,-0.01966165,0.025404347,-0.024979439,-0.006402591,0.016777428,-0.00085786346,0.019880543,-0.009644124,0.08086128,0.0032721134,-0.049366582,0.0113630695,-0.022429992,0.0020617694,0.00434565,-0.021876322,0.021747563,-0.0046096076,-0.03607855,0.014150723,0.0039690267,0.026447302,-0.00022915255,-0.010030404,-0.038164463,0.023369938,-0.0047802147,0.11454489,-0.013313783,-0.022867775,-0.034044143,0.013918955,-0.00872349,-0.009515364,0.02680783,0.05351265,0.009084018,0.011762225,0.070921004,0.0106227,0.018309671,-0.058302525,0.048413757,0.037597917,0.024824927,0.0066955197,-0.019494263,0.0047544627,0.025352843,-0.010249295,-0.032911055,0.019635899,-0.022030834,0.03041311,-0.016854683,-0.0055753076,-0.014227979,-0.005939055,-0.019790411,-0.006058158,-0.013249403,-0.029743558,-0.012515471,0.01821954,-0.030593375,-0.018541439,0.06082622,0.055881836,0.020897746,0.050061885,-0.00013751166,0.014833151,0.056139357,0.022365611,-0.0064573134,-0.010635575,0.036490582,-0.041074436,-0.04625059,-0.035357494,-0.0047093965,0.03195823,-0.027503135,-0.021103762,0.027812159,0.00010491927,0.031649206,-0.014279483,0.012509033,0.0032688943,0.028945247,-0.0469974,0.00985014,-0.035512008,0.049933124,-0.095900446,-0.011214996,0.014382491,-0.0053274445,0.0060774717,-0.02275189,-0.012122753,0.018798959,0.022481496,-0.0011355022,0.012509033,0.018065028,-0.0064895037,-0.03182947,-0.018271044,0.011047607,0.032009736,0.037597917,-0.035769526,0.0076419055,-0.00434565,-0.027503135,0.00062207173,0.0068242797,0.024322763,0.069118366,-0.038035702,-0.037443407,-0.04043064,-0.005749134,-0.0476927,-0.016275262,0.036130056,-0.033426095,-0.032653533,0.04213027,0.029305775,0.0056364685,0.034842454,-0.03430166,-0.00059189356,0.067367226,0.027915167,-0.008137631,-0.043108847,0.026447302,0.019687403,0.0109767895,0.028970998,0.0036503458,-0.021992207,0.010905972,0.021425663,-0.015245183,0.008420903,-0.013185023,-0.023022287,-0.07390824,-0.008266391,-0.052791595,-0.0063864957,-0.019365503,0.004229766,-0.0112858135,0.023254056,-0.021425663,-0.02719411,0.003962589,0.022957906,0.013519799,0.057272445,0.015412571,-0.011247185,-0.0028069678,0.0670067,0.034430422,0.010983228,-0.019223867,0.05299761,-0.0035537758,-0.02809543,-0.011897423,-0.0010139849,0.023241179,-0.037726678,0.00086108246,0.0059197405,0.0071204277,0.018850463,-0.006312459,0.0072942534,0.018773207,-0.005208342,0.0099209575,0.036001295,-0.010551881,0.013867451,0.024374267,-0.030902399,0.034610685,0.00985014,0.026202658,0.019816162,0.060259677,0.002475411,-0.06298939,0.041022934,0.0015781147,0.012566975,0.0061032237,-0.0068307174,0.014936159,-0.055109277,-0.0028375483,0.069015354,0.010783649,-0.0063060205,0.008266391,-0.02429701,0.019172363,-0.015064919,-0.012142068,0.02873923,0.012322332,0.01592761,-0.02899675,0.034687944,-0.018966347,0.0016915844,0.03260203,-0.033812374,0.025713371,0.019944923,-0.014472623,-0.03322008,-0.0067341477,-0.0057652285,-0.0071075517,0.0021068354,-0.058714557,0.026962342,0.044267684,-0.0037436967,-0.014227979,0.010809401,-0.015245183,-0.010197791,-0.01252191,0.0010155945,0.01972603,-0.0076419055,-0.020344079,-0.016532782,0.020086559,-0.0084273415,0.0016915844,0.022648882,-0.033966888,-0.042078767,0.015425447,-0.039503567,0.0014300407,0.064895034,-0.022893528,-0.029228518,-0.014163599,-0.027271366,-0.019275371,-0.017717374,-0.0021454634,-0.019532891,0.011556209,0.010783649,-0.014730143,-0.012303017,0.1764527,-0.03185522,-0.06453451,0.022713263,-9.4105446e-05,0.0073779477,-0.014820275,0.030747887,0.014717267,0.031546198,-0.012998321,0.026267039,0.0025172578,-0.05552131,-0.0062899254,-0.042954333,0.014575631,-0.0020939594,0.024245506,-0.00031264537,0.0015161489,-0.027683398,-0.048413757,-0.054182205,-0.013661435,-0.013983335,0.019944923,0.045761302,-0.010963913,0.019198114,0.0048059667,0.013687187,-0.033194326,-0.032138493,0.037520662,0.02230123,-0.032138493,-0.004696521,-0.048388004,-0.048774287,0.03185522,0.024915058,-0.01229658,0.027657647,0.0077964175,-0.039529316,0.0026798174,-0.006132195,-0.027374374,-0.030722134,0.03167496,0.0014485499,0.018489935,0.01940413,0.050679933,0.010139849,0.02925427,-0.04856827,0.0019394474,0.0017076794,0.027786406,0.005066706,-0.053409643,0.0029872318,-0.027168358,0.038087204,-0.040224623,-0.015966238,0.045761302,-0.015773099,0.040507894,-0.0018139064,-0.09414931,0.044679716,-0.06453451,0.02178619,0.012592727,-0.044679716,-0.032009736,0.08189136,-0.0066697677,0.0029598703,0.015283811,0.0069466014,-0.012940379,-0.025970891,0.021902075,-0.013597055,0.0091999015,0.0015781147,0.0056429068,0.032396015,0.026885087,-0.00040659992,0.017936267,-0.054336715,-0.020485714,-0.015605711,0.013764443,-0.027168358,0.0029743558,0.060980733,0.0069144117,0.040791165,0.0062770494,0.010790087,-0.003009765,-0.024567407,0.0032495803,-0.0451175,0.01586323,-0.025417222,0.0029292898,0.03543475,0.01612075,0.032396015,0.014266607,0.026267039,0.03888552,0.016661543,-0.061495773,0.0089681335,-0.045297764,0.024219755,0.0112085575,0.01841268,0.061547276,0.02667907,0.017652996,0.018052151,0.0068178414,-0.0075131455,0.02899675,-0.005939055,-0.036130056,0.004963698,-0.01715083,-0.033194326,-0.0086333575,-0.0030435643,-0.011498268,0.006209451,-0.013197899,-0.014678639,-0.009290034,-0.04007011,0.024773423,-0.024168251,0.015489827,0.030567622,-0.029872319,0.01940413,0.033039816,0.028301446,-0.0018654104,-0.02227548,0.0030145934,0.013725815,0.026601814,0.03237026,0.022636008,0.054285213,0.0036342507,0.02783791,0.040894173,-0.03002683,-0.021052258,-0.059950653,-0.014446871,-0.019236743,0.011253623,0.057014924,-0.002520477,0.017524235,0.022584504,-0.036413327,0.027606143,0.021142391,0.016236635,0.031031158,0.0043810587,0.012277265,0.02783791,0.010506815,-0.02146429,-0.0016078904,-0.0071590557,0.03144319,0.007912301,-0.038834013,-0.023395691,0.0062416405,-0.008156946,-0.021103762,-0.013043387,-0.017318219,0.0078028557,0.0065152557,-0.015579959,0.033014063,0.0108222775,0.03749491,-0.06880934,-0.022520123,-0.0013230089,0.039709583,0.060362685,-0.054748747,0.019867666,-0.0072942534,-0.0024738014,-0.045967318,-0.01895347,-0.030104086,0.0014284311,0.018541439,0.0051375236,0.0034765198,0.0034539867,-0.018992098,-0.043083094,-0.0631439,-0.010551881,-0.0076032775,0.014163599,-0.033014063,0.008118317,0.013764443,0.034868207,0.059435613,0.010287924,-0.03322008,0.023460072,-0.023962235,-0.004065597,-0.026962342,-0.05464574,0.024953688,-0.009412356,-0.033529103,0.00072829874,-0.0056525636,0.0027602923,0.011691407,0.04573555,-0.088741384,-0.0069594774,-0.009985337,0.08832935,0.06638865,0.011292252,-0.035769526,0.022339858,0.04290283,-0.0116205895,-0.0069659157,0.027657647,-0.044370692,-0.014640011,-0.046945892,0.0039690267,0.040739663,0.06159878,-0.05075719,0.02047284,0.0049057556,-0.01637827,-0.017756004,-0.034327414,-0.051503997,-0.00085142546,-0.08807184,-0.016790302,0.03852499,0.0014775209,-0.0049154125,0.010963913,0.032653533,-0.043649636,-0.00064138573,0.0023707934,0.0037082878,-0.018914843,0.014614259,0.0070624854,-0.0036954118,-0.016288139,0.018077902,-0.02176044,-0.02822419,0.050190646,-0.0030516118,0.032293007,-0.022442866,0.0107192695,0.022777643,0.03430166,0.052276555,0.012830934,0.00081279746,0.049315076,0.050679933,-0.01010766,-0.013365287,0.0347652,-0.04779571,-0.04086842,0.0051246476,0.017936267,0.010629137,0.03273079,-0.04151222,-0.018876215,-0.008639796,-0.01914661,0.01252191,0.018348299,-0.027374374,0.0470489,0.10347153,-0.021296903,0.008388714,0.007899426,0.011421012,0.026782079,-0.0048832227,0.014433995,-0.03322008,0.009038951,0.017459854,0.05255983,0.03167496,-0.0027796063,-0.03376087,-0.016017742,0.03324583,-0.055727325,-0.00026013542,0.032679286,0.0065603214,0.013185023,-0.008491722,0.02378197,-0.0051858085,0.029537542,0.018077902,0.014215103,0.010777212,0.024000863,-0.011015417,0.022739016,-0.023601707,-0.07432027,-0.01944276,-0.0058457037,0.01869595,0.071333036,-0.18077902,0.009347975,0.017652996,0.037185885,0.017833259,-0.0066375774,0.0019523234,-0.029795062,0.016301015,0.025545983,0.006492723,-0.037160136,0.05191603,-0.0032511898,0.02706535,0.014961911,0.0592811,-0.012644231,-0.0063349917,-0.06365894,0.08802033,-0.01023642,0.0071139894,0.0069530397,-0.03533174,0.032421768,-0.023910731,-0.019571519,0.008214887,-0.021824818,0.011478953,-0.030644879,-0.01567009,-0.008189135,-0.02485068,0.0057813236,0.042748317,-0.03592404,-0.023292683,0.004010874,0.014588507,0.03234451,-0.002365965,-0.011961804,0.018567191,-0.03775243,-0.0093351,-0.0004566956,0.013674311,-0.036490582,0.025726246,0.032061238,-0.02230123,0.0073972614,-0.031906728,-0.0051117716,-0.015914734,0.017562862,-0.015876107,-0.02485068,0.0052051228,-0.016828932,-0.0010823887,-0.033400342,0.037700925,-0.011710721,-0.002771559,0.0089166295,-0.11238172,0.011369508,0.016455527,0.02407812,0.05163276,0.009103332,-0.010603385,0.04148647,-0.014833151,0.0011314785,-0.010680641,-0.03170071,-0.011292252,0.014820275,0.029563295,0.04663687,0.0011918347,0.020459963,-0.0036793167,0.01252191,0.014150723,0.0708695,0.01592761,0.047332175,-0.033091318,-0.025121074,-0.02049859,-0.00447441,0.024284136,0.034481928,0.07849209,0.007989557,-0.023447195,-0.026910838,0.07643193,0.04097143,-0.0046997396,-0.0108737815,0.009193463,0.046585366,0.010069031,0.024747672,-0.03479095,-0.0019957798,0.024915058,-0.0018798959,-0.06669768,0.033606358,-0.021258274,0.012863123,0.06288638,0.0064830654,-0.10980652,0.01744698,-0.041254703,-0.022365611,-0.0035956227,0.010654889,0.012566975,0.0058714557,0.027915167,0.0047093965,0.017807508,0.029872319,-0.024580283,0.0034700818,0.016082123,-0.06922137,0.002301585,-0.018013524,-0.0035151478,0.01740835,0.017652996,-0.027503135,-0.0113115655,0.018554315,-0.0041106627,-0.014021963,0.009708503,-0.0033413218,0.024515903,0.033683613,0.046044573,0.027786406,0.053255133,0.042851325,-0.076483436,-0.009830825,0.016107876,-0.013429667,-0.024374267,-0.014949035,0.0077191615,-0.014498375,0.014936159,0.0038949898,0.015283811,0.00614829,0.02300941,0.045297764,-0.014588507,0.0073650717,-0.056293868,-0.004413249,-0.013139958,0.0106420135,0.05181302,-0.002391717,-0.0014477451,0.0004518671,-0.0043038027,0.019687403,0.013004759,0.0018203444,-0.01583748,-0.012830934,0.00054642523,-0.019429883,-0.0053564156,0.04522051,0.0021615585,0.01873458,-0.014884655,-0.042799823,-0.027297119,0.043392118,0.003048393,-0.013815947,-0.05402769,-0.017588615,-0.037082877,-0.00020661954,-0.059384108,0.00014576034,-0.05449123,-0.03144319,0.029331526,-0.019391255,-0.019417007,0.030207094,-0.00011216202,-0.008317895,0.058405533,0.017343972,0.0045709796,0.020910623,0.0199578,0.00023679767,0.02452878,-0.018605819,0.010416684,-0.031597704,-0.048851542,-0.011195681,-0.033529103,0.012122753,-0.057890493,0.026254162,0.013236527,-0.0078028557,0.009013199,-0.014961911,0.024142498,-0.036696598,0.033606358,0.00060396484,0.00032451542,0.0055141468,-0.038447734,-0.037675172,-0.00063092395,0.016970567,-0.06376195,0.042181775]');

-- ----------------------------
-- Function structure for akeys
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."akeys"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."akeys"("public"."hstore")
  RETURNS "pg_catalog"."_text" AS '$libdir/hstore', 'hstore_akeys'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_halfvec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_halfvec"(_numeric, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_halfvec"(_numeric, int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'array_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_halfvec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_halfvec"(_int4, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_halfvec"(_int4, int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'array_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_halfvec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_halfvec"(_float4, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_halfvec"(_float4, int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'array_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_halfvec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_halfvec"(_float8, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_halfvec"(_float8, int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'array_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_sparsevec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_sparsevec"(_float4, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_sparsevec"(_float4, int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'array_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_sparsevec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_sparsevec"(_numeric, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_sparsevec"(_numeric, int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'array_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_sparsevec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_sparsevec"(_float8, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_sparsevec"(_float8, int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'array_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_sparsevec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_sparsevec"(_int4, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_sparsevec"(_int4, int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'array_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_vector
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_vector"(_numeric, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_vector"(_numeric, int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'array_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_vector
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_vector"(_int4, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_vector"(_int4, int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'array_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_vector
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_vector"(_float4, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_vector"(_float4, int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'array_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for array_to_vector
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."array_to_vector"(_float8, int4, bool);
CREATE OR REPLACE FUNCTION "public"."array_to_vector"(_float8, int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'array_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for avals
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."avals"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."avals"("public"."hstore")
  RETURNS "pg_catalog"."_text" AS '$libdir/hstore', 'hstore_avals'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for binary_quantize
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."binary_quantize"("public"."vector");
CREATE OR REPLACE FUNCTION "public"."binary_quantize"("public"."vector")
  RETURNS "pg_catalog"."bit" AS '$libdir/vector', 'binary_quantize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for binary_quantize
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."binary_quantize"("public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."binary_quantize"("public"."halfvec")
  RETURNS "pg_catalog"."bit" AS '$libdir/vector', 'halfvec_binary_quantize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for cosine_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."cosine_distance"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."cosine_distance"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_cosine_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for cosine_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."cosine_distance"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."cosine_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'cosine_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for cosine_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."cosine_distance"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."cosine_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_cosine_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for defined
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."defined"("public"."hstore", text);
CREATE OR REPLACE FUNCTION "public"."defined"("public"."hstore", text)
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_defined'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for delete
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."delete"("public"."hstore", text);
CREATE OR REPLACE FUNCTION "public"."delete"("public"."hstore", text)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_delete'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for delete
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."delete"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."delete"("public"."hstore", "public"."hstore")
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_delete_hstore'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for delete
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."delete"("public"."hstore", _text);
CREATE OR REPLACE FUNCTION "public"."delete"("public"."hstore", _text)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_delete_array'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for each
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."each"("hs" "public"."hstore", OUT "key" text, OUT "value" text);
CREATE OR REPLACE FUNCTION "public"."each"(IN "hs" "public"."hstore", OUT "key" text, OUT "value" text)
  RETURNS SETOF "pg_catalog"."record" AS '$libdir/hstore', 'hstore_each'
  LANGUAGE c IMMUTABLE STRICT
  COST 1
  ROWS 1000;

-- ----------------------------
-- Function structure for exist
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."exist"("public"."hstore", text);
CREATE OR REPLACE FUNCTION "public"."exist"("public"."hstore", text)
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_exists'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for exists_all
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."exists_all"("public"."hstore", _text);
CREATE OR REPLACE FUNCTION "public"."exists_all"("public"."hstore", _text)
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_exists_all'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for exists_any
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."exists_any"("public"."hstore", _text);
CREATE OR REPLACE FUNCTION "public"."exists_any"("public"."hstore", _text)
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_exists_any'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for fetchval
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."fetchval"("public"."hstore", text);
CREATE OR REPLACE FUNCTION "public"."fetchval"("public"."hstore", text)
  RETURNS "pg_catalog"."text" AS '$libdir/hstore', 'hstore_fetchval'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ghstore_compress
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_compress"(internal);
CREATE OR REPLACE FUNCTION "public"."ghstore_compress"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/hstore', 'ghstore_compress'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ghstore_consistent
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_consistent"(internal, "public"."hstore", int2, oid, internal);
CREATE OR REPLACE FUNCTION "public"."ghstore_consistent"(internal, "public"."hstore", int2, oid, internal)
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'ghstore_consistent'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ghstore_decompress
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_decompress"(internal);
CREATE OR REPLACE FUNCTION "public"."ghstore_decompress"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/hstore', 'ghstore_decompress'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ghstore_in
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_in"(cstring);
CREATE OR REPLACE FUNCTION "public"."ghstore_in"(cstring)
  RETURNS "public"."ghstore" AS '$libdir/hstore', 'ghstore_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ghstore_options
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_options"(internal);
CREATE OR REPLACE FUNCTION "public"."ghstore_options"(internal)
  RETURNS "pg_catalog"."void" AS '$libdir/hstore', 'ghstore_options'
  LANGUAGE c IMMUTABLE
  COST 1;

-- ----------------------------
-- Function structure for ghstore_out
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_out"("public"."ghstore");
CREATE OR REPLACE FUNCTION "public"."ghstore_out"("public"."ghstore")
  RETURNS "pg_catalog"."cstring" AS '$libdir/hstore', 'ghstore_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ghstore_penalty
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_penalty"(internal, internal, internal);
CREATE OR REPLACE FUNCTION "public"."ghstore_penalty"(internal, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/hstore', 'ghstore_penalty'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ghstore_picksplit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_picksplit"(internal, internal);
CREATE OR REPLACE FUNCTION "public"."ghstore_picksplit"(internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/hstore', 'ghstore_picksplit'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ghstore_same
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_same"("public"."ghstore", "public"."ghstore", internal);
CREATE OR REPLACE FUNCTION "public"."ghstore_same"("public"."ghstore", "public"."ghstore", internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/hstore', 'ghstore_same'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ghstore_union
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ghstore_union"(internal, internal);
CREATE OR REPLACE FUNCTION "public"."ghstore_union"(internal, internal)
  RETURNS "public"."ghstore" AS '$libdir/hstore', 'ghstore_union'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_consistent_hstore
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_consistent_hstore"(internal, int2, "public"."hstore", int4, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_consistent_hstore"(internal, int2, "public"."hstore", int4, internal, internal)
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'gin_consistent_hstore'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_hstore
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_hstore"("public"."hstore", internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_hstore"("public"."hstore", internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/hstore', 'gin_extract_hstore'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_hstore_query
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_hstore_query"("public"."hstore", internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_hstore_query"("public"."hstore", internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/hstore', 'gin_extract_hstore_query'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec"("public"."halfvec", int4, bool);
CREATE OR REPLACE FUNCTION "public"."halfvec"("public"."halfvec", int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_accum
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_accum"(_float8, "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_accum"(_float8, "public"."halfvec")
  RETURNS "pg_catalog"."_float8" AS '$libdir/vector', 'halfvec_accum'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_add
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_add"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_add"("public"."halfvec", "public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_add'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_avg
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_avg"(_float8);
CREATE OR REPLACE FUNCTION "public"."halfvec_avg"(_float8)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_avg'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_cmp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_cmp"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_cmp"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'halfvec_cmp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_combine
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_combine"(_float8, _float8);
CREATE OR REPLACE FUNCTION "public"."halfvec_combine"(_float8, _float8)
  RETURNS "pg_catalog"."_float8" AS '$libdir/vector', 'vector_combine'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_concat
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_concat"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_concat"("public"."halfvec", "public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_concat'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_eq
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_eq"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_eq"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_eq'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_ge
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_ge"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_ge"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_ge'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_gt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_gt"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_gt"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_gt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_in
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_in"(cstring, oid, int4);
CREATE OR REPLACE FUNCTION "public"."halfvec_in"(cstring, oid, int4)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_l2_squared_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_l2_squared_distance"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_l2_squared_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_l2_squared_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_le
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_le"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_le"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_le'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_lt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_lt"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_lt"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_lt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_mul
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_mul"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_mul"("public"."halfvec", "public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_mul'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_ne
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_ne"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_ne"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_ne'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_negative_inner_product
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_negative_inner_product"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_negative_inner_product"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_negative_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_out
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_out"("public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_out"("public"."halfvec")
  RETURNS "pg_catalog"."cstring" AS '$libdir/vector', 'halfvec_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_recv
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_recv"(internal, oid, int4);
CREATE OR REPLACE FUNCTION "public"."halfvec_recv"(internal, oid, int4)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_recv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_send
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_send"("public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_send"("public"."halfvec")
  RETURNS "pg_catalog"."bytea" AS '$libdir/vector', 'halfvec_send'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_spherical_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_spherical_distance"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_spherical_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_spherical_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_sub
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_sub"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."halfvec_sub"("public"."halfvec", "public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_sub'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_to_float4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_to_float4"("public"."halfvec", int4, bool);
CREATE OR REPLACE FUNCTION "public"."halfvec_to_float4"("public"."halfvec", int4, bool)
  RETURNS "pg_catalog"."_float4" AS '$libdir/vector', 'halfvec_to_float4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_to_sparsevec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_to_sparsevec"("public"."halfvec", int4, bool);
CREATE OR REPLACE FUNCTION "public"."halfvec_to_sparsevec"("public"."halfvec", int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'halfvec_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_to_vector
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_to_vector"("public"."halfvec", int4, bool);
CREATE OR REPLACE FUNCTION "public"."halfvec_to_vector"("public"."halfvec", int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'halfvec_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for halfvec_typmod_in
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."halfvec_typmod_in"(_cstring);
CREATE OR REPLACE FUNCTION "public"."halfvec_typmod_in"(_cstring)
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'halfvec_typmod_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hamming_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hamming_distance"(bit, bit);
CREATE OR REPLACE FUNCTION "public"."hamming_distance"(bit, bit)
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'hamming_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hnsw_bit_support
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hnsw_bit_support"(internal);
CREATE OR REPLACE FUNCTION "public"."hnsw_bit_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'hnsw_bit_support'
  LANGUAGE c VOLATILE
  COST 1;

-- ----------------------------
-- Function structure for hnsw_halfvec_support
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hnsw_halfvec_support"(internal);
CREATE OR REPLACE FUNCTION "public"."hnsw_halfvec_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'hnsw_halfvec_support'
  LANGUAGE c VOLATILE
  COST 1;

-- ----------------------------
-- Function structure for hnsw_sparsevec_support
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hnsw_sparsevec_support"(internal);
CREATE OR REPLACE FUNCTION "public"."hnsw_sparsevec_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'hnsw_sparsevec_support'
  LANGUAGE c VOLATILE
  COST 1;

-- ----------------------------
-- Function structure for hnswhandler
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hnswhandler"(internal);
CREATE OR REPLACE FUNCTION "public"."hnswhandler"(internal)
  RETURNS "pg_catalog"."index_am_handler" AS '$libdir/vector', 'hnswhandler'
  LANGUAGE c VOLATILE
  COST 1;

-- ----------------------------
-- Function structure for hs_concat
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hs_concat"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hs_concat"("public"."hstore", "public"."hstore")
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_concat'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hs_contained
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hs_contained"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hs_contained"("public"."hstore", "public"."hstore")
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_contained'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hs_contains
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hs_contains"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hs_contains"("public"."hstore", "public"."hstore")
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_contains'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore"(_text);
CREATE OR REPLACE FUNCTION "public"."hstore"(_text)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_from_array'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore"(text, text);
CREATE OR REPLACE FUNCTION "public"."hstore"(text, text)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_from_text'
  LANGUAGE c IMMUTABLE
  COST 1;

-- ----------------------------
-- Function structure for hstore
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore"(_text, _text);
CREATE OR REPLACE FUNCTION "public"."hstore"(_text, _text)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_from_arrays'
  LANGUAGE c IMMUTABLE
  COST 1;

-- ----------------------------
-- Function structure for hstore
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore"(record);
CREATE OR REPLACE FUNCTION "public"."hstore"(record)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_from_record'
  LANGUAGE c IMMUTABLE
  COST 1;

-- ----------------------------
-- Function structure for hstore_cmp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_cmp"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_cmp"("public"."hstore", "public"."hstore")
  RETURNS "pg_catalog"."int4" AS '$libdir/hstore', 'hstore_cmp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_eq
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_eq"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_eq"("public"."hstore", "public"."hstore")
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_eq'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_ge
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_ge"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_ge"("public"."hstore", "public"."hstore")
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_ge'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_gt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_gt"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_gt"("public"."hstore", "public"."hstore")
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_gt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_hash
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_hash"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_hash"("public"."hstore")
  RETURNS "pg_catalog"."int4" AS '$libdir/hstore', 'hstore_hash'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_hash_extended
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_hash_extended"("public"."hstore", int8);
CREATE OR REPLACE FUNCTION "public"."hstore_hash_extended"("public"."hstore", int8)
  RETURNS "pg_catalog"."int8" AS '$libdir/hstore', 'hstore_hash_extended'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_in
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_in"(cstring);
CREATE OR REPLACE FUNCTION "public"."hstore_in"(cstring)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_le
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_le"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_le"("public"."hstore", "public"."hstore")
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_le'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_lt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_lt"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_lt"("public"."hstore", "public"."hstore")
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_lt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_ne
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_ne"("public"."hstore", "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_ne"("public"."hstore", "public"."hstore")
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_ne'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_out
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_out"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_out"("public"."hstore")
  RETURNS "pg_catalog"."cstring" AS '$libdir/hstore', 'hstore_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_recv
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_recv"(internal);
CREATE OR REPLACE FUNCTION "public"."hstore_recv"(internal)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_recv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_send
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_send"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_send"("public"."hstore")
  RETURNS "pg_catalog"."bytea" AS '$libdir/hstore', 'hstore_send'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_subscript_handler
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_subscript_handler"(internal);
CREATE OR REPLACE FUNCTION "public"."hstore_subscript_handler"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/hstore', 'hstore_subscript_handler'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_to_array
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_to_array"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_to_array"("public"."hstore")
  RETURNS "pg_catalog"."_text" AS '$libdir/hstore', 'hstore_to_array'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_to_json
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_to_json"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_to_json"("public"."hstore")
  RETURNS "pg_catalog"."json" AS '$libdir/hstore', 'hstore_to_json'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_to_json_loose
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_to_json_loose"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_to_json_loose"("public"."hstore")
  RETURNS "pg_catalog"."json" AS '$libdir/hstore', 'hstore_to_json_loose'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_to_jsonb
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_to_jsonb"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_to_jsonb"("public"."hstore")
  RETURNS "pg_catalog"."jsonb" AS '$libdir/hstore', 'hstore_to_jsonb'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_to_jsonb_loose
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_to_jsonb_loose"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_to_jsonb_loose"("public"."hstore")
  RETURNS "pg_catalog"."jsonb" AS '$libdir/hstore', 'hstore_to_jsonb_loose'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_to_matrix
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_to_matrix"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_to_matrix"("public"."hstore")
  RETURNS "pg_catalog"."_text" AS '$libdir/hstore', 'hstore_to_matrix'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hstore_version_diag
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hstore_version_diag"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."hstore_version_diag"("public"."hstore")
  RETURNS "pg_catalog"."int4" AS '$libdir/hstore', 'hstore_version_diag'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for inner_product
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."inner_product"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."inner_product"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for inner_product
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."inner_product"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."inner_product"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for inner_product
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."inner_product"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."inner_product"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for isdefined
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isdefined"("public"."hstore", text);
CREATE OR REPLACE FUNCTION "public"."isdefined"("public"."hstore", text)
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_defined'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for isexists
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isexists"("public"."hstore", text);
CREATE OR REPLACE FUNCTION "public"."isexists"("public"."hstore", text)
  RETURNS "pg_catalog"."bool" AS '$libdir/hstore', 'hstore_exists'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for ivfflat_bit_support
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ivfflat_bit_support"(internal);
CREATE OR REPLACE FUNCTION "public"."ivfflat_bit_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'ivfflat_bit_support'
  LANGUAGE c VOLATILE
  COST 1;

-- ----------------------------
-- Function structure for ivfflat_halfvec_support
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ivfflat_halfvec_support"(internal);
CREATE OR REPLACE FUNCTION "public"."ivfflat_halfvec_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'ivfflat_halfvec_support'
  LANGUAGE c VOLATILE
  COST 1;

-- ----------------------------
-- Function structure for ivfflathandler
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ivfflathandler"(internal);
CREATE OR REPLACE FUNCTION "public"."ivfflathandler"(internal)
  RETURNS "pg_catalog"."index_am_handler" AS '$libdir/vector', 'ivfflathandler'
  LANGUAGE c VOLATILE
  COST 1;

-- ----------------------------
-- Function structure for jaccard_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."jaccard_distance"(bit, bit);
CREATE OR REPLACE FUNCTION "public"."jaccard_distance"(bit, bit)
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'jaccard_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l1_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l1_distance"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."l1_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'l1_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l1_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l1_distance"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."l1_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_l1_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l1_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l1_distance"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."l1_distance"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_l1_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l2_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l2_distance"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."l2_distance"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_l2_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l2_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l2_distance"("public"."halfvec", "public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."l2_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_l2_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l2_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l2_distance"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."l2_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'l2_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l2_norm
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l2_norm"("public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."l2_norm"("public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_l2_norm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l2_norm
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l2_norm"("public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."l2_norm"("public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_l2_norm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l2_normalize
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l2_normalize"("public"."vector");
CREATE OR REPLACE FUNCTION "public"."l2_normalize"("public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'l2_normalize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l2_normalize
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l2_normalize"("public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."l2_normalize"("public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_l2_normalize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for l2_normalize
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."l2_normalize"("public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."l2_normalize"("public"."sparsevec")
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'sparsevec_l2_normalize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for populate_record
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."populate_record"(anyelement, "public"."hstore");
CREATE OR REPLACE FUNCTION "public"."populate_record"(anyelement, "public"."hstore")
  RETURNS "pg_catalog"."anyelement" AS '$libdir/hstore', 'hstore_populate_record'
  LANGUAGE c IMMUTABLE
  COST 1;

-- ----------------------------
-- Function structure for skeys
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."skeys"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."skeys"("public"."hstore")
  RETURNS SETOF "pg_catalog"."text" AS '$libdir/hstore', 'hstore_skeys'
  LANGUAGE c IMMUTABLE STRICT
  COST 1
  ROWS 1000;

-- ----------------------------
-- Function structure for slice
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."slice"("public"."hstore", _text);
CREATE OR REPLACE FUNCTION "public"."slice"("public"."hstore", _text)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_slice_to_hstore'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for slice_array
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."slice_array"("public"."hstore", _text);
CREATE OR REPLACE FUNCTION "public"."slice_array"("public"."hstore", _text)
  RETURNS "pg_catalog"."_text" AS '$libdir/hstore', 'hstore_slice_to_array'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec"("public"."sparsevec", int4, bool);
CREATE OR REPLACE FUNCTION "public"."sparsevec"("public"."sparsevec", int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_cmp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_cmp"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_cmp"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'sparsevec_cmp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_eq
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_eq"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_eq"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_eq'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_ge
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_ge"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_ge"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_ge'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_gt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_gt"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_gt"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_gt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_in
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_in"(cstring, oid, int4);
CREATE OR REPLACE FUNCTION "public"."sparsevec_in"(cstring, oid, int4)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'sparsevec_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_l2_squared_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_l2_squared_distance"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_l2_squared_distance"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_l2_squared_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_le
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_le"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_le"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_le'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_lt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_lt"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_lt"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_lt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_ne
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_ne"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_ne"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_ne'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_negative_inner_product
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_negative_inner_product"("public"."sparsevec", "public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_negative_inner_product"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_negative_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_out
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_out"("public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_out"("public"."sparsevec")
  RETURNS "pg_catalog"."cstring" AS '$libdir/vector', 'sparsevec_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_recv
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_recv"(internal, oid, int4);
CREATE OR REPLACE FUNCTION "public"."sparsevec_recv"(internal, oid, int4)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'sparsevec_recv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_send
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_send"("public"."sparsevec");
CREATE OR REPLACE FUNCTION "public"."sparsevec_send"("public"."sparsevec")
  RETURNS "pg_catalog"."bytea" AS '$libdir/vector', 'sparsevec_send'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_to_halfvec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_to_halfvec"("public"."sparsevec", int4, bool);
CREATE OR REPLACE FUNCTION "public"."sparsevec_to_halfvec"("public"."sparsevec", int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'sparsevec_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_to_vector
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_to_vector"("public"."sparsevec", int4, bool);
CREATE OR REPLACE FUNCTION "public"."sparsevec_to_vector"("public"."sparsevec", int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'sparsevec_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for sparsevec_typmod_in
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sparsevec_typmod_in"(_cstring);
CREATE OR REPLACE FUNCTION "public"."sparsevec_typmod_in"(_cstring)
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'sparsevec_typmod_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for subvector
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."subvector"("public"."halfvec", int4, int4);
CREATE OR REPLACE FUNCTION "public"."subvector"("public"."halfvec", int4, int4)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_subvector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for subvector
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."subvector"("public"."vector", int4, int4);
CREATE OR REPLACE FUNCTION "public"."subvector"("public"."vector", int4, int4)
  RETURNS "public"."vector" AS '$libdir/vector', 'subvector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for svals
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."svals"("public"."hstore");
CREATE OR REPLACE FUNCTION "public"."svals"("public"."hstore")
  RETURNS SETOF "pg_catalog"."text" AS '$libdir/hstore', 'hstore_svals'
  LANGUAGE c IMMUTABLE STRICT
  COST 1
  ROWS 1000;

-- ----------------------------
-- Function structure for tconvert
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tconvert"(text, text);
CREATE OR REPLACE FUNCTION "public"."tconvert"(text, text)
  RETURNS "public"."hstore" AS '$libdir/hstore', 'hstore_from_text'
  LANGUAGE c IMMUTABLE
  COST 1;

-- ----------------------------
-- Function structure for update_updated_at_column
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."update_updated_at_column"();
CREATE OR REPLACE FUNCTION "public"."update_updated_at_column"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
BEGIN
    NEW.update_time = now();
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for uuid_generate_v1
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1"();
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v1"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v1mc
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1mc"();
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v1mc"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1mc'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v3
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v3"("namespace" uuid, "name" text);
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v3"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v3'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v4"();
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v4"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v4'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v5
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v5"("namespace" uuid, "name" text);
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v5"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v5'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_nil
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_nil"();
CREATE OR REPLACE FUNCTION "public"."uuid_nil"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_nil'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_dns
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_dns"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_dns"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_dns'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_oid"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_oid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_url
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_url"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_url"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_url'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_x500
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_x500"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_x500"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_x500'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector"("public"."vector", int4, bool);
CREATE OR REPLACE FUNCTION "public"."vector"("public"."vector", int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_accum
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_accum"(_float8, "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_accum"(_float8, "public"."vector")
  RETURNS "pg_catalog"."_float8" AS '$libdir/vector', 'vector_accum'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_add
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_add"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_add"("public"."vector", "public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_add'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_avg
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_avg"(_float8);
CREATE OR REPLACE FUNCTION "public"."vector_avg"(_float8)
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_avg'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_cmp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_cmp"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_cmp"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'vector_cmp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_combine
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_combine"(_float8, _float8);
CREATE OR REPLACE FUNCTION "public"."vector_combine"(_float8, _float8)
  RETURNS "pg_catalog"."_float8" AS '$libdir/vector', 'vector_combine'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_concat
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_concat"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_concat"("public"."vector", "public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_concat'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_dims
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_dims"("public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_dims"("public"."vector")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'vector_dims'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_dims
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_dims"("public"."halfvec");
CREATE OR REPLACE FUNCTION "public"."vector_dims"("public"."halfvec")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'halfvec_vector_dims'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_eq
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_eq"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_eq"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_eq'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_ge
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_ge"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_ge"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_ge'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_gt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_gt"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_gt"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_gt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_in
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_in"(cstring, oid, int4);
CREATE OR REPLACE FUNCTION "public"."vector_in"(cstring, oid, int4)
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_l2_squared_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_l2_squared_distance"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_l2_squared_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'vector_l2_squared_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_le
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_le"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_le"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_le'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_lt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_lt"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_lt"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_lt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_mul
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_mul"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_mul"("public"."vector", "public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_mul'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_ne
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_ne"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_ne"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_ne'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_negative_inner_product
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_negative_inner_product"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_negative_inner_product"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'vector_negative_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_norm
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_norm"("public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_norm"("public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'vector_norm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_out
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_out"("public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_out"("public"."vector")
  RETURNS "pg_catalog"."cstring" AS '$libdir/vector', 'vector_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_recv
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_recv"(internal, oid, int4);
CREATE OR REPLACE FUNCTION "public"."vector_recv"(internal, oid, int4)
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_recv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_send
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_send"("public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_send"("public"."vector")
  RETURNS "pg_catalog"."bytea" AS '$libdir/vector', 'vector_send'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_spherical_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_spherical_distance"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_spherical_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'vector_spherical_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_sub
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_sub"("public"."vector", "public"."vector");
CREATE OR REPLACE FUNCTION "public"."vector_sub"("public"."vector", "public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_sub'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_to_float4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_to_float4"("public"."vector", int4, bool);
CREATE OR REPLACE FUNCTION "public"."vector_to_float4"("public"."vector", int4, bool)
  RETURNS "pg_catalog"."_float4" AS '$libdir/vector', 'vector_to_float4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_to_halfvec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_to_halfvec"("public"."vector", int4, bool);
CREATE OR REPLACE FUNCTION "public"."vector_to_halfvec"("public"."vector", int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'vector_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_to_sparsevec
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_to_sparsevec"("public"."vector", int4, bool);
CREATE OR REPLACE FUNCTION "public"."vector_to_sparsevec"("public"."vector", int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'vector_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for vector_typmod_in
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."vector_typmod_in"(_cstring);
CREATE OR REPLACE FUNCTION "public"."vector_typmod_in"(_cstring)
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'vector_typmod_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."document_entity_id_seq"
OWNED BY "public"."document_entity"."id";
SELECT setval('"public"."document_entity_id_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."system_permission_id_seq"
OWNED BY "public"."system_permission"."id";
SELECT setval('"public"."system_permission_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."system_role_id_seq"
OWNED BY "public"."system_role"."id";
SELECT setval('"public"."system_role_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."system_role_permission_id_seq"
OWNED BY "public"."system_role_permission"."id";
SELECT setval('"public"."system_role_permission_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."system_user_id_seq"
OWNED BY "public"."system_user"."id";
SELECT setval('"public"."system_user_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."system_user_role_id_seq"
OWNED BY "public"."system_user_role"."id";
SELECT setval('"public"."system_user_role_id_seq"', 1, false);

-- ----------------------------
-- Indexes structure for table chat_conversation
-- ----------------------------
CREATE INDEX "idx_chat_conversation_user_id" ON "public"."chat_conversation" USING btree (
  "user_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table chat_conversation
-- ----------------------------
CREATE TRIGGER "update_chat_conversation_updated_at" BEFORE UPDATE ON "public"."chat_conversation"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table chat_conversation
-- ----------------------------
ALTER TABLE "public"."chat_conversation" ADD CONSTRAINT "chat_conversation_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table chat_message
-- ----------------------------
CREATE INDEX "idx_chat_message_conversation_id" ON "public"."chat_message" USING btree (
  "conversation_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table chat_message
-- ----------------------------
CREATE TRIGGER "update_chat_message_updated_at" BEFORE UPDATE ON "public"."chat_message"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table chat_message
-- ----------------------------
ALTER TABLE "public"."chat_message" ADD CONSTRAINT "chat_message_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table document_entity
-- ----------------------------
CREATE INDEX "idx_document_entity_base_id" ON "public"."document_entity" USING btree (
  "base_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table document_entity
-- ----------------------------
CREATE TRIGGER "update_document_entity_updated_at" BEFORE UPDATE ON "public"."document_entity"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table document_entity
-- ----------------------------
ALTER TABLE "public"."document_entity" ADD CONSTRAINT "document_entity_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table knowledge_base
-- ----------------------------
CREATE TRIGGER "update_knowledge_base_updated_at" BEFORE UPDATE ON "public"."knowledge_base"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table knowledge_base
-- ----------------------------
ALTER TABLE "public"."knowledge_base" ADD CONSTRAINT "knowledge_base_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table origin_file_source
-- ----------------------------
CREATE INDEX "idx_origin_file_source_md5" ON "public"."origin_file_source" USING btree (
  "md5" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table origin_file_source
-- ----------------------------
CREATE TRIGGER "update_origin_file_source_updated_at" BEFORE UPDATE ON "public"."origin_file_source"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table origin_file_source
-- ----------------------------
ALTER TABLE "public"."origin_file_source" ADD CONSTRAINT "origin_file_source_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table system_permission
-- ----------------------------
CREATE TRIGGER "update_system_permission_updated_at" BEFORE UPDATE ON "public"."system_permission"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table system_permission
-- ----------------------------
ALTER TABLE "public"."system_permission" ADD CONSTRAINT "system_permission_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table system_role
-- ----------------------------
CREATE TRIGGER "update_system_role_updated_at" BEFORE UPDATE ON "public"."system_role"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table system_role
-- ----------------------------
ALTER TABLE "public"."system_role" ADD CONSTRAINT "system_role_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table system_role_permission
-- ----------------------------
CREATE TRIGGER "update_system_role_permission_updated_at" BEFORE UPDATE ON "public"."system_role_permission"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table system_role_permission
-- ----------------------------
ALTER TABLE "public"."system_role_permission" ADD CONSTRAINT "system_role_permission_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table system_user
-- ----------------------------
CREATE TRIGGER "update_system_user_updated_at" BEFORE UPDATE ON "public"."system_user"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table system_user
-- ----------------------------
ALTER TABLE "public"."system_user" ADD CONSTRAINT "system_user_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table system_user_role
-- ----------------------------
CREATE TRIGGER "update_system_user_role_updated_at" BEFORE UPDATE ON "public"."system_user_role"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table system_user_role
-- ----------------------------
ALTER TABLE "public"."system_user_role" ADD CONSTRAINT "system_user_role_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table vector_store
-- ----------------------------
CREATE INDEX "spring_ai_vector_index" ON "public"."vector_store" (
  "embedding" "public"."vector_cosine_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table vector_store
-- ----------------------------
ALTER TABLE "public"."vector_store" ADD CONSTRAINT "vector_store_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table chat_conversation
-- ----------------------------
ALTER TABLE "public"."chat_conversation" ADD CONSTRAINT "chat_conversation_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."system_user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table document_entity
-- ----------------------------
ALTER TABLE "public"."document_entity" ADD CONSTRAINT "document_entity_base_id_fkey" FOREIGN KEY ("base_id") REFERENCES "public"."knowledge_base" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table system_role_permission
-- ----------------------------
ALTER TABLE "public"."system_role_permission" ADD CONSTRAINT "system_role_permission_permission_id_fkey" FOREIGN KEY ("permission_id") REFERENCES "public"."system_permission" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."system_role_permission" ADD CONSTRAINT "system_role_permission_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."system_role" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table system_user_role
-- ----------------------------
ALTER TABLE "public"."system_user_role" ADD CONSTRAINT "system_user_role_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."system_role" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."system_user_role" ADD CONSTRAINT "system_user_role_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."system_user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
