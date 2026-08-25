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

 Date: 09/05/2026 21:59:07
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
-- Sequence structure for content_tag_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."content_tag_id_seq";
CREATE SEQUENCE "public"."content_tag_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for content_tag_relation_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."content_tag_relation_id_seq";
CREATE SEQUENCE "public"."content_tag_relation_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

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
  "updater" varchar(255) COLLATE "pg_catalog"."default",
  "knowledge_base_id" varchar(255) COLLATE "pg_catalog"."default"
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

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS "public"."comment";
CREATE TABLE "public"."comment" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "content_id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "content_type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "avatar" text COLLATE "pg_catalog"."default",
  "author" varchar(255) COLLATE "pg_catalog"."default",
  "user_id" varchar(255) COLLATE "pg_catalog"."default",
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "parent_id" varchar(32) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default",
  "is_recommend" bool DEFAULT false,
  "status" varchar(20) COLLATE "pg_catalog"."default" DEFAULT 'approved'::character varying
)
;
COMMENT ON COLUMN "public"."comment"."id" IS '评论ID';
COMMENT ON COLUMN "public"."comment"."content_id" IS ' 关联内容ID';
COMMENT ON COLUMN "public"."comment"."content_type" IS '内容类型（article/game/study/video）';
COMMENT ON COLUMN "public"."comment"."avatar" IS '评论 者头像';
COMMENT ON COLUMN "public"."comment"."author" IS '评论 者昵称';
COMMENT ON COLUMN "public"."comment"."user_id" IS '评论者用户ID';
COMMENT ON COLUMN "public"."comment"."content" IS '评论内容';
COMMENT ON COLUMN "public"."comment"."parent_id" IS '父评论ID（用于回复，顶级评论为NULL）';
COMMENT ON COLUMN "public"."comment"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."comment"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."comment"."deleted" IS '是否删除';
COMMENT ON COLUMN "public"."comment"."creator" IS '创建人';
COMMENT ON COLUMN "public"."comment"."updater" IS '更新人';
COMMENT ON COLUMN "public"."comment"."status" IS '审核状态：pending/approved/rejected';
COMMENT ON TABLE "public"."comment" IS '评论表';

-- ----------------------------
-- Records of comment
-- ----------------------------

-- ----------------------------
-- Table structure for content
-- ----------------------------
DROP TABLE IF EXISTS "public"."content";
CREATE TABLE "public"."content" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "title" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "category" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "cover" text COLLATE "pg_catalog"."default",
  "content" text COLLATE "pg_catalog"."default",
  "comment_count" int4 DEFAULT 0,
  "view_count" int4 DEFAULT 0,
  "is_recommend" bool DEFAULT false,
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default",
  "video_type" varchar(10) COLLATE "pg_catalog"."default",
  "video_url" varchar(500) COLLATE "pg_catalog"."default",
  "video_duration" int4,
  "content_type" varchar(20) COLLATE "pg_catalog"."default" DEFAULT 'article'::character varying
)
;
COMMENT ON COLUMN "public"."content"."id" IS '内容ID';
COMMENT ON COLUMN "public"."content"."title" IS '标题';
COMMENT ON COLUMN "public"."content"."description" IS '简介/描述';
COMMENT ON COLUMN "public"."content"."category" IS '分
类（article-文章, game-游戏, study-学习, video-视频）';
COMMENT ON COLUMN "public"."content"."cover" IS '封面图片URL';
COMMENT ON COLUMN "public"."content"."content" IS '正文内容（HTML格式）';
COMMENT ON COLUMN "public"."content"."comment_count" IS '评论数';
COMMENT ON COLUMN "public"."content"."view_count" IS ' 浏览量';
COMMENT ON COLUMN "public"."content"."is_recommend" IS '是否推荐';
COMMENT ON COLUMN "public"."content"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."content"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."content"."deleted" IS '是否删除';
COMMENT ON COLUMN "public"."content"."creator" IS '创建人';
COMMENT ON COLUMN "public"."content"."updater" IS '更新人';
COMMENT ON TABLE "public"."content" IS '内容表（文章/游戏/学习/视频）';

-- ----------------------------
-- Records of content
-- ----------------------------
INSERT INTO "public"."content" VALUES ('48f3d313bf923e3b34e9f60ce7ab3521', 'Vue引入第三方_03', 'Vue项目中引入开源滑动插件Swiper，可实现触屏轮播、Tab切换等移动端交互效果，支持通过npm安装指定版本。', 'study', 'http://118.89.135.164:9000/content-covers/cover_1778325427551.png', '

#### Vue引入第三方

==Swiper==开源、免费、强大的触摸滑动插件

==Swiper==是纯JavaScript打造的滑动特效插件，面向手机、平板电脑等移动终端

==Swiper==能是实现触屏焦点图、触屏Tab切换、触屏轮播图切换等常用效果

> **温馨提示**
>
> 官方文档：https://swiperjs.com/vue
>
> 安装指定版本：‘npm install –save swiper@8.1.6 ’

##### 基础实现


![image-20240821224247128.png](http://118.89.135.164:9000/default/content/image_f31d9741-14c6-4df2-aecf-5b177754c7ae.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T094122Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=0f9b8e39e99dbcdb65013dda974318ae97b62304e2a0c4ff1e7c2e20b36b3553)
', 0, 1, 'f', '2026-05-09 17:41:30.805716', '2026-05-09 20:44:14.367807', 'f', NULL, NULL, 'file', '', 0, 'article');
INSERT INTO "public"."content" VALUES ('a7112d26f42cc038d74bdd5980b00314', 'Claude的部署和配置', '本文介绍如何在无代理环境下部署 Claude CLI 工具，并配置国内中转或第三方模型，包含 Node.js 安装、Claude Code 安装及绕过登录限制等步骤。', 'study', 'http://118.89.135.164:9000/content-covers/cover_1778330244718.png', '下面分两部分：**1. 安装 Claude Code（CLI）**、**2. 安装 CCSwitch + 配置国内中转/第三方模型**，全程尽量无魔法、可直接复制命令。

---

## 一、安装 Claude Code（CLI）
### 1. 前提
- 安装 Node.js（推荐 v20+）：https://nodejs.org/
- 验证：
  ```bash
  node -v
  npm -v
  ```

### 2. 安装 Claude Code
```bash
npm i -g @anthropic-ai/claude-code@latest
```
- 验证安装：
  ```bash
  claude-code --version
  # 或简写
  claude --version
  ```
- 若提示权限错误（Windows 用管理员终端，macOS/Linux 加 sudo）：
  ```bash
  sudo npm i -g @anthropic-ai/claude-code@latest
  ```

### 3. 绕过初始登录（国内必做）
编辑/创建 `~/.claude.json`（Windows：`C:\Users\你的用户名\.claude.json`），写入：
```json
{
  "hasCompletedOnboarding": true
}
```
保存后，直接在任意文件夹运行：
```bash
claude
```
即可进入对话，不会再要求登录。

---

## 二、安装 CCSwitch（跨平台）
### 1. Windows 安装
- 下载：https://github.com/farion1231/cc-switch/releases
  - 选 `.msi` 安装包 或 便携版 `.zip`
- 双击安装，一路默认即可。


### 2. macOS 安装（推荐 Homebrew）
```bash
brew tap farion1231/ccswitch
brew install --cask cc-switch
```
- 启动：`Launchpad → CC Switch`

### 3. Linux 安装
- 下载对应包（`.deb`/`.rpm`/`.AppImage`），安装后运行。

---

## 三、CCSwitch 配置（国内中转/第三方模型）
### 1. 打开 CCSwitch 主界面
- 第一次运行会自动检测 Claude Code 路径，确认即可。


### 2. 添加模型提供商（核心）
点击右上角 **+（Add Provider）**，有两种方式：

#### 方式 A：用预设（推荐，如 GLM、MiniMax、DeepSeek 等）
1. 预设列表选供应商（如 `Zhipu GLM`）
2. 填写：
   - Provider Name：自定义（如 `glm-5.1`）
   - API Key：你的平台密钥（如智谱/ MiniMax 官网创建）
   - Model：模型名（如 `glm-5.1`）
3. 点 **Add** 保存。

#### 方式 B：自定义中转（如通用 OpenAI 格式中转）
1. 预设选 **Custom（自定义）**
2. 按以下填写（以某中转为例）：
   - Provider Name：`my-proxy`
   - Base URL：`https://xxx.xxx.com/v1`（**末尾不要加 /**）
   - API Key：`sk-xxxxxx`（中转平台给的 key）
   - API 格式：选 **OpenAI Chat Completions**（关键，自动适配 Claude）
   - 认证字段：默认 `ANTHROPIC_AUTH_TOKEN`
   - 模型映射（可选）：
     - Sonnet：`claude-sonnet-4-6`
     - Haiku：`claude-haiku-4-5`
3. 保存。


### 3. 启用配置
- 在供应商列表选中刚添加的项 → 点 **Enable** → 状态变为 **Active** 即生效。
- 切换后**无需重启 Claude**，直接用：
  ```bash
  claude
  ```


### 4. VS Code / Cursor 插件联动（可选）
1. 在 VS Code 安装插件：`Claude Code for VS Code`

2. 打开 CCSwitch → 设置 → 勾选 **应用到 Claude Code 插件**
3. 之后在 CCSwitch 切换模型，插件自动同步，无需手动改配置。

---

## 四、常用国内模型快速配置（参考）
### 1. 智谱 GLM（推荐）
- 注册：https://open.bigmodel.cn/
- 创建 API Key，CCSwitch 预设选 `Zhipu GLM`，填 Key + 模型 `glm-5.1`。

### 2. MiniMax
- 注册：https://platform.minimaxi.com/
- 创建 Key，预设选 `MiniMax`，模型填 `abab6.5-chat`。

### 3. 哈基米中转（免费额度）
- 注册：https://hkm.sx/
- 创建令牌，复制 API Key，自定义配置：
  - Base URL：`https://api.hkm.sx/v1`
  - API Key：`你的密钥`
  - 格式：`OpenAI Chat Completions`

---

## 五、验证是否成功
```bash
claude
# 随便问一句话，能正常回复即成功
```

---

## 六、常见问题
1. **提示“not authenticated”**：检查 `~/.claude.json` 是否有 `hasCompletedOnboarding: true`。
2. **超时/连接失败**：
   - Base URL 末尾**不要加 /**
   - 换国内中转（如哈基米、智谱）
3. **模型名报错**：在 CCSwitch 高级选项里，把 Claude 默认模型映射到你实际可用的模型。

---', 0, 0, 'f', '2026-05-09 20:32:42.309926', '2026-05-09 20:43:43.949054', 'f', NULL, NULL, 'file', '', 0, 'article');
INSERT INTO "public"."content" VALUES ('1e4c91fbb8e0824516519d6dc879c2ee', '一件叛逆的大事——吸烟', '一群少年出于好奇，在秋日午后用作业本和干玉米秸秆自制“香烟”尝试吸烟，体验叛逆与成长的微妙时刻。', 'life', 'http://118.89.135.164:9000/content-covers/cover_1778325802855.png', '也不知道你们抽过烟没有？反正我是抽过！不是吸别人的二手烟，而是真的自己点了，抽了！在我的认知里面，小孩子吸烟是一件很严重的事，如果被父母发现肯定要挨一顿骂！但是大人很多都在吸烟，这也免不了压抑在我们心中的好奇。小时候的我似乎是十分胆小，很多事情都不敢去做。

一个晴朗的下午，那时候的太阳好像很明媚，但是并不燥热。我们在王可莹家的附近，他的爷爷是一位老师，十分和蔼。有机会之后再讲。也不知道是几岁（我猜是12岁左右吧），反正很小就对了，我们一群人，有哪些人也记不清了。也不知道是谁突发奇想，我们尝试一下抽烟吧！应该是很突然吧，当时的我们只有一个打火机，我们还缺什么，一根香烟。我们总不能去找大人要一根吧，不被打死就怪了！这个没有的话，就准备想想其他办法。香烟是由什么组成的，它是被一张纸包着，里面有被晒干的植物的尸体——干草。我们就去找材料，就近一个朋友家，撕下了他的作业本。干草要去哪里找呢？外面不到处都是吗？我们找到了已经脱干水分shuo在墙边的玉米秸秆，我们小心翼翼的摘下它的一根纸条，再缓慢的碾碎它，发出了独属那个季节的声音，突然想起来应该是秋天，暑假。

将碾碎的干草卷进了作业本中，然后用口水封住不让他展开。紧接着，便是吸烟中的最重要的一步，点燃它。掏出了小超市五毛钱一支的打火机，在一声清脆的可啪（拟声，字对不对别介意）下，那支香烟（作业本卷的干草）被我们点燃了，它似香烟一样冒着火星，我心中的叛逆藏在里面，如同心脏一般有韵律的闪烁着。他们一个接一个的贪婪着小小的叛逆，紧接着发出了剧烈的咳嗽，在我们害怕、紧张的心情下，转瞬即逝。

可轮到我的时候，我却迟疑了，现在的我也迟疑了，因为我已经记不清我到底有没有尝试那被作业本卷的干草。现在的我认为当时的我不敢，对，是不敢。或许我猜对了，也或许没猜对，可它一直留在我的记忆中，只要想到就会闪烁出来的画面，让我也无法追寻。无所谓了，因为在乎的，可能只有当时的我吧！', 0, 0, 'f', '2026-05-09 19:23:12.895638', '2026-05-09 20:44:07.479623', 'f', NULL, NULL, 'file', '', 0, 'article');
INSERT INTO "public"."content" VALUES ('6036ba2661a514b7f646a3f84e9f8ccb', '乌海之行——骑行', '乌海骑行之旅，是宁夏大学生第八届五一内蒙骑行活动，象征挣脱束缚、奔赴自由的青春约定。', 'article', 'http://118.89.135.164:9000/default/content/cover_d49db078-330f-4fcd-9174-3184e011cd24.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T112911Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=d71a35f9d62f52ce535471d3dee4edce25aad1ed40e241d63d1d6098cf62cfec', '乌海之行，我觉得不是偶然，而是必然，是图谋已久的的叛逆。当车轮碾过风沙，当帐篷扎进沙丘，我们终于明白 ——人生从来不是预设好的轨道，而是一片可以自由驰骋的旷野。
![微信图片_20260509193343_349_49.jpg](http://118.89.135.164:9000/default/content/image_ef27f169-111b-42ef-a764-f85b1f6a8e39.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T113406Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=eeb129310a7f0ab505cb113baae747e4ca731908a6f44236bf48d34502f7d6db)

这是宁夏大学生第 8 届五一内蒙骑行，也是我们跨越山海奔赴乌海的约定。从银川到乌海，百公里的路程里，有斜坡的陡峭，有滑坡的惊险，更有风沙里并肩前行的温暖。累计超 1000 人曾踏上这段旅程，有人为了挑战自我，有人为了遇见风景，也有人，只是想在旷野里，找回最真实的自己。
![微信图片_20260309135441_242_49.jpg](http://118.89.135.164:9000/default/content/image_9af59b41-3ca4-4e40-adaa-95ae5460e909.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T113055Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=75bf2be410073887e1300e9d9aed548c0a11e766dc300f59895a20a23abd8d1a)
![微信图片_20260509192637_346_49.jpg](http://118.89.135.164:9000/default/content/image_808ac6a2-b8ce-407b-883b-aa5ed7915cdc.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T112810Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=63877be98f06e69fb8206368bc8260df1f39f374b7f4c3ff6cc5df1666a485f0)

![微信图片_20260509192655_347_49.jpg](http://118.89.135.164:9000/default/content/image_7a8246a6-ca7e-4272-b58f-10a602a3eaef.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T112820Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=7480b894642b48d6088fd531066b0e8b5ae4ac1fbdcc2ac006cc76a58135c1bd)

![微信图片_20260509192726_348_49.jpg](http://118.89.135.164:9000/default/content/image_f73cf8f2-f4e6-4cca-bc0f-7f1d537bf8f2.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T112831Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=a6b6f295d037c74401e405d1c473bc2348a8930e076bdd4e2a1463282c1138db)


#### 🌪️ 风沙里的奔赴，是青春最滚烫的注脚
我们租来全新的单车，背上帐篷与行囊，在后勤车的陪伴下出发。没有精致的装备，没有舒适的旅途，只有车轮与地面的摩擦声，和耳边呼啸的风沙。
有人第一次骑行百公里，腿酸到发抖却不肯停下；有人在无人区里信号全失，却笑着说 “正好可以专心看风景”；我们在沙坡上滑沙、放风筝，在篝火晚会上唱歌、拔河，看牛羊与骆驼从眼前走过，追着初阳与落日按下快门。
沙子倒不完，信号收不到，照片发不完 —— 这是属于旷野的浪漫，也是青春最鲜活的模样。
#### 🚲 分队不分家，我们是彼此的旷野同行者
20 支队伍，几十位队长，几百个陌生的我们，因为同一份热爱聚在一起。物资统一采购，饭菜一起分享，修车时搭把手，迷路时互相指引。
男生主动扛起重物，女生细心照顾同伴，有人在途中收获了友情，有人甚至遇见了爱情 —— 就像第四届骑行里促成的 13 对情侣，旷野从不设限，缘分也从不缺席。我们签好免责协议，买好保险，听从指挥，因为我们知道：在这片旷野里，彼此就是最可靠的依靠。
#### 🌅 当我们站在沙丘上，才懂旷野的意义
夕阳把我们的影子拉得很长，有人举着旗帜，有人比着剪刀手，有人只是静静望着远方。
我们曾以为人生要按部就班，要在既定的轨道上奔跑，直到来到乌海的沙漠才发现：原来可以不用赶时间，不用怕犯错，不用在意别人的眼光。斜坡可以慢慢爬，滑坡可以小心过，百公里的路可以一步步骑，就像人生，从来没有标准答案。
#### ✨ 写给每一个在路上的你
如果你也困在轨道里，如果你也想看看不一样的风景，不妨来一次旷野之行吧。
去骑一次百公里的单车，去住一次沙漠里的帐篷，去追一次没有信号的日落。你会发现：人生不是轨道，而是旷野—— 你可以走向任何方向，成为任何想成为的人。
下一次，我们还在旷野等你。', 0, 5, 't', '2026-05-09 19:38:03.00716', '2026-05-09 21:29:54.614232', 'f', NULL, NULL, 'file', '', 0, 'article');
INSERT INTO "public"."content" VALUES ('99de532e662e1c0363dfd79bcfe63173', '脱脂牛马', '“脱脂牛马”倡导摆脱内耗与盲目内卷，卸下焦虑与讨好，学会爱自己、松弛生活，在清醒中找回真实的自我。', 'life', 'http://118.89.135.164:9000/content-covers/cover_1778327264780.png', '何为脱脂牛马？不再盲目内耗、不再无脑内卷，不再被生活推着硬扛所有压力；褪去无谓的焦虑、多余的讨好、没必要的逞强，做清醒、松弛、懂得爱自己的普通人。

从前我们都做惯了普通牛马，被生活裹挟，被世俗定义。忙着赶路，忙着迎合，忙着追赶别人的节奏；委屈往心里咽，压力自己默默扛，习惯性透支身体、消耗情绪，把懂事、隐忍、拼命活成了常态。以为埋头奔跑就是成长，却在日复一日的奔波里，弄丢了自己，胖了心事，累垮了心态，满身疲惫却无从安放。

而脱脂，就是一场自我救赎。

脱脂，是戒掉精神内耗。不再纠结别人的评价，不纠结未发生的琐事，不翻旧账、不胡思乱想。接纳自己的平凡，允许自己做不到、允许自己偶尔偷懒，不必事事完美，不必人人喜欢。

脱脂，是卸下无效负重。远离消耗自己的人际关系，舍弃没必要的应酬，放下不属于自己的执念。人生本就不必事事勉强，合得来就相伴，道不同就随缘走远，把时间留给值得的人和事。

脱脂，是学会适度摆烂，认真生活。不是躺平放弃，而是不再盲目内卷、跟风攀比。别人跑得快，我们可以慢慢走；别人追名逐利，我们可以安于平淡。该努力时全力以赴，该休息时坦然放空，劳逸结合，张弛有度，不透支健康，不辜负自己。
做脱脂牛马，看淡世事繁杂，守住内心平静。不用强迫自己活成万众期待的样子，不用在轨道里循规蹈矩。就像乌海旷野之行感悟的那样：人生从不是既定轨道，而是肆意生长的旷野。

往后余生，褪去浮躁，脱脂前行。少一点逞强，多一点自愈；少一点纠结，多一点松弛；做个清醒通透的脱脂牛马，好好生活，慢慢发光，自在随心，安稳度日。', 0, 0, 'f', '2026-05-09 19:47:33.684678', '2026-05-09 20:44:00.440617', 'f', NULL, NULL, 'file', '', 0, 'article');
INSERT INTO "public"."content" VALUES ('4c8ec4fc2213afd8ec9cab074f9f4433', ' Axios网络请求_04', '本文介绍了Axios这一基于Promise的网络请求库，涵盖其安装、引入方式及GET/POST请求的基本用法，并提示POST请求需额外处理参数格式。', 'study', 'http://118.89.135.164:9000/content-covers/cover_1778329738948.png', 'Axios是一个基于promise的网络请求库。

##### 安装

Axios的应用是需要单独安装的==npm install –save axios==

##### 引入

组件中引入：==import axios from “axios”==

全局引用

##### 网络请求基本示例

###### get请求

###### post请求

> **温馨提示**
>
> post请求参数是需要额外处理的
>
> > 安装依赖： ==npm install –save querystring==
> >
> > 转换参数格式：==qs.stringify({})==


##### 快捷方案

###### get请求

###### post请求', 0, 1, 'f', '2026-05-09 17:43:32.56107', '2026-05-09 20:44:10.858077', 'f', NULL, NULL, 'file', '', 0, 'article');
INSERT INTO "public"."content" VALUES ('6db9731424dc6cf1753a7e727d1371dd', '一件叛逆的大事——吸烟', '一群少年出于好奇，用作业本和干玉米秸秆自制“香烟”尝试吸烟，记录下童年一次叛逆而天真的冒险。', 'article', 'content-covers/cover_1778243596183.png', '也不知道你们抽过烟没有？反正我是抽过！不是吸别人的二手烟，而是真的自己点了，抽了！在我的认知里面，小孩子吸烟是一件很严重的事，如果被父母发现肯定要挨一顿骂！但是大人很多都在吸烟，这也免不了压抑在我们心中的好奇。小时候的我似乎是十分胆小，很多事情都不敢去做。

一个晴朗的下午，那时候的太阳好像很明媚，但是并不燥热。我们在王可莹家的附近，他的爷爷是一位老师，十分和蔼。有机会之后再讲。也不知道是几岁（我猜是12岁左右吧），反正很小就对了，我们一群人，有哪些人也记不清了。也不知道是谁突发奇想，我们尝试一下抽烟吧！应该是很突然吧，当时的我们只有一个打火机，我们还缺什么，一根香烟。我们总不能去找大人要一根吧，不被打死就怪了！这个没有的话，就准备想想其他办法。香烟是由什么组成的，它是被一张纸包着，里面有被晒干的植物的尸体——干草。我们就去找材料，就近一个朋友家，撕下了他的作业本。干草要去哪里找呢？外面不到处都是吗？我们找到了已经脱干水分shuo在墙边的玉米秸秆，我们小心翼翼的摘下它的一根纸条，再缓慢的碾碎它，发出了独属那个季节的声音，突然想起来应该是秋天，暑假。

将碾碎的干草卷进了作业本中，然后用口水封住不让他展开。紧接着，便是吸烟中的最重要的一步，点燃它。掏出了小超市五毛钱一支的打火机，在一声清脆的可啪（拟声，字对不对别介意）下，那支香烟（作业本卷的干草）被我们点燃了，它似香烟一样冒着火星，我心中的叛逆藏在里面，如同心脏一般有韵律的闪烁着。他们一个接一个的贪婪着小小的叛逆，紧接着发出了剧烈的咳嗽，在我们害怕、紧张的心情下，转瞬即逝。

可轮到我的时候，我却迟疑了，现在的我也迟疑了，因为我已经记不清我到底有没有尝试那被作业本卷的干草。现在的我认为当时的我不敢，对，是不敢。或许我猜对了，也或许没猜对，可它一直留在我的记忆中，只要想到就会闪烁出来的画面，让我也无法追寻。无所谓了，因为在乎的，可能只有当时的我吧！', 0, 1, 'f', '2026-05-08 20:33:18.733222', '2026-05-09 17:07:03.034627', 't', NULL, NULL, 'file', '', 0, 'article');
INSERT INTO "public"."content" VALUES ('ae81d3149f7bc743cd8b24f0d7592854', 'Vue事件处理_02', '本文介绍了Vue中的条件渲染（v-if、v-else、v-show）及其区别，并简要提及列表渲染。', 'study', 'http://118.89.135.164:9000/content-covers/cover_1778325476734.png', '#### 条件渲染

##### v-if

==v-if==指令用于渲染一块内容。这块内容只会在指令的表达式返回==true==值的时候被渲染。

##### v-else

你可以使用==v-else==指令来表示==v-if==的“else块”

##### v-show

另一个用于条件性展示元素的选项是==v-show==指令。

##### ==v-if==VS==v-show==的区别

==v-if==是“真正”的条件渲染，因为它会确保在切换过程中，条件块内的事件监听器和子组件适当地被销毁和重建。

==v-if==也是**惰性的**：如果在初始渲染时条件为假，则什么也不做—直到第一次变为真时，才会开始渲染条件块。

相比之下，==v-show==就简单得多—-不管初始条件是什么，元素总会被渲染，并且只是简单地基于CSS进行切换。

一般来说，==v-if==有更高的切换开销，而==v-show==有更高的初始渲染开销。因此，如果需要非常频繁地切换，则使用==v-show==较好；如果在运行时条件很少改变，则使用==v-if==较好。

#### 列表渲染

##### 用==v-for==把一个数组映射为一组元素

我们可以用==v-for==指令基于一个数组来渲染一个列表。==v-for==需要使用==item in items==形式的特殊语法，其中items是源数据数组，而==item==则是被迭代的数组元素的**别名**。

##### 维护状态

当Vue正在更新使用==v-for==渲染的元素列表时，它默认使用“就地更新”的策略。如果数据项的顺序被改变，Vue将不会移动DOM元素来匹配数据项的顺序，而是就地更新每个元素，并且确保它们在每个索引位置正确渲染。

为了给Vue一个提示，以便它能跟踪每个节点的身份，从而重用和重新排序现有元素，你需要为每项提供一个唯一的==key==attribute：



#### 事件处理

##### 监听事件

我们可以使用==v-on==指令（通常缩写为==@==符号）来监听DOM事件，并在触发事件时执行一些JavaScript。用法为==v-on:click=“methodName”==或使用快捷方式==@click=“methodName”==

##### 事件处理方法

然而许多事件处理逻辑会更为复杂，所以直接把JavaScript代码写在==v-on==指令中是不可行的。因此==v-on==还可以接收一个需要调用的方法名称。


##### 内联处理器中的方法

这是官方的翻译称呼，其实我们可以直接叫他“事件传递参数”


#### 表单输入绑定

你可以用==v-model==指令在表单==<input>==、==<textarea>==及==<select>==元素上创建双向数据绑定。它会根据控件类型自动选取正确的方法来更新元素。尽管有些神奇，但==v-model==本质上不过是语法糖。它负责监听用户的输入事件来更新数据，并在某种极端场景下进行一些特殊处理。


##### ==.lazy==

在默认情况下，==v-model==在每次==input==事件触发后将输入框的值与数据进行同步。你可以添加==lazy==修饰符，从而转化在==change==事件之后进行同步


##### ==.trim==

如果要自动过滤用户输入的首尾空白字符，可以给==v-model==添加==.trim==修饰符


#### 组件基础

##### 单文件组件

Vue单文件组件（又名==*.vue==文件，缩写为**SFC**）是一种特殊的文件格式，它允许将Vue组件的模板、逻辑**与**样式封装在单个文件中

![image-20240821111337621](C:\Users\15839\AppData\Roaming\Typora\typora-user-images\image-20240821111337621.png)

##### 加载组件


##### 组件的组织

通常一个应用会以一颗嵌套的组织树的形式来组织


#### Props组件交互

组件与组件之间是需要交互的，否则完全没有关系，组件之间的意义就很小了

==Prop==是你可以在组件上注册的一些自定义attribute

##### Prop类型

Prop传递参数其实是没有限制的

> **温馨提示**
>
> 数据类型为数组或者对象的时候，默认值是需要返回工厂模式

#### 自定义事件组件交互

自定义事件可以在组件中反向传递数据，==prop==可以将数据从父组件传递到子组件，那么反向如何操作呢，就可以利用自定义事件实现==$emit$== 


#### 组件的生命周期

每个组件在被创建时都要经过一系列的初始化——例如，需要设置数据监听、编译模板、将实例挂载到DOM并在数据变化时更新DOM等。同时在这个过程中也会运行一些叫做 **生命周期钩子**的函数，这给了用户在不同阶段添加自己的代码的机会

八个生命周期函数

创建时：==beforeCreate==、==created==

渲染时：==beforeMount==、==mounted==

更新时：==beforeUpdate==、==updated==

卸载时：==beforeUnmount==、==unmounted==', 0, 0, 'f', '2026-05-09 17:30:45.417445', '2026-05-09 20:44:18.477335', 'f', NULL, NULL, 'file', '', 0, 'article');
INSERT INTO "public"."content" VALUES ('2ec9d61b9ac293456d06d2d32fc0a230', 'Vue模板语法_01', '介绍Vue模板语法中的文本插值（双大括号）和原始HTML渲染（v-html指令），并展示如何在data中定义数据实现动态绑定。', 'study', 'http://118.89.135.164:9000/content-covers/cover_1778325571094.png', '### 模板语法

#### 文本

数据绑定最常见的形式就是使用“Mustache”（双大括号）语法的文本插值。

```html
<span>Message: {{ msg }}</span>
```

一般配合==js==中的==data()==设置数据

```vue
export default {
	name: ''Hello World'',
	data(){
		return{
			msg:"消息提示"
		}
	}
}
```

#### 原始HTML

双大括号会将数据解释为普通文本，而非HTML代码。为了输出真正的HTML，你需要使用==v-html==指令

```html
<p>
    Usingmustaches: {{ rawHtml }}
</p>
<P>
    Using v-html directive: <span v-html="rawHtml"></span>
</P>
```

```html
data(){
	return{
		rawHtml:"<a href=''https://www.itbaizhan.com''>百战</a>"
	}
}
```

#### 属性Attribute

Mustache语法不能在HTML属性中使用，然而，可以使用==v-bind==指令

```html
<div v-bind:id=”dynamicId“> </div>
```

```html
data(){
	return{
		dynamicId:1001
	}
}
```

#### 使用JavaScript表达式

在我们模板中，我们一直都只绑定简单的property键值，Vue.js都提供了完全的JavaScript表达式支持

```html
{{ number + 1 }}

{{ ok ? ''YES'' : ''NO'' }}

{{ message.split('''').reverse().join('''') }}
```

这些表达式在当前活动实例的数据作用域下作为JavaScript被解析。有个限制就是，每个绑定都只能包含*单个表达式*，所以下面的例子都*不会*生效。

```html
<!-- 这是语句，不是表达式 -->
{{ var a = 1 }}

<!-- 流程控制也不会生效，请使用三元表达式-->
{{ if(ok) { return message } }}
```

', 0, 2, 'f', '2026-05-09 17:14:04.277962', '2026-05-09 20:44:22.098343', 'f', NULL, NULL, 'file', '', 0, 'article');

-- ----------------------------
-- Table structure for content_tag
-- ----------------------------
DROP TABLE IF EXISTS "public"."content_tag";
CREATE TABLE "public"."content_tag" (
  "id" int8 NOT NULL DEFAULT nextval('content_tag_id_seq'::regclass),
  "name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "usage_count" int8 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "creator" varchar(50) COLLATE "pg_catalog"."default",
  "updater" varchar(50) COLLATE "pg_catalog"."default",
  "deleted" bool DEFAULT false
)
;

-- ----------------------------
-- Records of content_tag
-- ----------------------------
INSERT INTO "public"."content_tag" VALUES (2, 'TypeScript', 0, '2026-04-06 08:07:40.564589', '2026-04-06 08:07:40.564589', NULL, NULL, 'f');
INSERT INTO "public"."content_tag" VALUES (3, 'Java', 0, '2026-04-06 08:07:40.564589', '2026-04-06 08:07:40.564589', NULL, NULL, 'f');
INSERT INTO "public"."content_tag" VALUES (4, 'Spring Boot', 0, '2026-04-06 08:07:40.564589', '2026-04-06 08:07:40.564589', NULL, NULL, 'f');
INSERT INTO "public"."content_tag" VALUES (5, 'PostgreSQL', 0, '2026-04-06 08:07:40.564589', '2026-04-06 08:07:40.564589', NULL, NULL, 'f');
INSERT INTO "public"."content_tag" VALUES (6, 'Game', 0, '2026-04-06 16:25:30.58588', '2026-05-09 17:07:22.063976', NULL, NULL, 'f');
INSERT INTO "public"."content_tag" VALUES (9, 'Claude', 1, '2026-05-09 20:32:57.037725', '2026-05-09 20:43:43.972103', NULL, NULL, 'f');
INSERT INTO "public"."content_tag" VALUES (7, '自由', 2, '2026-05-08 20:33:18.771667', '2026-05-09 20:44:03.698856', NULL, NULL, 'f');
INSERT INTO "public"."content_tag" VALUES (8, '童年', 1, '2026-05-09 19:23:55.335485', '2026-05-09 20:44:07.504555', NULL, NULL, 'f');
INSERT INTO "public"."content_tag" VALUES (1, 'Vue3', 4, '2026-04-06 08:07:40.564589', '2026-05-09 20:44:22.11962', NULL, NULL, 'f');

-- ----------------------------
-- Table structure for content_tag_relation
-- ----------------------------
DROP TABLE IF EXISTS "public"."content_tag_relation";
CREATE TABLE "public"."content_tag_relation" (
  "id" int8 NOT NULL DEFAULT nextval('content_tag_relation_id_seq'::regclass),
  "content_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "tag_id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of content_tag_relation
-- ----------------------------
INSERT INTO "public"."content_tag_relation" VALUES (27, 'a7112d26f42cc038d74bdd5980b00314', 9, '2026-05-09 20:43:43.966425');
INSERT INTO "public"."content_tag_relation" VALUES (28, '99de532e662e1c0363dfd79bcfe63173', 7, '2026-05-09 20:44:00.473596');
INSERT INTO "public"."content_tag_relation" VALUES (29, '6036ba2661a514b7f646a3f84e9f8ccb', 7, '2026-05-09 20:44:03.68063');
INSERT INTO "public"."content_tag_relation" VALUES (30, '1e4c91fbb8e0824516519d6dc879c2ee', 8, '2026-05-09 20:44:07.499252');
INSERT INTO "public"."content_tag_relation" VALUES (31, '4c8ec4fc2213afd8ec9cab074f9f4433', 1, '2026-05-09 20:44:10.876808');
INSERT INTO "public"."content_tag_relation" VALUES (32, '48f3d313bf923e3b34e9f60ce7ab3521', 1, '2026-05-09 20:44:14.384104');
INSERT INTO "public"."content_tag_relation" VALUES (33, 'ae81d3149f7bc743cd8b24f0d7592854', 1, '2026-05-09 20:44:18.495338');
INSERT INTO "public"."content_tag_relation" VALUES (34, '2ec9d61b9ac293456d06d2d32fc0a230', 1, '2026-05-09 20:44:22.113597');

-- ----------------------------
-- Table structure for diary
-- ----------------------------
DROP TABLE IF EXISTS "public"."diary";
CREATE TABLE "public"."diary" (
  "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "type" varchar(32) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'diary'::character varying,
  "diary_date" varchar(64) COLLATE "pg_catalog"."default",
  "weather" varchar(64) COLLATE "pg_catalog"."default",
  "mood" varchar(64) COLLATE "pg_catalog"."default",
  "avatar" varchar(512) COLLATE "pg_catalog"."default",
  "content" text COLLATE "pg_catalog"."default",
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(64) COLLATE "pg_catalog"."default",
  "updater" varchar(64) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of diary
-- ----------------------------
INSERT INTO "public"."diary" VALUES ('29389948c45a632a7ae18d2cf839e7aa', 'diary', '2026-05-09', '晴', '紧张而急促', NULL, '明天就要答辩了，匆匆忙忙地准备着一些，打印论文，修改PPT，期待明天会有好的结果！', '2026-05-09 20:49:44.377724', '2026-05-09 20:49:44.377724', 'f', NULL, NULL);
INSERT INTO "public"."diary" VALUES ('7fce2a7f60210b99ba095adcb9343149', 'diary', '2025-07-17', '多云', '期待、害怕', NULL, '现在是大三，也是我第一次来到北京，我可以如愿找到工作吗？北京好像不太一样，怎么连路边摊都没有？', '2026-05-09 21:29:09.716881', '2026-05-09 21:29:09.716881', 'f', NULL, NULL);

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
INSERT INTO "public"."document_entity" VALUES (158, 'Claude的部署和配置_20260509_204344.md', 'knowledge-file/Claude的部署和配置_20260509_204344.md', '79a0baee5adbf82a7b29fb79f32ac551', 't', '01e64068ea7b6ae8', '2026-05-09 20:43:44.653726', '2026-05-09 20:43:44.653726', 'f', NULL, NULL);
INSERT INTO "public"."document_entity" VALUES (159, '脱脂牛马_20260509_204400.md', 'knowledge-file/脱脂牛马_20260509_204400.md', '79a0baee5adbf82a7b29fb79f32ac551', 't', 'ca90c35f146f682f', '2026-05-09 20:44:00.629331', '2026-05-09 20:44:00.629331', 'f', NULL, NULL);
INSERT INTO "public"."document_entity" VALUES (160, '乌海之行——骑行_20260509_204403.md', 'knowledge-file/乌海之行——骑行_20260509_204403.md', '79a0baee5adbf82a7b29fb79f32ac551', 't', '469ed83c331c9c83', '2026-05-09 20:44:03.991194', '2026-05-09 20:44:03.991194', 'f', NULL, NULL);
INSERT INTO "public"."document_entity" VALUES (161, '一件叛逆的大事——吸烟_20260509_204407.md', 'knowledge-file/一件叛逆的大事——吸烟_20260509_204407.md', '79a0baee5adbf82a7b29fb79f32ac551', 't', '960c7bd1c7b8b882', '2026-05-09 20:44:07.625048', '2026-05-09 20:44:07.625048', 'f', NULL, NULL);
INSERT INTO "public"."document_entity" VALUES (162, '_Axios网络请求_04_20260509_204410.md', 'knowledge-file/_Axios网络请求_04_20260509_204410.md', '79a0baee5adbf82a7b29fb79f32ac551', 't', '6a323cdabf7da6ae', '2026-05-09 20:44:11.01364', '2026-05-09 20:44:11.01364', 'f', NULL, NULL);
INSERT INTO "public"."document_entity" VALUES (163, 'Vue引入第三方_03_20260509_204414.md', 'knowledge-file/Vue引入第三方_03_20260509_204414.md', '79a0baee5adbf82a7b29fb79f32ac551', 't', '602f7d1669e86574', '2026-05-09 20:44:14.510775', '2026-05-09 20:44:14.510775', 'f', NULL, NULL);
INSERT INTO "public"."document_entity" VALUES (164, 'Vue事件处理_02_20260509_204418.md', 'knowledge-file/Vue事件处理_02_20260509_204418.md', '79a0baee5adbf82a7b29fb79f32ac551', 't', '250fdbc3c950ee65', '2026-05-09 20:44:18.694316', '2026-05-09 20:44:18.694316', 'f', NULL, NULL);
INSERT INTO "public"."document_entity" VALUES (165, 'Vue模板语法_01_20260509_204422.md', 'knowledge-file/Vue模板语法_01_20260509_204422.md', '79a0baee5adbf82a7b29fb79f32ac551', 't', 'da816f36e2726f39', '2026-05-09 20:44:22.250385', '2026-05-09 20:44:22.250385', 'f', NULL, NULL);

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
INSERT INTO "public"."knowledge_base" VALUES ('d56fde16e3279adeb167b386982b013f', '个人知识库', '埋藏我的人生', '2026-03-14 14:51:34.851975', '2026-03-14 14:51:34.851975', 'f', NULL, NULL);

-- ----------------------------
-- Table structure for murmur
-- ----------------------------
DROP TABLE IF EXISTS "public"."murmur";
CREATE TABLE "public"."murmur" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "text" text COLLATE "pg_catalog"."default" NOT NULL,
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."murmur"."id" IS '碎碎念ID';
COMMENT ON COLUMN "public"."murmur"."text" IS '碎碎念内容';
COMMENT ON COLUMN "public"."murmur"."create_time" IS ' 创建时间';
COMMENT ON COLUMN "public"."murmur"."update_time" IS ' 更新时间';
COMMENT ON COLUMN "public"."murmur"."deleted" IS '是否 删除';
COMMENT ON COLUMN "public"."murmur"."creator" IS '创建 人';
COMMENT ON COLUMN "public"."murmur"."updater" IS '更新 人';
COMMENT ON TABLE "public"."murmur" IS '碎碎念/动态表';

-- ----------------------------
-- Records of murmur
-- ----------------------------

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
INSERT INTO "public"."origin_file_source" VALUES ('01e64068ea7b6ae8', 'Claude的部署和配置_20260509_204344.md', 'knowledge-file/Claude的部署和配置_20260509_204344.md', 'f', 'knowledge-file', 'Claude的部署和配置_20260509_204344.md', 'text/markdown', 4386, 'b342df8a6111a775', '[]', '2026-05-09 20:43:44.653726', '2026-05-09 20:43:44.653726', 'f', NULL, NULL);
INSERT INTO "public"."origin_file_source" VALUES ('ca90c35f146f682f', '脱脂牛马_20260509_204400.md', 'knowledge-file/脱脂牛马_20260509_204400.md', 'f', 'knowledge-file', '脱脂牛马_20260509_204400.md', 'text/markdown', 2232, '6303e57b63576127', '[]', '2026-05-09 20:44:00.629331', '2026-05-09 20:44:00.629331', 'f', NULL, NULL);
INSERT INTO "public"."origin_file_source" VALUES ('469ed83c331c9c83', '乌海之行——骑行_20260509_204403.md', 'knowledge-file/乌海之行——骑行_20260509_204403.md', 'f', 'knowledge-file', '乌海之行——骑行_20260509_204403.md', 'text/markdown', 5041, '77ca0a267152f43c', '[]', '2026-05-09 20:44:03.991194', '2026-05-09 20:44:03.991194', 'f', NULL, NULL);
INSERT INTO "public"."origin_file_source" VALUES ('960c7bd1c7b8b882', '一件叛逆的大事——吸烟_20260509_204407.md', 'knowledge-file/一件叛逆的大事——吸烟_20260509_204407.md', 'f', 'knowledge-file', '一件叛逆的大事——吸烟_20260509_204407.md', 'text/markdown', 2711, '9f5aa0eac15d4408', '[]', '2026-05-09 20:44:07.625048', '2026-05-09 20:44:07.625048', 'f', NULL, NULL);
INSERT INTO "public"."origin_file_source" VALUES ('6a323cdabf7da6ae', '_Axios网络请求_04_20260509_204410.md', 'knowledge-file/_Axios网络请求_04_20260509_204410.md', 'f', 'knowledge-file', '_Axios网络请求_04_20260509_204410.md', 'text/markdown', 831, 'd77185ce58a9810f', '[]', '2026-05-09 20:44:11.01364', '2026-05-09 20:44:11.01364', 'f', NULL, NULL);
INSERT INTO "public"."origin_file_source" VALUES ('602f7d1669e86574', 'Vue引入第三方_03_20260509_204414.md', 'knowledge-file/Vue引入第三方_03_20260509_204414.md', 'f', 'knowledge-file', 'Vue引入第三方_03_20260509_204414.md', 'text/markdown', 1097, '483a3e6fec6908ae', '[]', '2026-05-09 20:44:14.510775', '2026-05-09 20:44:14.510775', 'f', NULL, NULL);
INSERT INTO "public"."origin_file_source" VALUES ('250fdbc3c950ee65', 'Vue事件处理_02_20260509_204418.md', 'knowledge-file/Vue事件处理_02_20260509_204418.md', 'f', 'knowledge-file', 'Vue事件处理_02_20260509_204418.md', 'text/markdown', 4962, '95440fafe6da9987', '[]', '2026-05-09 20:44:18.694316', '2026-05-09 20:44:18.694316', 'f', NULL, NULL);
INSERT INTO "public"."origin_file_source" VALUES ('da816f36e2726f39', 'Vue模板语法_01_20260509_204422.md', 'knowledge-file/Vue模板语法_01_20260509_204422.md', 'f', 'knowledge-file', 'Vue模板语法_01_20260509_204422.md', 'text/markdown', 1812, '74f5b3e19147bdc3', '[]', '2026-05-09 20:44:22.250385', '2026-05-09 20:44:22.250385', 'f', NULL, NULL);

-- ----------------------------
-- Table structure for photo
-- ----------------------------
DROP TABLE IF EXISTS "public"."photo";
CREATE TABLE "public"."photo" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "bucket_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "object_name" varchar(500) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "create_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "updater" varchar(255) COLLATE "pg_catalog"."default",
  "thumbnail_name" varchar(500) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."photo"."id" IS '照片ID';
COMMENT ON COLUMN "public"."photo"."bucket_name" IS 'MinIO存储桶名称';
COMMENT ON COLUMN "public"."photo"."object_name" IS 'MinIO对象名称';
COMMENT ON COLUMN "public"."photo"."description" IS '照片描述';
COMMENT ON COLUMN "public"."photo"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."photo"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."photo"."deleted" IS '是否删除';
COMMENT ON COLUMN "public"."photo"."thumbnail_name" IS '缩略图对象名称';
COMMENT ON TABLE "public"."photo" IS '照片表';

-- ----------------------------
-- Records of photo
-- ----------------------------
INSERT INTO "public"."photo" VALUES ('76a2ba4888b5a4e2959eb042045107e5', 'photos', 'anime_1773451453030.jpg', '', '2026-03-14 09:24:18.335846', '2026-03-14 09:24:18.335846', 'f', NULL, NULL, 'thumb_20260314_092359.jpg');
INSERT INTO "public"."photo" VALUES ('a0caa9aa8827f5d6176e789804e49274', 'photos', 'anime_1773451595716.jpg', '', '2026-03-14 09:26:39.37706', '2026-03-14 09:26:39.37706', 'f', NULL, NULL, 'thumb_20260314_092621.jpg');
INSERT INTO "public"."photo" VALUES ('b4d4c964cd01d10f4ec2ddd6d845039b', 'photos', 'anime_1773883756704.jpg', '', '2026-03-19 09:29:21.702109', '2026-03-19 09:29:21.702109', 'f', NULL, NULL, 'thumb_20260319_092857.jpg');
INSERT INTO "public"."photo" VALUES ('cee4c8726c7239124a9734553e59b86b', 'photos', 'anime_1775547491322.jpg', '', '2026-04-07 15:38:14.283724', '2026-04-07 15:38:14.283724', 'f', NULL, NULL, 'thumb_20260407_153755.jpg');
INSERT INTO "public"."photo" VALUES ('f20b90597a696a4d6de2f998bf6b30ef', 'photos', 'anime_1775547558735.jpg', '', '2026-04-07 15:39:23.115463', '2026-04-07 15:39:23.115463', 'f', NULL, NULL, 'thumb_20260407_153900.jpg');
INSERT INTO "public"."photo" VALUES ('fba39621f347fdf6fb41ff6df9b25a03', 'photos', 'anime_1775547616550.jpg', '', '2026-04-07 15:40:20.613618', '2026-04-07 15:40:20.613618', 'f', NULL, NULL, 'thumb_20260407_154000.jpg');
INSERT INTO "public"."photo" VALUES ('d06c60929e30a775a4375c1405ea3e04', 'photos', 'anime_1775547690673.jpg', '', '2026-04-07 15:41:39.846001', '2026-04-07 15:41:39.846001', 'f', NULL, NULL, 'thumb_20260407_154102.jpg');
INSERT INTO "public"."photo" VALUES ('447d2a34402397b3250e062635d81726', 'photos', 'photo_20260505_162713.jpg', '', '2026-05-05 16:27:27.91494', '2026-05-05 16:31:35.776377', 't', NULL, NULL, 'thumb_20260505_162713.jpg');
INSERT INTO "public"."photo" VALUES ('401938072c0b8516b0269878a79635d1', 'photos', 'anime_1777969970762.jpg', '', '2026-05-05 16:32:55.25452', '2026-05-05 16:32:55.25452', 'f', NULL, NULL, 'thumb_20260505_163234.jpg');
INSERT INTO "public"."photo" VALUES ('8264ce60f8caf1debc962d9f67e08389', 'photos', 'anime_1778252420398.jpg', '', '2026-05-08 23:00:23.953511', '2026-05-08 23:00:37.774363', 't', NULL, NULL, 'thumb_20260508_230004.jpg');
INSERT INTO "public"."photo" VALUES ('ca0ed473bcad2bfd97533204f2bd9da0', 'photos', 'anime_1778252448310.jpg', '', '2026-05-08 23:00:50.981713', '2026-05-08 23:00:50.981713', 'f', NULL, NULL, 'thumb_20260508_230034.jpg');
INSERT INTO "public"."photo" VALUES ('a3575b8df676f9770419c58eb20720c8', 'photos', 'anime_1778252085827.jpg', '', '2026-05-08 22:54:51.069852', '2026-05-08 23:01:18.929431', 't', NULL, NULL, 'thumb_20260508_225426.jpg');

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
INSERT INTO "public"."system_role" VALUES (1, 'ADMIN', '管理员', '2026-05-05 08:26:28.902508', '2026-05-05 08:26:28.902508', 'f', NULL, NULL);

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
  "updater" varchar(255) COLLATE "pg_catalog"."default",
  "avatar" varchar(500) COLLATE "pg_catalog"."default"
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
INSERT INTO "public"."system_user" VALUES (1, 'YoyuEN', '242431', '2026-02-25 09:13:52.247648', '2026-04-09 10:35:05.050579', 'f', NULL, NULL, 'http://118.89.135.164:9000/avatars/YoyuEN.png');

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
INSERT INTO "public"."system_user_role" VALUES (1, 1, 1, '2026-05-05 08:26:54.396082', '2026-05-05 08:26:54.396082', 'f', NULL, NULL);

-- ----------------------------
-- Table structure for user_profile
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_profile";
CREATE TABLE "public"."user_profile" (
  "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "nickname" varchar(128) COLLATE "pg_catalog"."default",
  "avatar" varchar(512) COLLATE "pg_catalog"."default",
  "signature" varchar(512) COLLATE "pg_catalog"."default",
  "welcome_text" text COLLATE "pg_catalog"."default",
  "school" varchar(256) COLLATE "pg_catalog"."default",
  "email" varchar(128) COLLATE "pg_catalog"."default",
  "location" varchar(128) COLLATE "pg_catalog"."default",
  "tech_stack" text COLLATE "pg_catalog"."default",
  "tags" text COLLATE "pg_catalog"."default",
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "deleted" bool DEFAULT false,
  "creator" varchar(64) COLLATE "pg_catalog"."default",
  "updater" varchar(64) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of user_profile
-- ----------------------------
INSERT INTO "public"."user_profile" VALUES ('1', 'YoyuEN', '/src/assets/picture/YoyuEN.png', '宁鸣而死，不默而生！', '欢迎来到我的知识空间！这里记录着我的学习历程、技术探索和生活感悟。希望我的分享能给你带来一些启发和帮助。', '北方民族大学 · 软件工程', '15839393171@163.com', '北京 · 昌平', '["Vue.js","React","TypeScript","Node.js","Python","Java","MySQL","Git"]', '["玄不救非,氪不改命","男神","手工","天然呆","篮球","Running","Gym"]', '2026-05-03 04:20:33.604033', '2026-05-03 04:20:33.604033', 'f', NULL, NULL);

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
INSERT INTO "public"."vector_store" VALUES ('2e79d729-6d3e-45fa-8fbb-643651885f66', '# Claude的部署和配置

**操作**: 更新  
**分类**: study  
**时间**: 2026-05-09 20:43:44  
**标签**: Claude  

## 简介

本文介绍如何在无代理环境下部署 Claude CLI 工具，并配置国内中转或第三方模型，包含 Node.js 安装、Claude Code 安装及绕过登录限制等步骤。

## 内容

下面分两部分：**1. 安装 Claude Code（CLI）**、**2. 安装 CCSwitch + 配置国内中转/第三方模型**，全程尽量无魔法、可直接复制命令。

---

## 一、安装 Claude Code（CLI）
### 1. 前提
- 安装 Node.js（推荐 v20+）：https://nodejs.org/
- 验证：
  ```bash
  node -v
  npm -v
  ```

### 2. 安装 Claude Code
```bash
npm i -g @anthropic-ai/claude-code@latest
```
- 验证安装：
  ```bash
  claude-code --version
  # 或简写
  claude --version
  ```
- 若提示权限错误（Windows 用管理员终端，macOS/Linux 加 sudo）：
  ```bash
  sudo npm i -g @anthropic-ai/claude-code@latest
  ```

### 3. 绕过初始登录（国内必做）
编辑/创建 `~/.claude.json`（Windows：`C:\Users\你的用户名\.claude.json`），写入：
```json
{
  "hasCompletedOnboarding": true
}
```
保存后，直接在任意文件夹运行：
```bash
claude
```
即可进入对话，不会再要求登录。

---

## 二、安装 CCSwitch（跨平台）
### 1. Windows 安装
- 下载：https://github.com/farion1231/cc-switch/releases
  - 选 `.msi` 安装包 或 便携版 `.zip`
- 双击安装，一路默认即可。

### 2. macOS 安装（推荐 Homebrew）
```bash
brew tap farion1231/ccswitch
brew install --cask cc-switch
```
- 启动：`Launchpad → CC Switch`

### 3. Linux 安装
- 下载对应包（`.deb`/`.rpm`/`.AppImage`），安装后运行。

---

## 三、CCSwitch 配置（国内中转/第三方模型）
### 1. 打开 CCSwitch 主界面
- 第一次运行会自动检测 Claude Code 路径，确认即可。

### 2. 添加模型提供商（核心）
点击右上角 **+（Add Provider）**，有两种方式：

#### 方式 A：用预设（推荐，如 GLM、MiniMax、DeepSeek 等）
1. 预设列表选供应商（如 `Zhipu GLM`）
2. 填写：
   - Provider Name：自定义（如 `glm-5.1`）
   - API Key：你的平台密钥（如智谱/ MiniMax 官网创建）', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "a7112d26f42cc038d74bdd5980b00314", "document_id": 158, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.054111056,0.04574337,-0.032962132,0.037178792,-0.019147241,-0.078557834,0.018556582,0.065760195,0.00800673,0.094046265,0.05640807,-0.009836136,-0.005389776,-0.07245434,-0.06746654,0.008859906,-0.03504585,-0.07370129,-0.07481699,-0.016333401,0.0046186363,0.0028999785,0.02574295,0.0042330665,0.01909802,-0.01533256,0.021050481,-0.019311314,0.02023012,0.0340286,0.022330245,-0.05069835,0.030878413,0.0049344758,-0.012994529,0.025168696,0.028154813,0.0036649657,0.022641983,0.0009921249,0.0026169538,0.009836136,0.06385695,0.05105931,-0.009401345,-0.010631887,-0.029779129,-0.016144717,-0.04685906,0.018179215,-0.0035501153,-0.010754942,-0.010500629,-0.027908705,-0.010664701,0.0315347,-0.026382832,0.015783759,-0.008892721,0.01891754,0.016456455,-0.007998526,0.0075883456,0.017637776,-0.0024467288,-0.0054061837,0.024578037,-0.014257886,-0.001081852,-0.061888084,0.021624735,-0.013043751,0.009122422,-0.013560578,-0.0047868104,0.043216653,-0.007842658,-0.00024046852,0.0019432318,-0.031042486,-0.0067597805,-0.0063003777,-0.01726041,0.05178123,0.03173159,0.057458133,-0.033552792,0.010754942,0.0435448,0.05450483,0.008728649,0.03055027,-0.015997052,0.060148917,-0.010853386,-0.032174584,-0.034783337,0.0075514293,-0.01932772,0.037113164,-0.0114850635,-0.04548085,-0.0009772559,-0.057359688,0.03255195,0.01456142,-0.017358853,0.034881778,-0.022264617,0.043511983,-0.051321827,-0.045283966,-0.01467627,0.019508202,-0.011115901,-0.050140508,-0.02710475,0.036161542,-0.019901974,0.03937736,-0.016038071,0.029450985,0.05591585,-0.040952455,0.0048073195,0.0083923,0.07724526,-0.015660705,0.054636087,0.030501047,-0.02402019,-0.03645687,-0.011083086,4.0377177e-05,0.009795118,0.037802268,0.0088845175,-0.022346653,-0.035144296,0.034980223,0.0103447605,-0.03635843,0.050567094,0.028991582,0.019229278,-0.001594578,0.052043743,0.009516195,-0.007920592,-0.020361377,-0.005681005,-0.011517878,-0.023527972,0.05023895,-0.02864703,0.017358853,0.0075719384,-0.0024118633,-0.0038926161,0.04046024,-0.011394824,0.005069835,-0.008334875,0.048007566,-0.045316778,-0.06864787,0.011222548,-0.02283887,-0.005758939,-0.06021455,0.020902816,0.050862424,-0.060148917,0.0075883456,0.059066042,0.03642406,0.05260159,0.06628522,0.011501471,-0.0012664334,0.021493476,-0.017161967,0.01850736,-0.01755574,-0.036981903,0.006763882,0.005931215,0.030599492,-0.008991164,-0.0031358325,0.0028384514,0.10238114,-0.032076143,0.017129151,0.04804038,-0.005287231,-0.02164114,-0.00026713026,0.07028859,0.0054718126,0.011263566,-0.06155994,0.024922589,-0.00857278,0.016070886,0.026432054,0.032568358,0.0068049002,-0.0127894385,-0.0062470543,0.0063495995,-0.00082036166,-0.0116491355,-0.01136201,-0.013027344,-0.00014638329,-0.002064235,0.049090445,0.05361884,-0.0029122839,-0.0153981885,0.021378625,0.011821412,0.01013967,0.0019134936,0.0001608678,0.0068459185,-0.0063537015,-0.004729385,0.016325198,-0.030681526,-0.0055333395,-0.02408582,-0.0048032175,-0.025414806,0.042035334,-0.015636094,-0.020016825,-0.016538491,-0.0069484636,0.030763563,0.04738409,0.023117792,0.004630942,-0.0070633143,-0.00492217,-0.039869577,0.017834663,0.018851912,0.017604962,-0.0127894385,-0.010763145,0.013519561,0.038294483,0.013002733,-0.032420695,0.00954901,0.008835295,0.023167014,-0.0022108748,-0.027629782,0.042100962,-0.013913334,0.03885233,0.0048565413,0.0022580456,-0.01061548,0.06897601,-0.016095497,0.013109379,-0.02497181,0.041379042,0.02556247,-0.012075724,0.0065423846,0.050567094,0.08354563,0.023626417,0.029976016,-0.005221602,-0.010566259,-0.020066047,0.026645347,-0.00925368,0.041182157,0.03000883,0.0039890087,0.041083712,-0.005459507,-0.029254097,0.030287754,0.025299955,-0.03184644,0.00065423845,-0.046694987,0.031042486,0.020213712,0.0060788803,0.015094655,-0.02794152,-0.042658806,-0.001424353,-0.023757674,-0.03096045,0.012567941,0.04597307,-0.021739585,-0.100281015,0.05545645,-0.04764661,-0.03511148,-0.007092027,-0.010106856,0.0004819625,0.037703823,-0.052273445,0.0088845175,-0.00573843,-0.013084769,-0.0077237054,0.022379467,0.050632723,-0.0055538486,0.002807688,0.08262683,0.03132141,0.04246192,-0.026596125,-0.011805004,0.02846655,0.01032015,0.0437745,-0.00659981,-0.03996802,-0.02853218,-0.016866636,0.021362219,0.033536386,0.01109129,0.003511148,0.045710552,-0.051617157,-0.00530774,-0.031879254,0.0061281016,0.01206752,-0.031485483,-0.011033865,-0.042265035,0.023888933,-0.010804163,0.001347444,0.005730226,0.02011527,0.038163226,-0.03445519,0.005902502,0.010861589,-0.007928796,0.016866636,0.006579301,0.0032260723,-0.0095408065,-0.01349495,0.036620945,-0.035275552,0.052732848,0.06277408,-0.01319962,0.025874207,-0.014036388,-0.044496417,-0.010500629,0.009598232,-0.022707611,0.052700035,0.019557422,0.012494109,-0.015250524,0.026300795,-0.08978038,0.018671433,-0.0062839705,-0.019901974,-0.0012859169,0.011009254,-0.018179215,0.015832981,0.07002607,0.022461504,0.008441522,-0.023888933,0.0064111263,-0.024709294,0.029844757,-0.008613798,0.053290695,0.017703405,-0.025103068,0.031862848,0.024578037,-0.030632306,-0.0065382826,-0.010582666,0.023626417,-0.041805632,0.037441306,0.030812785,0.017621368,-0.028778289,-0.110125355,0.021969287,-0.024003783,-0.021985693,0.04305258,0.0051436676,-0.0043561207,-0.022198986,0.059394184,0.077967174,0.033159018,0.050928053,-0.05581741,-0.007071518,-0.059328556,0.22353216,-0.05722843,-0.03570214,0.005935317,0.04574337,0.017769035,-0.008794277,-0.03865544,0.084005035,0.003771613,-0.017900292,-0.006107593,-0.031403445,0.008827092,-0.014700881,-0.042855695,0.0297135,-0.012920696,0.009688471,0.012502312,0.020066047,-0.03724442,0.030615898,0.022674797,0.0010136594,-0.024233485,-0.020361377,-0.04577618,0.020246526,0.0033040068,-0.008892721,-0.00012017017,-0.042560365,0.05230626,0.014069203,0.058803525,0.005804059,0.011895244,0.01850736,0.0041407757,0.04364324,0.010582666,0.011279973,0.014684474,-0.030730749,-0.044201087,-0.0013843604,-0.021034073,0.023101386,-0.036850646,0.04075557,-0.025808578,0.052765664,0.008207719,0.04590744,-0.040493052,0.0054431,-0.014840343,0.0053323507,-0.05142027,-0.027596967,-0.0183761,-0.023462344,0.03302776,-0.0071658595,0.022330245,-0.022100544,0.05611274,0.0006152713,-0.029877573,0.036489688,-0.030468233,0.0081420895,0.022198986,-0.017654184,0.013667226,0.02644846,-0.004918068,0.0057097175,-0.043511983,-0.0075719384,0.008761463,-0.032420695,-0.0049754935,-0.023478752,-0.015414596,-0.0015802217,0.014503995,0.02628439,0.01592322,0.003552166,0.013109379,0.0083143655,-0.003187105,-0.015135673,0.012223389,-0.03563651,-0.004733487,-0.008704037,-0.044332344,0.021690363,-0.03422549,-0.00954901,0.07652334,0.0030948145,0.015636094,0.00046068436,-0.036194358,0.0009921249,-0.0412806,-0.014019981,-6.5148255e-05,0.004819625,-0.0011833718,0.058344122,0.0006485985,-0.026366424,-0.010746738,-0.0108862,0.033191834,0.032962132,-0.00192785,0.025808578,-0.0038639035,0.0013515459,-0.022116952,-0.0016253416,0.027252415,-0.08348001,0.06579301,-0.053520396,-0.015619687,0.011132308,0.038819514,-0.05995203,-0.007005889,-0.014060999,0.0258578,-0.022641983,-0.005697412,-0.04242911,-0.025119474,0.0077852323,0.012682792,-0.029910387,-0.07448884,0.0103447605,-0.0054841177,0.043380726,0.01921287,0.001830432,-0.0040074666,0.04364324,0.054767348,0.036489688,-0.009270087,0.017933106,-0.01467627,-0.034914594,0.025217919,-0.019262092,0.0322074,-0.007978017,0.0044422587,0.0047868104,0.053750098,-0.01755574,-0.0750795,0.015496632,0.016817415,0.007904185,0.065169536,0.0024282706,-0.0013310368,0.033487163,0.02574295,0.0016243161,0.016325198,-0.011608118,-0.0024446778,0.0179167,-0.01011506,-0.010648294,0.011763986,-0.0022662492,0.016275976,0.023035755,0.019048799,0.0032404286,-0.048631042,-0.022494318,-0.0119854845,-0.015865795,0.0129617145,-0.025464026,0.025759356,-0.024315521,-0.032043327,-0.0074693933,0.0074611893,-0.021132518,0.0025595285,-0.018901134,-0.048237268,0.0050001047,0.016431844,0.025644505,-0.007149452,-0.02413504,-0.02052545,0.018179215,-0.01447118,-0.012953511,0.00085317617,0.06559612,-0.0051272605,0.022510724,-0.04443079,-0.07081362,0.012887882,-0.0071863686,0.0319777,-0.021509884,0.024824144,-0.0004473535,-0.0073668477,0.014873157,0.046005882,-0.04111653,-0.03908203,0.020262934,0.027564153,-0.032568358,0.017982328,-0.019901974,-0.03842574,-0.046727803,-0.0121413525,-0.00868763,-0.014815732,-0.028039962,-0.032125365,-0.020787966,-0.0036875259,0.0033327194,-0.06067395,-0.040132094,-0.014454773,0.061724015,-0.0046760617,0.011042069,0.02533277,-0.031715184,0.052831292,-0.019901974,-0.011895244,0.007645771,-0.0045037856,0.045087077,-0.07573579,0.024364742,-0.014462977,-0.017244002,-0.03268321,0.0042084553,0.048532598,-0.053782914,0.035177108,0.021690363,-0.024660071,0.0017730067,-0.015619687,-0.0052954345,-0.0010423721,0.06448043,-0.029450985,-0.013240637,0.008712241,0.047712237,-0.007018194,-0.020787966,-0.022330245,-0.011411231,0.005734328,-0.036194358,-0.011460452,0.044529233,0.026432054,-0.0108862,-0.023872524,-0.0179167,0.05371728,-0.017539334,-0.019344129,-0.015209505,0.016316993,0.013683633,-0.07455447,-0.0048524393,-0.067925945,0.05059991,0.008179006,-0.0063003777,-0.0060952874,0.022428688,-0.035078667,-0.02781026,0.050731167,0.014553216,0.009056793,-0.046005882,-0.022904499,-0.0016079089,-0.01390513,-0.038983587,-0.030878413,-0.017588554,0.07429195,-0.065727375,0.09535884,0.0066080135,-0.07409507,0.046169955,0.023068571,0.022986535,0.04216659,-0.01465166,0.004881152,0.019967603,-0.025021031,-0.015020822,-0.003127629,0.011944466,-0.039771136,0.011608118,-0.029336134,0.014610642,0.018294066,-0.047055945,0.03161674,0.063561626,0.01601346,-0.034356747,-0.0072684046,-0.008002629,0.0070797214,0.009286494,0.025660913,0.038392927,-0.0010018667,0.01032015,-0.0030968653,-0.03370046,-0.013757465,-0.088402174,0.018408917,-0.0058737895,0.06700714,-0.059656702,0.01909802,-0.008047748,0.0030640508,0.009097811,-0.01560328,0.0076580765,0.003638304,0.033060577,0.020558264,0.008084664,0.0030558472,0.0010474994,-0.013298063,0.018261252,-0.051223382,-0.037080348,0.033175427,-0.018277658,-0.0055374415,-0.0324371,-1.376349e-05,-0.010943625,-0.019557422,0.025414806,0.007038703,-0.01957383,-0.05811442,-0.010065838,-0.0077811307,-0.007871371,0.005508729,-0.002916386,-0.03393016,-0.013207823,-0.007982119,-0.0103529645,-0.028302478,0.03422549,0.009655657,-0.027744632,0.011419435,-0.030172903,0.00945877,0.012674588,0.0037100858,0.057622205,-0.006226545,-0.018704247,-0.045513667,0.017637776,-0.0016479015,-0.0038659545,0.0009634122,0.0066490313,-0.02164114,0.033421535,0.019639459,-0.01399537,-0.008999367,0.019475386,-0.014216868,-0.014028185,-0.01660412,-0.016472863,-0.018261252,-0.020033233,-0.03530837,0.039049216,-0.0591973,-0.014225071,-0.000980845,-0.0061157965,-0.05325788,0.02082078,0.024217077,0.032404285,-0.010443204,-0.03284728,-0.02479133,0.014413754,-0.048860744,-0.0018929846,0.030681526,0.042691622,0.011813208,0.04518552,0.038491372,0.09017415,0.00850715,-0.03309339,-0.013150398,-0.0076580765,-0.0064972644,0.015980646,0.034094233,0.024348335,0.052929737,0.025168696,-0.015554057,-0.0044381567,0.03155111,-0.034947407,0.04164156,-0.002186264,-0.014643456,0.034717705,-0.022051321,0.044693306,-0.026514089,0.04187126,0.045612108,-0.008490743,0.018310472,-0.031305,0.057950348,0.019426165,0.013650819,-0.01011506,-0.0035439625,0.010041227,-0.021329403,0.01639903,0.007206877,0.003406552,-0.0062183416,-0.020312155,-0.03273243,0.01986916,0.011132308,0.002036548,0.039869577,0.017490111,0.027859483,-0.026103908,-0.047482535,-0.028548587,0.045283966,0.011526082,0.0023031654,0.031649552,0.012280814,-0.001968868,-0.0054307943,0.013363692,-0.013232434,0.0170143,-0.016095497,-0.0029922694,-0.022248209,0.02538199,0.004897559,0.0025779866,-0.05289692,-0.07068236,0.0016079089,0.0018263302,0.0087204445,-0.023232643,0.007498106,0.0031091708,0.03363483,-0.04318384,-0.000115747906,-0.023954561,-0.0639554,-0.026120316,-0.02751493,0.0031112216,-0.04495582,-0.045087077,-0.008498947,-0.025693728,0.016702564,0.007904185,-0.011017458,-0.02805637,-0.004052587,-0.015472021,-0.036259986,-0.05450483,0.043446355,0.0030148292,-0.039771136,0.026678162,0.026760198,0.0070592123,-0.039607063,0.011247159,0.018572988,-0.010131467,-0.0437745,-0.019705087,-0.030944042,-0.053651653,-0.062249046,-0.03862263,0.0005901477,-0.0037264929,0.05017332,0.00462684,0.03429112,-0.04318384,0.043807313,-0.015800167,0.016407235,0.03343794,-0.0063824137,0.013560578,0.023035755,-0.008371791,0.0487623,0.030566676,0.0025964447,-0.018950354,0.033766087,0.017703405,0.0063495995,0.03329028,0.030336974,-0.016251365,0.017506517,0.07829532,-0.012969919,0.0022826565,0.018671433,0.0027236007,0.011969077,0.015619687,-0.0015863744,-0.015586872,0.0059599276,-0.045513667,-0.045218337,0.016185736,-0.010697517,-0.023380307,-0.015053637,0.004946781,-0.014545012,0.026267981]');
INSERT INTO "public"."vector_store" VALUES ('1273b937-758f-4ecd-acd8-5500fb8967ab', '- Model：模型名（如 `glm-5.1`）
3. 点 **Add** 保存。

#### 方式 B：自定义中转（如通用 OpenAI 格式中转）
1. 预设选 **Custom（自定义）**
2. 按以下填写（以某中转为例）：
   - Provider Name：`my-proxy`
   - Base URL：`https://xxx.xxx.com/v1`（**末尾不要加 /**）
   - API Key：`sk-xxxxxx`（中转平台给的 key）
   - API 格式：选 **OpenAI Chat Completions**（关键，自动适配 Claude）
   - 认证字段：默认 `ANTHROPIC_AUTH_TOKEN`
   - 模型映射（可选）：
     - Sonnet：`claude-sonnet-4-6`
     - Haiku：`claude-haiku-4-5`
3. 保存。

### 3. 启用配置
- 在供应商列表选中刚添加的项 → 点 **Enable** → 状态变为 **Active** 即生效。
- 切换后**无需重启 Claude**，直接用：
  ```bash
  claude
  ```

### 4. VS Code / Cursor 插件联动（可选）
1. 在 VS Code 安装插件：`Claude Code for VS Code`

2. 打开 CCSwitch → 设置 → 勾选 **应用到 Claude Code 插件**
3. 之后在 CCSwitch 切换模型，插件自动同步，无需手动改配置。

---

## 四、常用国内模型快速配置（参考）
### 1. 智谱 GLM（推荐）
- 注册：https://open.bigmodel.cn/
- 创建 API Key，CCSwitch 预设选 `Zhipu GLM`，填 Key + 模型 `glm-5.1`。

### 2. MiniMax
- 注册：https://platform.minimaxi.com/
- 创建 Key，预设选 `MiniMax`，模型填 `abab6.5-chat`。

### 3. 哈基米中转（免费额度）
- 注册：https://hkm.sx/
- 创建令牌，复制 API Key，自定义配置：
  - Base URL：`https://api.hkm.sx/v1`
  - API Key：`你的密钥`
  - 格式：`OpenAI Chat Completions`

---

## 五、验证是否成功
```bash
claude
# 随便问一句话，能正常回复即成功
```

---

## 六、常见问题
1. **提示“not authenticated”**：检查 `~/.claude.json` 是否有 `hasCompletedOnboarding: true`。
2. **超时/连接失败**：
   - Base URL 末尾**不要加 /**
   - 换国内中转（如哈基米、智谱）
3. **模型名报错**：在 CCSwitch 高级选项里，把 Claude 默认模型映射到你实际可用的模型。

---', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "a7112d26f42cc038d74bdd5980b00314", "document_id": 158, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.062187612,0.057844553,0.015011889,0.025303056,0.010306904,-0.08912719,0.003241561,0.0658383,0.027962396,0.085476495,0.032069422,0.015830146,-0.010417054,-0.054477103,-0.026577652,0.031361315,-0.026813688,-0.04103879,-0.06316323,0.027144138,-0.019150386,-0.00833207,0.015924562,-0.005472101,0.024547743,-0.012470568,-0.014901739,-0.004583032,0.027128402,0.019008765,-0.0027222817,-0.06615302,0.021133088,-0.002476411,-0.0016188135,0.021243239,0.011266784,0.01139267,0.014406063,0.008843482,-0.009063782,0.0032572965,0.08793127,0.08270701,-0.024170084,-7.9662146e-05,-0.00929195,-0.03402065,-0.015609846,0.009606664,-0.027474588,-0.006955194,-0.016459575,-0.013737294,-0.015035492,0.034713026,-0.021699574,0.03590894,0.0061802086,0.017419456,0.026530445,0.0011388736,-0.05246293,0.020141738,-0.021998554,-0.0046695787,0.037073385,-0.02528732,-0.012966244,-0.017828584,0.045067135,-0.0057907496,0.0025688582,0.0071872957,0.008339938,0.048434585,0.04944167,-0.034901854,0.027694888,-0.02141633,-0.014728645,-0.03549981,-0.030700414,0.019449364,0.025901016,0.040598188,-0.03335975,0.019071708,-0.0009087385,0.05312383,0.041794106,0.017608285,0.015208585,0.07515386,0.022769604,-0.007919007,-0.017985942,0.0025531226,0.00094463566,0.03395771,0.0076633017,-0.078301005,0.0030310955,-0.05696335,0.023871105,0.011967024,-0.028009603,0.0068961848,-0.02138486,0.066530675,-0.07232142,-0.026105579,0.0009657806,-0.020377774,-0.022218853,-0.034492724,-0.03798606,0.013328165,-0.040755548,0.036034826,0.0196854,0.0027537532,0.036223654,-0.023839634,0.022643719,-0.011345463,0.04959903,-0.018756993,0.026042636,0.02525585,-0.004634173,-0.050857887,-0.01456342,0.00025127997,-0.0061369357,0.023650805,0.020503659,-0.014256573,-0.062533796,0.016900176,-0.002049579,-0.03763987,0.009874172,0.04125909,0.018410807,0.021589424,0.06322617,0.020472188,0.008497295,-0.024799515,-0.029583177,-0.019386422,-0.017749906,0.052746173,-0.034681555,0.025224378,-0.007620028,0.006522461,0.025129965,0.022517832,-0.0061408696,0.008339938,-0.0108261835,0.029252727,-0.014634231,-0.056648634,-0.0124312285,-0.007808857,0.0102911685,-0.030731885,0.022832548,0.034713026,-0.04638894,0.03509068,0.031109542,0.05998461,0.044217408,0.06835602,0.0038631223,-0.020503659,0.03656984,-0.018568164,-0.004291921,-0.011597235,-0.050826415,-0.0019541811,0.033265337,0.015240056,-0.010377715,-0.008316334,-0.0071990974,0.12129103,0.005350149,0.014760117,0.04280119,-0.007820659,0.0057828818,0.0019315612,0.07200671,-0.013784502,-0.021620896,-0.067097165,-0.00789147,-0.0033635127,0.016349426,0.017781377,0.0058497586,0.03543687,0.017702699,-0.0047915303,-0.006286425,0.00095692923,0.00282063,0.0042997887,0.0014457204,-0.008607445,0.006038587,0.049724914,0.03735663,0.026971044,0.020676753,0.023949785,0.018111827,0.011770328,0.019307744,0.010188887,-0.0033143386,-0.018316392,0.0047443234,-0.004107026,-0.030731885,-0.0073918602,-0.03074762,0.011424142,-0.015074831,0.018379334,0.0044414103,-0.028214168,-0.013493391,-0.023115791,0.032761794,0.026892366,0.03543687,0.01847375,-0.005999248,-0.02613705,-0.05951254,-0.0027812906,0.01622354,0.00047231783,0.0057396083,-0.017010326,0.021668103,0.0011241214,0.0061998786,-0.05674305,0.0043155244,-0.011699517,0.01759255,-0.0022816812,-0.009968586,0.05520095,-0.017356513,0.04884371,0.025161436,-0.031172486,-0.016506784,0.070810795,-0.013155072,0.03521657,-0.0031314108,0.0077301785,0.012407625,-0.016365161,-0.029378612,0.04000023,0.080126345,0.0039240983,0.018599635,-0.0009451274,-0.018788464,0.0035012004,0.02706546,-0.014634231,0.028890803,0.031062335,0.008284863,0.02566498,-0.023477713,-0.024028463,0.046609238,0.04185705,-0.044815365,0.0027852247,-0.03908756,-0.007242371,0.014941078,-0.00966174,0.017561076,0.003638888,-0.042266175,0.018709786,-0.04749044,-0.04037789,0.016679876,0.026498973,-0.017828584,-0.10945775,0.05756131,-0.07408383,-0.03908756,-0.009787626,0.019118914,-0.018206242,0.06829308,-0.025523357,0.026373086,-0.01467357,0.009952851,0.044217408,0.0012893466,0.076979205,0.028292846,0.0023800295,0.04317885,0.016506784,0.036664255,0.019339215,-0.010881259,0.014752249,-0.005625524,0.045287438,0.0001621518,-0.03269885,-0.018332127,-0.035625696,0.03162882,0.026908102,0.045822453,-0.0018302624,0.028292846,-0.013414712,-0.008395013,-0.027647682,-0.007926875,0.012659397,-0.035279512,-0.00030561743,-0.021369124,0.024988342,0.00094758614,0.0058930316,0.0351851,0.0039555696,0.030369963,-0.028387262,0.009590928,-0.008623181,0.015775071,0.015476093,0.02728576,-0.007718377,-0.018631106,-0.0010046281,0.031235429,-0.020692488,0.060488153,0.041982934,-0.020503659,0.0059245033,-0.010959937,-0.0258066,0.00063139625,-0.0011526424,-0.021337653,0.043965634,0.022313269,-0.006219548,-0.005940239,0.027883718,-0.11096838,0.03414654,3.718796e-05,0.012077174,-0.014476874,0.01371369,-0.033863295,0.013524862,0.059229296,-0.0077380463,-0.021432066,-0.029252727,0.02289549,-0.026971044,0.014996152,0.009795493,0.036601312,0.0060189175,-0.017293569,0.041794106,0.021762518,-0.016538255,-0.012635793,0.0015765236,0.027553268,-0.02742738,0.042360593,0.02149501,0.021919874,-0.018096091,-0.08780538,0.025727922,-0.051424373,-0.04361945,0.026971044,0.03546834,0.013210147,-0.005818287,0.08132226,0.073769115,0.011093691,0.03867843,-0.043776806,-0.0014358856,-0.07068491,0.17661786,-0.03071615,-0.06646773,-0.012958376,0.04557068,0.032069422,0.0064241127,-0.05526389,0.10517763,0.010243962,-0.017199155,-0.015664922,-0.033894766,0.006125134,-0.001619797,-0.04015759,0.031943537,-0.014956813,-0.009173932,0.0013778601,-0.026498973,-0.0033556449,0.013123601,0.013878915,-0.0017781378,-0.030763356,0.0022954498,-0.024107141,0.018111827,0.006105464,0.004004744,0.00026504873,-0.04214029,0.0005551763,0.00096086314,0.036601312,-0.0034756297,-0.00026603224,-0.0070142024,0.0014516213,0.04191999,0.024988342,0.001414249,0.02912684,-0.032604437,-0.028072545,-0.007840329,0.012509907,0.051078185,-0.040314946,0.024421856,-0.037136327,0.057718664,0.00082858466,0.029803477,-0.033548582,0.003971305,0.01338324,-0.020031586,-0.044374764,-0.01699459,-0.014712909,-0.022801075,0.046105694,0.021243239,0.034996267,-0.050039627,0.05416239,-0.010857655,-0.057781607,0.0614323,-0.026892366,0.045193024,0.02528732,-0.012045703,0.017828584,0.021038674,-0.017120477,0.0053855544,-0.030842034,-0.003947702,0.022470625,-0.031581614,-0.010598016,-0.00837141,-0.04107026,-0.009708947,0.028513147,0.020078795,0.018190507,-0.0071361545,-0.0044020712,-0.012470568,-0.026451766,-0.020786902,0.0498508,-0.033580054,-0.015334471,-0.0051849238,-0.051204074,0.02599543,0.012344682,-0.005535044,0.082014635,-0.014162159,-0.011550027,-0.029425818,-0.052116744,-0.008670389,-0.003160915,-0.00025988545,-0.011699517,0.012321078,0.0044374764,0.04383975,0.016774291,-0.007403662,-0.0027871917,0.0013876949,0.02857609,0.042234704,-0.0055389777,0.011699517,-0.013674351,-0.027521795,-0.033233866,-0.009716814,0.048875183,-0.06961488,0.05693188,-0.027175609,0.0028835728,0.01257285,0.0075138123,-0.06014197,0.013572069,-0.0037077318,0.041636746,-0.05419386,0.009693211,-0.057876024,-0.024280235,-0.005716005,-0.00017628938,-0.008568106,-0.048654884,-0.0023229874,-0.007057476,0.017089006,0.0074862745,0.031188222,-0.007946544,0.034524195,0.046609238,0.04704984,-0.005169188,0.032352664,-0.026262937,-0.041416448,0.03908756,-0.036695726,0.012258136,-0.003636921,0.017026063,0.0021557952,0.0027537532,0.013485522,-0.08484707,0.0071282866,-0.010464262,0.006923722,0.056774523,0.004051951,-0.0013444216,0.033926237,0.0371678,0.015601979,0.03955963,-0.01187261,0.008033091,0.008284863,-0.025570564,-0.012116514,0.018048884,0.006093662,-0.007214833,0.014767985,0.011266784,-0.00016694628,-0.021904139,-0.006569668,-0.0061369357,-0.043052964,-0.001292297,3.96774e-05,0.042360593,-0.026923837,-0.05070053,-0.0044414103,0.0065263947,-0.04959903,0.0042368458,-0.0018479651,-0.047836624,-0.002236441,-0.0051849238,0.0096696075,-0.016011108,-0.0004794481,0.0068489774,0.023257412,0.0030724017,-0.0024429725,-0.003351711,0.045948338,0.0031019063,0.009708947,-0.015940297,-0.059418123,0.03052732,0.00588123,-0.021227503,0.0021892337,0.012509907,0.014114952,0.021982817,0.016805762,0.042014405,-0.080126345,-0.049347255,0.02857609,0.025822336,-0.02407567,0.018300656,-0.030338492,-0.042455006,-0.005397356,-0.0086782565,0.0010769141,0.0063611697,-0.019496571,-0.046074223,0.008623181,-0.015468225,-0.022297533,-0.036475427,-0.028497411,0.0035405396,0.042895608,0.0057238727,0.0062470855,0.018772729,-0.0062746233,0.071629055,0.0061408696,-0.044626538,0.010393451,-0.021022938,0.028088283,-0.043115906,0.03546834,-0.005759278,-0.021290446,0.0108261835,0.016396632,0.03590894,-0.045193024,0.062407915,0.0314872,-0.0077380463,0.0022187382,0.04399711,0.01043279,0.011951288,0.04966197,-0.05202233,-0.017671227,0.02898522,0.030857772,0.017167684,-0.032510024,-0.028890803,-0.016491048,-0.008859217,-0.058977526,0.00042240607,0.045665096,0.029221255,-0.017199155,-0.014531949,0.0032022216,0.041982934,0.011675913,-0.00045854907,-0.0065893377,0.030401435,-0.003874924,-0.08100755,0.0005669781,-0.046200108,0.05828515,0.011620838,-0.0052557345,-0.011235313,-0.0016679876,-0.012588586,-0.03181765,0.064642385,0.0007621995,0.028261375,-0.03823783,-0.043304734,-0.013178675,-0.0050865756,-0.035625696,-0.019779814,-0.0064988574,0.08081872,-0.03186486,0.05306089,0.025161436,-0.057750136,0.020771166,0.07307674,0.04283266,0.043399148,-0.006345434,0.0009756154,-0.0013306529,-0.04365092,-0.02986642,0.025554828,0.0023741287,-0.05479182,0.028104018,-0.019889966,0.0011644441,0.043367676,-0.038174886,0.016317954,0.06728599,-0.008843482,-0.030354228,-0.032195307,-0.014665702,-0.0035385727,0.004228978,0.01987423,0.02009453,-0.02709693,0.028340053,0.0075492174,-0.037545457,0.02635735,-0.076664485,0.04387122,-0.0092998175,0.08088166,-0.041794106,0.02267519,0.013878915,0.01054294,-0.0033595788,-0.011164502,0.00914246,0.01759255,0.033800352,-0.015956033,0.006825374,-0.014406063,0.028355788,-0.03543687,0.0073839924,-0.051015243,-0.039811403,0.02042498,-0.004107026,-0.021967081,-0.004421741,-0.013021318,-0.025916751,-0.023902576,0.028717712,0.041825578,-0.015633449,-0.03395771,-0.006097596,-0.023147263,0.013099997,-0.01117237,0.012675133,-0.04597981,-0.014705041,-0.015295132,0.0046577766,-0.024720835,0.024327442,0.0139575945,-0.054099448,-0.010896995,-0.029882155,0.0070732115,0.03786017,-0.019181857,0.051141128,-0.0015283329,-0.029221255,-0.029000955,0.04837164,0.004760059,-0.021164559,-0.014760117,-0.022297533,-0.028875068,0.042423535,0.034933325,0.016302219,-0.008206184,-0.0053304792,-0.009386364,0.0125177745,-0.01279315,-0.02473657,-0.06615302,-0.0037215007,0.023713749,0.03288768,-0.06426473,-0.041353505,-0.010063001,-0.0128875645,-0.03329681,0.034524195,-0.006408377,0.018206242,-0.0033772816,-0.033548582,-0.015869485,0.010999277,-0.037136327,0.015436754,0.00054878363,0.028513147,-0.0046617105,0.053155303,0.03310798,0.05891458,0.001908941,-0.033926237,0.006093662,-0.043745335,-0.010094472,0.017812848,0.033139452,0.019905701,0.051046714,0.035751585,-0.023981256,0.0050000288,0.013139336,-0.06766365,0.016790027,-0.00039486852,-0.015798675,0.040912904,-0.01721489,0.061967313,-0.013312429,0.059449594,0.063572355,0.0028953748,0.03329681,0.007112551,0.040912904,0.03162882,0.022753868,0.011093691,-0.0128875645,0.020283358,-0.008867085,-0.0013326198,-0.01493321,0.004508287,-0.016176332,-0.01825345,-0.026498973,0.012360417,0.01128252,-0.034240954,0.022329004,0.04188852,-0.0021931676,-0.0011270718,-0.02352492,-0.022942698,0.062565275,-0.00045510687,-0.0053894883,0.0393708,0.030999392,0.024343178,-0.016380897,0.019417893,-0.019795552,0.022974169,-0.00929195,-0.0010749472,0.0057986174,0.04642041,0.00833207,-0.0070614098,-0.043934163,-0.052935004,-0.0075767552,-0.014374591,-0.010605884,-0.008064562,0.013485522,0.007399728,0.046483353,-0.059669897,0.000116850104,-0.036853086,-0.012950508,0.013060657,-0.0030409303,0.006396575,-0.041542333,-0.033391222,0.026908102,0.018756993,-0.005121981,-0.0055429116,0.009944983,-0.032132365,0.0056176563,-0.030999392,-0.02846594,-0.026089843,0.030983657,0.008843482,-0.04538185,0.03616071,-0.0015155477,-0.003162882,-0.047207195,-0.0085130315,0.01825345,-0.018898614,-0.082014635,-0.04295855,-0.020959996,-0.039937288,-0.04343062,-0.0038218158,0.0006309045,-0.0011359232,0.063666776,0.008174713,0.03930786,-0.039874345,0.034713026,0.00086644874,0.024516271,0.045948338,-0.018882878,0.0034225218,0.031754706,-0.01360354,0.05268323,0.034555666,-0.009284082,-0.025570564,0.038143415,0.006109398,-0.012140118,0.019590987,0.006235284,0.0033064708,0.011180238,0.07628683,-0.032163836,0.0017938735,0.00977189,-0.009559457,0.02997657,0.025208643,0.025602037,0.0075452835,0.041636746,-0.020283358,-0.061967313,-0.007686905,-0.027474588,-0.013351769,-0.028402997,0.04107026,-0.018332127,0.02860756]');
INSERT INTO "public"."vector_store" VALUES ('92c2f503-c6e3-43e1-a30f-d8633f739298', '# 脱脂牛马

**操作**: 更新  
**分类**: life  
**时间**: 2026-05-09 20:44:00  
**标签**: 自由  

## 简介

“脱脂牛马”倡导摆脱内耗与盲目内卷，卸下焦虑与讨好，学会爱自己、松弛生活，在清醒中找回真实的自我。

## 内容

何为脱脂牛马？不再盲目内耗、不再无脑内卷，不再被生活推着硬扛所有压力；褪去无谓的焦虑、多余的讨好、没必要的逞强，做清醒、松弛、懂得爱自己的普通人。

从前我们都做惯了普通牛马，被生活裹挟，被世俗定义。忙着赶路，忙着迎合，忙着追赶别人的节奏；委屈往心里咽，压力自己默默扛，习惯性透支身体、消耗情绪，把懂事、隐忍、拼命活成了常态。以为埋头奔跑就是成长，却在日复一日的奔波里，弄丢了自己，胖了心事，累垮了心态，满身疲惫却无从安放。

而脱脂，就是一场自我救赎。

脱脂，是戒掉精神内耗。不再纠结别人的评价，不纠结未发生的琐事，不翻旧账、不胡思乱想。接纳自己的平凡，允许自己做不到、允许自己偶尔偷懒，不必事事完美，不必人人喜欢。

脱脂，是卸下无效负重。远离消耗自己的人际关系，舍弃没必要的应酬，放下不属于自己的执念。人生本就不必事事勉强，合得来就相伴，道不同就随缘走远，把时间留给值得的人和事。', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "99de532e662e1c0363dfd79bcfe63173", "document_id": 159, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[0.02186344,-0.03558203,0.047754355,-0.07339355,-0.04545294,0.00591086,-0.04912082,0.008985406,-0.036085464,0.08716608,0.013997276,-0.0144108115,0.0040184855,-0.06641739,0.022906268,-0.055881225,-0.009816972,-0.09191275,-0.06451153,0.03633718,0.029271118,0.0036701271,0.062066276,0.03536627,-0.04527314,0.005838941,0.024074955,0.038620614,-0.051314354,0.053112336,-0.02080263,0.078751534,0.06375638,0.0076908604,0.06577012,0.009547275,0.031212937,-0.011480103,-0.0063513652,0.03995112,0.03626526,-0.010868791,0.00037251902,0.023175964,0.03612142,0.08637497,0.055090114,-0.023859197,-0.034251522,-0.0049669202,0.02004748,-0.004454496,0.006630052,0.005106264,0.02907334,-0.039663445,-0.008971921,-0.038728494,0.0015518817,0.0236794,0.03637314,0.010437275,0.02447051,0.02283435,0.042036775,-0.06839517,-0.0062479815,-0.028300209,0.01725162,-0.06249779,0.024991926,0.023841217,0.031644452,-0.010706972,0.012495963,-0.024776168,-0.035851724,0.06947395,-0.025027884,-0.0034296473,0.03624728,0.008077426,-0.025801016,0.0509188,0.050019808,0.04613617,-0.02080263,0.0053624758,0.046783444,0.062174156,0.00040679303,-0.016811116,-0.010176568,-0.0014451266,-0.0064817187,0.024776168,0.0024654805,-0.020443035,0.016154852,0.0047152033,-0.007713335,-0.040526472,-0.033658188,-0.05710385,-0.020263236,-0.013871417,0.010104649,0.00095405325,-0.03383799,-0.057715166,0.0012012755,-0.008104396,-0.044374153,0.030116169,0.040634353,0.002771137,0.012846569,-0.025207683,0.01624475,0.028659804,0.010778891,0.06246183,-0.0014855812,-0.016046973,0.005537779,0.018788893,-0.02360748,-0.04455395,-0.015022125,0.02272647,-0.04642385,-0.037757583,0.012037477,-0.022061218,-0.025890915,-0.0013102781,-0.041533343,-0.0073402543,-0.088460624,0.05343597,0.0007736934,-0.011327275,0.028282229,0.035995565,0.0059692943,-0.016271722,-0.07019315,-0.02547738,-0.03833294,0.021467883,0.054802436,-0.021072328,-0.029289098,0.005115254,0.00681884,-0.030367885,0.0052006575,-0.020658793,-0.0064277793,-0.0053939405,-0.014024246,-0.046891324,0.022402834,0.04441011,-0.002059811,-0.01909455,-0.05908163,-0.0043151523,-0.03094324,-0.033999804,-0.008535911,0.015651418,0.0011518311,0.01274768,0.003739799,-0.015309801,-0.025153743,0.046747487,0.032129906,-0.03923193,0.07918305,0.024686268,0.03153657,-0.005834446,-0.017341519,0.028066471,-0.016586367,0.004724193,0.023409702,-0.005726567,-0.0043758345,-0.009960811,-0.018555155,0.0130892955,0.0041870466,-0.043295365,-0.019921621,-0.03177031,0.073861025,-0.00814485,-0.010823841,0.028551925,0.033118796,-0.015903136,0.017062832,-0.0119116185,0.027365258,-0.028641826,0.01832142,0.00916071,-0.021413945,0.00050989597,0.0020227276,0.024686268,0.0022508465,0.0071469713,0.004616314,0.020478994,-0.024902025,-0.0057715164,-0.027940612,0.09069012,-0.008446012,0.052357182,0.004196036,0.040598392,0.052177384,0.027041622,0.009286568,0.033154756,0.028390108,0.0049534356,0.021036368,-0.05009173,-0.0074930824,0.026574148,0.00046747486,0.0073896986,-0.024056975,0.021018388,-0.015714347,0.024740208,-0.04257617,-0.00086415425,0.0017519069,0.050523244,-0.02720344,-0.046064254,0.00059614284,0.019597985,-0.010446265,-0.024021016,0.0018305687,-0.033172734,0.052465063,-0.016927984,-0.010158588,0.011093538,0.02718546,0.00036409099,-0.018465256,-0.01177677,-0.0050568194,-0.039447688,-0.051314354,0.009156214,-0.007884143,0.060412135,-0.008198789,0.030691521,-0.007367224,0.012010508,0.00992485,-0.018393338,-0.004119622,0.0052860617,0.0490489,6.443933e-05,-0.00027728226,-0.039411727,-0.06425981,-0.011722831,0.06688486,-0.022258995,0.009781012,0.006297426,0.018950712,-0.032939,0.043475162,-0.002458738,0.0075784866,0.004809597,-0.04272001,0.037074354,-0.017197682,0.0031621978,0.023841217,0.0030790411,0.053975366,-0.0024317682,-0.0107249515,0.0034543695,-0.022474753,-0.02087455,0.044769708,-0.0129724275,-0.008455002,-0.061814558,0.060340215,-0.022151116,-0.077960424,0.026412329,-0.035725866,0.044841625,-0.015606469,0.016235761,-0.03263334,-0.010805861,0.0038903796,-0.022600612,-0.07044487,0.011623942,-0.044877585,0.0073941937,0.046819404,-0.0035105564,-0.04984001,-0.012846569,0.01824051,-0.058973752,-0.012244245,0.017611217,0.024164854,0.03166243,0.005650153,-0.009547275,-0.020514954,0.0051242434,0.032381624,0.01629869,0.010473235,0.0019609223,-0.03639112,-0.026448289,0.037937384,0.00031998428,0.03437738,0.013466871,0.0063513652,-0.0001042969,0.04333132,0.0025149249,0.013421922,0.05077496,-0.008882022,-0.049192738,0.025207683,-0.026879804,-0.07087638,0.029720614,0.00058434356,-0.021917379,-0.0057715164,-0.024596369,0.056456577,-0.06087961,0.034143645,-0.0013777023,0.020389095,0.022258995,-0.009241618,-0.025171723,-0.017035862,0.006598587,0.027401218,0.018806873,0.012927477,0.025549298,-0.013448892,0.007520052,-0.0052141426,-0.039519604,0.021216167,-0.06828729,0.03750587,0.020083439,0.026268492,-0.01272071,-0.0033599755,-0.028030511,0.020443035,-0.03355031,-0.025153743,-0.02085657,0.020658793,0.023409702,-0.018896772,-0.046639606,0.008612325,0.012486973,-0.022366874,-0.014006265,-0.028929502,0.018770913,0.025890915,-0.00016813925,0.02364344,0.0074076783,-0.016217781,0.0103383865,-0.030313946,-0.04984001,0.047143042,0.02997233,0.015705356,0.0006517678,0.009511315,-0.014257983,0.023104046,-0.002463233,-0.04002304,0.037901424,-0.006005254,-0.016334651,0.0024227784,0.10313214,-0.0013136492,0.022384854,0.04164122,-0.0115160635,-0.035707887,-0.05009173,0.013682629,-0.003935329,-0.004429774,-0.04541698,0.01181273,0.005829951,-0.032255765,0.014950206,-0.07231476,0.021593742,-0.036049504,-0.011039599,0.011408185,0.062174156,0.011992528,-0.027616976,0.028030511,-0.010284447,0.05555759,-0.049552336,0.039303847,-0.027796773,0.00816283,-0.010958689,0.033226673,-0.01913051,-0.013367983,-0.010392326,0.06278547,0.020928489,-0.02089253,-0.0045983344,0.0056007085,0.049768094,-0.02465031,0.062210117,-0.0075829816,-0.0087471735,0.047790315,0.011875659,-0.010158588,-0.045093343,0.013970306,0.0153997,-0.0041735615,0.059836783,0.0051287385,0.05066708,0.018609095,8.104958e-05,-0.0009276454,-0.0059737894,-0.03256142,0.024146874,-0.03380203,0.010365356,0.051673952,-0.04333132,-0.019687884,-0.019687884,0.0009484346,-0.0069581834,0.015912125,-0.0054973243,0.012999397,-0.0064053047,0.023175964,-0.036714755,-0.008081921,0.04894102,-0.024578389,0.034107685,-0.01362869,0.00500288,-0.022294955,-0.0036498997,-0.033010915,0.011111517,-6.4930966e-05,-0.031248895,-0.028066471,0.040670313,0.0022598363,0.011192427,0.012792629,0.03281314,-0.0018755181,0.00048208344,0.035887685,0.015651418,0.013871417,-0.020586872,-0.010041719,-0.016514448,0.0047466676,-0.030529704,0.037721626,-0.019705864,-0.013520811,-0.042144656,0.05721173,-0.008980911,-0.029325057,0.029558795,0.012235255,-0.0038656574,-0.004227501,-0.002081162,0.020514954,-0.005996264,-0.018914752,-0.007520052,-0.033981826,0.012531922,0.019310307,-0.017620206,0.0042252536,-0.04649577,0.021413945,0.086159214,-0.008311164,-0.02447051,-0.008944952,-0.015777277,0.0002625332,0.022870308,0.023337783,0.0020834096,-0.02083859,0.01900465,-0.0129634375,-0.010554144,0.032057986,0.048006073,0.013385963,0.050451323,-0.027940612,-0.0006455873,0.0010900255,0.07310587,-0.01907657,0.030763442,0.078032345,-0.012783639,0.00015353065,0.011093538,0.04994789,0.061275166,-0.0037150767,0.010814851,0.0013529802,0.0035712381,-0.01995758,0.051062636,0.04200082,0.04196486,-0.034647077,-0.0032520967,0.018609095,-0.030403845,-0.061167285,-0.0061266175,-0.013898387,0.01452768,-0.0040274756,0.01818657,-0.0035172987,-0.0034453797,-0.0028250765,-0.03561799,0.0030206067,0.019490106,0.002236238,-0.010823841,-0.0024385108,0.0054343953,0.005196163,-0.0047691427,0.10802265,0.036606878,-0.019903641,0.006252476,-0.022510713,-0.033190716,-0.017062832,0.0103383865,0.036660817,0.011677882,-0.027886674,-0.0052995468,-0.061311126,-0.027922632,-0.012792629,-0.01726061,-0.011444144,-0.0017440408,0.0009523676,0.007173941,0.013403943,0.0040184855,-0.0060591935,0.019256368,0.0034363896,-0.022474753,-0.022564651,0.012981417,-0.006553638,-0.011237376,-0.01273869,0.00017460073,-0.047934152,-0.0041825515,-0.040166877,0.03441334,0.011453134,-0.050343446,0.0172696,0.054083243,0.009025861,0.016990913,-0.012091417,-0.08342628,0.036966473,0.0056681326,0.023319803,0.027509097,0.009165204,-0.013871417,0.015237882,-0.033334553,-0.03916001,-0.031680413,-0.028336167,-0.0062794457,0.0017665155,0.003811718,-0.0015417681,-0.00017797195,-0.02731132,-0.050810922,0.022061218,-0.031230915,0.016757175,0.04534506,-0.031968087,0.022474753,0.044230312,0.007097527,0.030295966,-0.025567278,0.02096445,-0.0597289,-0.017467378,-0.008477476,-0.038656574,-0.030134149,-0.009430407,0.04092203,0.04257617,-0.03826102,0.07645012,0.01809667,-0.0039937636,-0.028533947,-0.017880913,-0.010715962,0.02083859,0.012379094,-0.07001335,-0.032219805,-0.003975784,0.02731132,-0.016613336,-0.0003264458,0.0046882336,-0.02168364,0.019651923,0.031069098,-0.025783036,-0.0015743565,-0.015750306,0.0034431322,-0.0144198015,-0.056780215,-5.1551462e-05,0.053112336,-0.019220408,-0.018627075,-0.011336265,0.050739,0.016064953,0.010644043,-0.07436446,-0.07360931,-0.025027884,-0.009511315,0.012136366,-0.02447051,-0.053939406,-0.010140608,-0.0066974764,0.0074885874,-0.00864379,-0.005151213,-0.03714627,-0.002685733,0.022510713,-0.05170991,-0.032147884,0.016091922,0.053076375,-0.025171723,0.16095519,-0.0022025257,0.012918488,-0.011183437,-0.0040656826,-0.018042732,-0.024722228,-0.0038341929,-0.012181316,-0.0117857605,-0.024758188,0.014105155,0.023823237,0.051673952,-0.01542667,-0.005304042,-0.0036498997,-0.034071725,-0.013287074,0.00021041986,0.057894964,-0.001709205,0.06548244,-0.008252729,-0.0638283,-0.01631667,-0.027113542,-0.027581016,-0.0011945331,0.082922846,0.018483236,0.0052905567,-0.03175233,-0.011444144,-0.004881516,-0.019705864,0.009322528,0.00992485,-0.08997093,0.012873538,0.03195011,-0.033028897,-0.015831215,-0.013394953,-0.01089576,0.028444046,-0.00591985,0.04451799,0.009475356,-0.007974043,0.033280615,-0.03995112,-0.03822506,0.019580005,-0.0456687,0.0037128292,-0.03815314,-0.07253052,0.011677882,-0.042144656,-0.03923193,-0.01177677,-0.02454243,0.008401062,-0.019454146,0.02283435,0.0062434864,0.012073437,0.04732284,-0.024973946,0.052105468,-0.012253235,0.018860813,0.009502325,-0.019310307,-0.0013158967,-0.040454555,0.014428792,0.034071725,0.029810512,0.007061567,-0.013700609,0.009951821,-0.04631597,0.01640657,0.0032745714,0.049480416,-0.021719601,-0.05181779,0.02089253,0.01640657,0.020371115,-0.025854954,-0.008841568,-0.0026183086,-0.010823841,-0.0060142437,-0.0253695,-0.010877781,-0.015291821,0.022258995,-0.0030340916,0.0061625773,-0.039016172,0.035546068,0.031123037,-0.057643246,-0.07310587,-0.01267576,0.041065868,0.011084548,0.013961316,-0.0076638907,0.037038393,-0.021288086,-0.009466366,0.013430912,-0.037865464,0.015013135,0.01271172,-0.0072413655,-0.043619,0.043079607,-0.0038903796,0.020335156,-0.0172696,0.014302933,0.09371073,0.0014440028,-0.010167578,-0.077169314,-0.010455254,-0.0063963146,0.014644549,0.06886264,-0.021521823,-0.0077313147,0.014383841,-0.022187077,0.013475861,-0.026682027,0.0031509604,-0.031842228,0.010617073,-0.046100214,0.031069098,0.03261536,0.003542021,0.03721819,0.0055512637,-0.018914752,-0.033999804,0.04081415,-0.027796773,-0.05016365,-0.019418186,0.033028897,-0.07328568,0.026448289,0.0056906072,-0.019885661,0.023068085,-0.029918391,0.0050478294,0.016451519,-0.011084548,-0.009268588,-0.020335156,0.0027958592,-0.06641739,-0.006180557,-0.010554144,0.039555565,-0.025603238,-0.0056995973,0.007479598,0.01631667,0.040526472,0.0254594,0.032435562,0.0077672745,-0.039771322,-0.01548061,0.01361071,0.033658188,-0.022528691,-0.016676266,0.08234749,0.06577012,0.0049714153,-0.06537456,-0.0012012755,-0.03265132,-0.03804526,-0.0024789653,-0.038980212,0.022492733,0.008446012,0.013439902,0.0104642445,0.029307077,-0.024596369,0.015246872,0.00225197,-0.004236491,0.03175233,-0.022115156,-0.019903641,0.035600007,-0.024146874,0.041317586,0.024722228,0.011066568,0.05800284,0.0066929813,-0.005802981,0.031248895,-0.023751318,-0.019436166,0.033784047,-0.032201827,-0.01457263,-0.018429298,-0.0015451392,0.03558203,-0.0044904556,-0.006630052,0.011210406,-0.002539647,-0.018645056,-0.022007277,0.07407679,-0.06296527,0.01999354,-0.089251734,0.014060205,0.053112336,1.6180065e-05,0.010706972,0.037038393,-0.038656574,-0.004166819,0.002291301,-0.019418186,-0.005573739,0.0123071745,0.0037060867,-0.04908486,-0.008994396,0.01820455,0.019939601,0.019615965,0.03919597,-0.07565901,0.045488898,0.0119116185,0.059585065,0.020586872,0.04631597,-0.02083859,0.035725866,0.041173745,-0.01630768,-0.021629702,-0.038548697,0.029738592,0.041533343,-0.018105661,-0.014959196,0.0038454302,0.004184799,-0.003508309,-0.0024946975,0.011552023,0.000839432,-0.037362028,-0.036768693,-0.0015237882,-0.055737387,-0.01637061]');
INSERT INTO "public"."vector_store" VALUES ('22d4bda6-a223-47c8-ad2e-11aec5e3a21e', '脱脂，是学会适度摆烂，认真生活。不是躺平放弃，而是不再盲目内卷、跟风攀比。别人跑得快，我们可以慢慢走；别人追名逐利，我们可以安于平淡。该努力时全力以赴，该休息时坦然放空，劳逸结合，张弛有度，不透支健康，不辜负自己。
做脱脂牛马，看淡世事繁杂，守住内心平静。不用强迫自己活成万众期待的样子，不用在轨道里循规蹈矩。就像乌海旷野之行感悟的那样：人生从不是既定轨道，而是肆意生长的旷野。

往后余生，褪去浮躁，脱脂前行。少一点逞强，多一点自愈；少一点纠结，多一点松弛；做个清醒通透的脱脂牛马，好好生活，慢慢发光，自在随心，安稳度日。', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "99de532e662e1c0363dfd79bcfe63173", "document_id": 159, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.023229625,-0.04249606,0.053186685,-0.078464516,-0.06700789,-0.028874675,-0.06357757,-0.011698073,-0.031455744,0.10624015,-0.0043878183,0.00571582,0.02447853,-0.035835236,-0.008783963,-0.08206136,-0.046359338,-0.071537256,-0.05202104,0.048557412,0.028325157,0.016685365,0.0718703,0.04679229,-0.035835236,-0.023845753,0.00029661483,0.039998252,-0.07613322,0.050189313,-0.006760737,0.040930767,0.02221385,0.018450484,0.062411927,-0.0025123798,0.028308505,-0.010307626,-0.02156442,0.050755482,0.041063983,-0.0015340712,0.018617004,0.010973709,0.024045577,0.07546714,0.01636065,-0.026609994,-0.003157647,0.015053463,0.020964945,-0.02076512,0.003132669,0.014712096,0.025394393,-0.038099915,0.0010813433,-0.02456179,-0.005195443,0.03173883,0.023879057,0.012164331,0.048757236,0.048990365,0.03693427,-0.049390014,-0.02051534,-0.03676775,-0.004308721,-0.07613322,0.031106051,0.011056969,0.01969939,-0.0036759425,0.012888695,-0.033254165,-0.022680108,0.04749168,-0.03620158,0.02093164,0.010482472,-0.009067047,-0.0077515347,0.011847942,0.06530938,0.070804566,7.610513e-05,0.011548204,0.03843296,0.05232078,-0.0064526736,-0.010757232,-0.001277005,0.029307628,-0.029923754,0.015469765,-0.007322744,-0.007285277,0.024861528,0.024778267,-0.008059598,0.0044086333,-0.030673098,-0.03883261,0.030406665,0.0015850681,0.017884314,-0.0058032433,-0.038099915,-0.021797549,-0.028858023,-0.0065359343,-0.0101827355,0.012280895,0.0363681,0.0076849265,0.025094656,-0.030656446,-0.019532869,0.039365474,0.025028048,0.042296235,-0.00650263,-0.023396146,-0.0010173369,-0.0023063105,-0.024128838,-0.04539352,0.0044086333,0.024894832,-0.06331114,-0.04209641,0.003149321,-0.008105391,-0.004287906,0.014528924,-0.04679229,0.030090274,-0.06504295,0.026476778,0.014312447,-0.006864812,0.05065557,0.04013147,-0.003994413,-0.005241236,-0.07386854,-0.0064443476,-0.03392025,0.014404033,0.05388607,-0.013962753,-0.016935147,0.013304997,0.030889574,-0.0080346195,0.010332604,0.0035843563,-0.037200704,-0.0022084797,-0.056217358,-0.03836635,0.036334798,0.06177915,0.006294479,-0.0054535503,-0.015744524,-0.0112567935,-0.05395268,-0.027092904,-0.014012709,0.010615689,-0.01833392,0.019416304,-0.02093164,-0.013829537,-0.019416304,0.04159685,-0.0013248796,-0.054418936,0.06344435,0.015727872,-0.024911484,-0.009541631,-0.023246277,0.02641017,-0.010274322,-0.008446759,0.022563543,-0.0008674683,-0.009025417,-0.025011396,-0.019233132,0.0053286594,0.022879932,-0.045460127,-0.03295443,-0.0035510522,0.033503946,-0.00820114,-0.015394831,0.014195883,0.021547768,0.014179231,0.037300617,-0.019449608,0.011198511,-0.036567926,0.012039441,-0.012389134,-0.014503946,-0.0047458373,-0.026143737,0.014395707,-0.020748468,0.023612622,-0.023695884,0.019249784,-0.0027330196,-0.010241018,-0.012272569,0.06737424,-0.029923754,0.033404034,0.014687118,0.004229624,0.035235763,-0.004271254,0.002612292,0.055717796,0.030506577,0.015619634,-0.0044294484,-0.08059598,-0.011031991,-0.0020898336,-0.01776775,0.043062232,-0.039432082,0.03926556,0.002989045,0.023795797,-0.045360215,-0.013479844,0.0006426655,0.059014905,-0.007913892,-0.04879054,0.00864242,0.043561794,-0.02391236,-0.03766696,0.0022376208,-0.04226293,0.036068365,-0.0068856273,-0.012255917,0.013463192,0.02133129,-0.021198073,-0.029640669,-0.020565296,-0.0054535503,-0.030639794,-0.049656447,-0.018816829,-0.0053286594,0.084392644,0.018800177,-0.017900966,-0.019849258,0.032621387,0.0068731382,-0.003399102,-0.018034182,-0.0014445663,0.03750044,-0.032171782,0.017900966,-0.021131465,-0.05608414,-0.009549957,0.05871517,-0.010107801,-0.0050330856,0.030323403,-0.0055201584,-0.04159685,0.05701666,-0.026992992,0.015719546,0.0155530255,-0.015827784,0.046825595,-0.019149872,-0.001716203,0.012239265,0.005366127,0.012114375,0.007976337,-0.02487818,-0.005137161,-0.019432956,0.023895709,0.019832605,-0.010515776,-0.014587206,-0.04516039,0.058948297,-0.02569413,-0.06257845,0.05831552,-0.018650308,0.031372484,0.009907977,0.049556535,-0.020298863,-0.004791631,0.0045376867,-0.0009741456,-0.03983173,-0.02586065,-0.08306048,0.0071104304,0.046026297,0.0077099046,-0.03620158,-0.0022605173,0.013871167,-0.048590716,-0.008825593,0.018700264,0.03926556,-0.002131464,0.019116566,-0.005199606,-0.028358461,6.270542e-05,0.027259424,0.016768625,0.018733568,0.035169154,-0.02093164,-0.03222174,0.0165688,0.026626647,0.03806661,-0.00044075926,-0.0014362403,0.009982911,0.028175289,-0.0049997815,0.0027850573,0.038399655,-0.0075725247,-0.029041195,0.01875022,-0.02043208,-0.06028046,0.025311133,0.0055576256,-0.011023665,-0.025078004,-0.005424409,0.031722177,-0.048257675,0.018367223,-0.010807188,0.01691017,0.045992993,-0.0030639793,-0.01994917,-0.022313762,-0.004225461,0.042829104,0.05132165,0.017534621,0.014936899,-0.0072020167,0.01571122,-0.065575816,-0.044860654,0.032821212,-0.06734093,0.021930765,0.006477652,0.030323403,-0.017301492,-0.025111308,-0.04732516,0.025993869,-0.03933217,0.0058823405,-0.011922876,0.021264682,0.0050788787,-0.030340055,-0.07366872,0.020531991,-0.00842178,-0.0060072313,-0.0060738395,-0.038499568,0.010374234,0.003255478,-0.022446979,0.00078524876,0.019283088,-0.020831728,0.03423664,-0.033404034,-0.028308505,0.04579317,0.07020509,-0.0044877306,0.006739922,-0.003086876,-0.007047985,0.026043825,0.0014976448,-0.03312095,0.037034184,0.0034698732,0.004820772,0.0050913678,0.10863805,0.02238037,0.028108679,0.036301494,-0.04935671,-0.025361089,-0.04079755,-0.028025419,-0.001990962,-0.002160605,-0.06487643,0.031472396,0.016702017,-0.03926556,-0.011215163,-0.06291149,0.015386505,-0.033970207,0.007043822,0.012372482,0.07686592,0.0075808507,-0.035502195,0.013304997,0.016618757,0.054485545,-0.07060474,0.061845757,-0.045227,0.009716478,-0.019599477,0.033237513,-0.0074975905,-0.023879057,0.0035052588,0.040198077,0.0012718012,-0.037800178,-0.018050835,-0.005749124,0.056350578,0.0060613505,0.007893077,0.0155363735,-0.0030431643,0.029707277,0.0022188872,-0.008675724,-0.053186685,0.019716041,0.0061654258,-0.0077681867,0.06424365,0.009200264,0.0476582,-0.014237513,0.00960824,0.002862073,-0.0012926162,-0.026593342,0.05305347,-0.020382123,0.0066400096,0.044394396,-0.052886948,-0.028475026,-0.020981597,-0.0054618763,-0.020998249,-0.018367223,0.013171781,0.020631904,0.0009699826,0.009316828,-0.041496936,-0.047758114,0.048257675,-0.011040317,0.036301494,0.003353309,0.0069314204,-0.017834358,-0.0039798426,-0.027359337,0.0069189314,-0.01361306,-0.02577739,-0.011947854,0.034136727,0.014187557,0.0032200923,0.0054951804,0.022263806,-0.008138695,0.0017266106,0.0075600357,0.03740053,0.03117266,-0.023379494,0.01034093,-0.005961438,0.02932428,-0.040597726,0.026260301,-0.031289224,-0.020615252,-0.04719194,0.07766522,0.0027038786,-0.0077473717,0.039631907,-0.013787907,0.0021793386,-0.011131903,0.001488278,0.036967576,0.012805435,-0.0035427262,0.0066400096,-0.024128838,0.0071895276,-0.0006395432,-0.02196407,0.0031430766,-0.044227876,0.011131903,0.06267836,0.00832603,-0.042362843,0.0009991237,-0.0055909296,0.0023625111,0.031405788,-0.003107691,-0.017734446,-0.0076058293,0.01978265,-0.015652938,-0.01260561,0.046026297,0.030373361,0.0091170035,0.01875022,-0.0058823405,0.0036093344,0.0064568366,0.060147244,-0.031039443,0.034602985,0.071603864,-0.011165207,0.001957658,0.022846628,0.07033831,0.050056096,-0.013246715,0.016027609,0.03148905,0.033570554,0.0005248001,0.038299743,0.034702897,0.04419457,-0.020715164,0.0028100354,-0.0037342247,0.009966259,-0.07180369,0.0075641987,-0.010082823,0.02569413,0.026809819,0.027475901,-0.0005365086,0.03750044,-0.0049165213,-0.02229711,0.010066171,0.013912797,-0.006173752,-0.054418936,-0.011115251,0.0047458373,-0.0066733137,0.0024332826,0.11583174,0.012147679,-0.01745136,0.0026393516,-0.01680193,-0.046825595,-0.024678355,0.01978265,0.021597724,-0.008192814,-0.052853644,-0.005761613,-0.062078886,-0.031439092,-0.023329537,-0.030956183,0.0006551545,-0.0044544265,-0.00094344333,0.015819458,-0.016685365,-0.006760737,-0.004795794,0.040597726,0.012106049,-0.012971956,-0.044127963,0.008734006,-0.008126206,-0.026443474,-0.00048759318,0.005711657,-0.03773357,0.019233132,-0.05048905,0.050722178,-0.031039443,-0.04795794,0.008138695,0.07000527,0.033553902,0.021830853,0.002156442,-0.04805785,0.039964948,-0.013962753,-0.013180107,0.011281772,0.02028221,-0.012039441,0.01627739,0.010332604,-0.024278706,-0.03893252,-0.021664333,-0.0074601234,-0.019166524,0.009191938,-0.021697637,0.023546014,-0.012422438,-0.027342685,0.010032867,-0.026143737,-0.0033054342,0.014562228,-0.031938653,0.013013586,0.04755829,0.0155446995,0.023862405,-0.025377741,0.011947854,-0.0460596,-0.011814638,-0.02213059,-0.03093953,0.013454866,-0.034269944,0.029740581,0.04732516,-0.03383699,0.08672394,0.026626647,0.011098599,-0.03417003,-0.012447416,0.004342025,0.039465386,-0.004221298,-0.084725685,-0.010499124,-0.030456621,0.0230298,0.015736198,0.032338303,-0.03417003,-0.020865032,0.010690624,0.035768628,0.0087673105,0.012114375,-0.02221385,-0.007047985,0.0026393516,-0.05348642,-0.02529448,0.04539352,-0.010066171,-0.025810694,0,0.03826644,0.01069895,0.042895712,-0.0896547,-0.047991242,-0.009050395,-0.012230939,-0.008967135,-0.012430764,-0.04958984,-0.024778267,0.0008149103,-0.005178791,-0.024928136,-0.023462754,-0.036068365,-0.025943913,0.016119195,-0.053586334,-0.017085016,-0.001763037,0.06747415,-0.0023750002,0.14880282,-0.017434709,0.018050835,-0.023329537,0.008817267,-0.045093782,-0.03766696,0.017018408,0.0044585895,0.00018707551,0.0050872047,0.0040235543,0.008542508,0.030506577,-0.005707494,-0.002418712,-0.0091003515,-0.05355303,-0.02471166,-0.01850044,0.05025592,0.0036717795,0.051421564,-0.023212973,-0.04482735,-0.0012863717,-0.020065734,-0.028308505,0.010032867,0.03593515,0.013379931,0.0067024548,-0.014070992,-0.03773357,0.011090273,0.005157976,0.034702897,0.010290974,-0.08825593,0.011714725,0.025361089,-0.01720158,-0.017751098,-0.0020409182,-0.023879057,-0.0025352763,-0.0030077787,0.05145487,-0.009042069,-0.0068981163,0.009400088,-0.028308505,-0.04056442,0.032904472,-0.06271166,0.047358464,-0.023695884,-0.082127966,0.008142858,-0.034503073,-0.019333044,0.016035935,0.006714944,-0.014911921,-0.014570554,0.0014560146,-0.04192989,0.008167836,0.029390888,-0.028491678,0.05098861,-0.026926383,0.028891327,0.013554778,-0.027942158,0.02739264,-0.02019895,-0.012855391,0.025810694,0.03966521,0.0031742991,-0.009491675,-0.0036197419,-0.019716041,0.008542508,-0.012996934,0.029024543,-0.0007051107,-0.010157757,0.0238291,0.03133918,0.0135298,-0.012938652,-0.018383875,-0.0016110869,-0.007376863,-0.044560917,-0.015378179,-0.027725682,0.012797109,0.0065276083,0.006302805,0.01348817,-0.043095537,0.0101744095,0.032671344,-0.056317274,-0.06587555,-0.029790537,0.034836113,0.0363681,-0.028858023,-0.0071936906,0.050122704,-0.04086416,-0.0018587863,0.0058365474,-0.049390014,0.015244963,0.015777828,-0.008405128,-0.044694133,0.021281334,0.0130468905,0.043062232,-0.018150747,0.021098161,0.089787915,-0.0012072745,-0.0063652503,-0.058914993,-0.010549081,-0.011331728,0.0101827355,0.09804734,-0.002882888,-0.023063105,0.01069895,0.0022896584,0.0047250222,-0.02649343,-0.0038424633,-0.02674321,-0.014637162,-0.03322086,0.02084838,0.061279587,0.016776951,0.012971956,0.025993869,0.001953495,-0.026909731,0.04266258,-0.03338738,-0.054718673,-0.016327346,0.040697638,-0.070138484,0.02972393,0.036334798,-0.021747593,0.012655566,-0.07167047,0.0014893188,0.023096409,-0.020998249,-0.012622262,-0.014687118,0.004570991,-0.05258721,-0.008975461,-0.009025417,0.02019895,-0.055151626,0.0047791414,0.011290098,0.021914113,0.04409466,0.028708154,0.007364374,0.04192989,-0.031056095,-0.028291853,-0.00013516791,0.0144789675,-0.00061924855,-0.01954952,0.051987737,0.024978092,0.022763368,-0.049456622,-0.009325154,-0.043328665,-0.009366784,-0.016968451,-0.03570202,-0.011423314,0.012505698,0.019033305,0.0270596,0.027992114,0.0027642422,0.017334796,-0.022030678,-0.015761176,0.03546889,-0.03939878,-0.009500001,0.017984226,-0.04795794,0.06714111,0.02665995,0.03463629,0.0411972,0.0083801495,0.0080387825,0.03382034,-0.017026734,-0.015078441,0.018050835,-0.01760123,-0.017701142,0.010940405,0.028158637,0.04159685,0.00068637717,-0.014720422,0.006494304,-0.009017091,-0.012189309,-0.015136723,0.03312095,-0.07466784,0.020382123,-0.06401052,0.01699343,0.04086416,-0.0017505479,-0.012280895,0.034769505,0.002616455,0.020065734,0.01591937,-0.031971958,-0.0238291,0.020831728,0.012064419,-0.058448736,0.015494743,0.039232258,0.03423664,0.026909731,0.04622612,-0.06254514,0.01191455,-0.008184488,0.046925507,0.005428572,0.034136727,-0.008463411,0.021347942,0.04402805,0.009300176,0.009599914,-0.028741458,0.037034184,0.031888697,-0.01906661,-0.026560038,-0.016285716,0.010723928,-0.008717354,-0.044560917,0.013887819,0.0066566616,-0.03593515,-0.03263804,-0.023629276,-0.06684137,-0.009067047]');
INSERT INTO "public"."vector_store" VALUES ('3902f23d-2612-493c-bea4-e1362a928fec', '# 乌海之行——骑行

**操作**: 更新  
**分类**: article  
**时间**: 2026-05-09 20:44:03  
**标签**: 自由  

## 简介

乌海骑行之旅，是宁夏大学生第八届五一内蒙骑行活动，象征挣脱束缚、奔赴自由的青春约定。

## 内容

乌海之行，我觉得不是偶然，而是必然，是图谋已久的的叛逆。当车轮碾过风沙，当帐篷扎进沙丘，我们终于明白 ——人生从来不是预设好的轨道，而是一片可以自由驰骋的旷野。
![微信图片_20260509193343_349_49.jpg](http://118.89.135.164:9000/default/content/image_ef27f169-111b-42ef-a764-f85b1f6a8e39.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T113406Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=eeb129310a7f0ab505cb113baae747e4ca731908a6f44236bf48d34502f7d6db)

这是宁夏大学生第 8 届五一内蒙骑行，也是我们跨越山海奔赴乌海的约定。从银川到乌海，百公里的路程里，有斜坡的陡峭，有滑坡的惊险，更有风沙里并肩前行的温暖。累计超 1000 人曾踏上这段旅程，有人为了挑战自我，有人为了遇见风景，也有人，只是想在旷野里，找回最真实的自己。
![微信图片_20260309135441_242_49.jpg](http://118.89.135.164:9000/default/content/image_9af59b41-3ca4-4e40-adaa-95ae5460e909.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T113055Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=75bf2be410073887e1300e9d9aed548c0a11e766dc300f59895a20a23abd8d1a)
![微信图片_20260509192637_346_49.jpg](http://118.89.135.', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "6036ba2661a514b7f646a3f84e9f8ccb", "document_id": 160, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[0.029541086,-0.055266023,0.07407419,-0.047633722,-0.06848625,-0.033118725,0.042931683,0.02362946,-0.03470311,0.07925325,0.025690863,0.06753222,0.0057199653,0.009097428,-0.03347649,-0.056935586,-0.04562343,-0.032573562,-0.04436274,0.071484655,-0.0260827,0.02213026,0.059865844,0.01257285,-0.010187756,-0.016031235,0.065147124,0.0586733,-0.048110742,0.022028042,0.01727489,0.0051023965,-0.0036798585,0.028570011,0.056935586,-0.015605326,0.0172323,-0.0175134,-0.0027513755,-0.00343709,0.0075258217,-0.018092638,-0.0014779061,-0.023186516,0.048553687,0.0023574093,-0.026832301,0.01525608,-0.004731855,0.012010649,0.0028024847,0.011542149,0.010366638,0.0033774627,-0.054720856,-0.068997346,0.053221658,-0.03003514,-0.020562913,0.0045401957,0.024447208,0.019711094,0.043817572,0.020443657,0.0597977,-0.0544142,0.016031235,-0.006341793,0.021346586,-0.039183676,-0.025810119,0.004599823,0.0090378,0.0018484474,-0.019131856,-0.0033497785,-0.013441705,-0.0091315005,-0.03456682,-0.014966461,0.023425024,-0.02914925,-0.026253063,-0.028655194,0.05870737,-0.017291928,0.030938068,0.022794679,0.05485715,0.044124227,-0.026917484,-0.02989885,0.0032752443,0.0014555459,-0.033067618,-0.016124936,-0.037991133,-0.015324226,0.017530438,0.007751554,-0.039694767,-0.005345165,-0.017598582,0.007491749,0.05363053,0.03473718,-0.03587862,0.012973204,-0.0249583,-0.022096187,-0.036083058,0.011226975,0.054584567,0.0014576754,0.043204263,0.009225201,0.053085364,-0.011014021,-0.013952796,0.011703994,0.015750134,0.027309319,-0.018944457,-0.034021653,-0.029864777,0.018535582,-0.00051561673,-0.030239578,0.0042292816,-0.020119967,-0.05339202,-0.025094591,-0.0036521743,0.0014747118,-0.00034099384,-0.048553687,-0.029609231,-0.0043208525,-0.087703295,0.027752265,-0.009063355,-0.009642592,0.07550524,-0.010494411,-0.05267649,0.0008997339,-0.040512517,-0.021193258,-0.005238687,0.020051822,-0.00081774633,0.022573207,-0.0072489805,0.011201421,0.043067973,-0.067123346,0.016814908,-0.0009801243,-0.032505415,-0.022402842,0.010835139,-0.020971786,-0.010537002,0.05400533,0.022913933,-0.046338957,0.017973382,-0.0019059452,-0.073052004,-0.013407633,0.023987226,0.008066727,-0.028024849,0.021874715,-0.04279539,-0.024140554,0.00833079,0.024532389,0.031346943,-0.031704705,0.078162916,0.008386159,0.0133054145,0.010025911,-0.03451571,0.0019027509,0.035844546,0.043340556,0.03489051,0.0054686787,-0.0022126,-0.017922273,0.011116239,0.0022211182,0.060138427,-0.040989533,-0.015145344,-0.005221651,0.021312514,-0.014242415,0.0042356704,-0.077208884,0.021278441,-0.0019155282,0.04327241,-0.015545698,-0.0003835848,-0.026764156,-0.027820412,-0.018194856,0.025299028,-0.0068826983,-0.0014629993,-0.0084926365,-0.06998546,0.028927777,-0.05451642,-0.0066740024,0.01940444,-0.003281633,-0.014532033,0.0013032831,-0.04647525,-0.011124757,0.00781544,-0.01017072,0.01879113,0.019387402,0.007921917,0.065521926,-0.048247032,0.00059627334,-0.059763625,-0.052063182,-0.032437272,-0.042931683,-0.0048425915,-0.05870737,-0.020256259,0.010537002,-0.0008161492,0.011840285,-0.006886957,-0.0062821656,0.006661225,-0.047940377,-0.029455904,-0.04896256,0.047531504,-0.024447208,-0.039047386,0.050121035,-0.018944457,0.005626265,0.0070360256,0.012445076,0.013731323,0.029251467,-0.012692104,0.006520675,-0.050257325,-0.029932922,0.0032539489,-0.038502224,-0.016516771,-0.031704705,-0.02867223,0.0434087,0.006695298,-0.03499273,-0.02335688,0.02218137,-0.0050129555,-0.0058605154,0.0033604263,-0.056049697,-0.014242415,-0.0434087,-0.0072447215,-0.020443657,0.024992371,-0.028161138,0.02410648,-0.03083585,-0.029728485,-0.00050629996,-0.013100977,-0.01115883,0.03046105,-0.020801421,-0.0171386,0.009438155,-0.020256259,0.028331503,0.0042250226,-0.020562913,-0.02613381,0.012658032,-0.011005502,0.019182965,-0.043817572,0.008684295,-0.005532565,0.021448804,0.006111802,-0.021908786,-0.018194856,-0.006171429,0.088929914,-0.013339487,-0.02805892,0.026116773,-0.052574273,-0.0057412605,0.013083941,-0.026048627,0.0097703645,-0.03526531,-0.03874073,0.0049788826,-0.012181013,-0.05451642,-0.020358477,-0.008799291,0.012589886,-0.020171076,-0.050325472,-0.0012351377,-0.008969655,-0.0019985805,0.016457144,-0.017343037,0.017445255,0.026542682,-0.019148894,0.0046637096,-0.008445786,0.015145344,0.02792263,0.05240391,-0.012649514,0.085113764,0.019097785,-0.023271697,0.01879113,0.041466553,0.051960964,0.015503108,0.019302221,0.009105946,-0.014089088,0.024174625,0.048928488,0.024617571,-0.0015929017,0.06218279,0.030120322,0.0077089625,-0.023953153,0.040137716,-0.030801779,-0.033306126,-0.027718194,0.03666229,0.058366645,-0.027104883,-0.007449158,-0.008739664,-0.01054552,0.018893348,0.0129561685,-0.042454664,0.028229285,0.04402201,-0.014387224,0.050700273,0.015051643,-0.013910206,-0.012393967,-0.0029047031,-0.028144103,-0.023731679,0.0072660167,-0.02221544,-0.021959895,0.010366638,0.06756629,-0.012291749,0.020801421,-0.03492458,-0.008156167,0.00070381555,0.019012602,-0.009548892,0.015383853,0.001704703,0.0048042596,-0.010051466,0.045146413,0.014855725,-0.005042769,0.0052514644,-0.013782432,0.03587862,0.0020560783,0.011048093,0.014191306,0.023016151,-0.07802663,0.028450757,0.0030921032,-0.007909141,-0.010128129,0.06978102,-0.034669038,0.008151908,-0.022590242,-0.023152443,0.011695476,-0.012751732,-0.028041884,0.038127422,-0.07509637,0.015060161,-0.0020251998,0.0845686,-0.0027535053,0.03601491,0.065453775,-0.04736114,-0.05782148,-0.028314466,0.005988288,-0.004408164,0.025350137,-0.03935404,0.031534344,0.0342772,-0.04180728,-0.008910027,-0.024634607,0.013228751,-0.00070700987,0.035776403,0.028178176,0.10071909,-0.008603373,-0.0017813666,0.035094947,-0.007725999,-0.0048553688,-0.04933736,0.04231837,-0.011661403,0.020273294,-0.022419877,-0.016610472,-0.03959255,0.029643305,0.006503639,-0.009872583,-0.04044437,-0.048383325,0.021602131,0.03328909,0.051279508,0.03809335,-0.016303817,0.037343748,-0.0025341618,0.02189175,0.00021255547,-0.0021178352,-0.009216682,-0.025264954,0.022811715,0.026764156,0.049644016,0.024856081,-0.03305058,-0.012990241,0.019745165,-0.010136647,0.012973204,-0.0262701,0.04391979,0.013458742,-0.032607634,0.019234074,-0.0061373566,0.016397517,-0.01718971,-0.008036913,-0.028927777,0.0010653062,0.026593791,0.048281107,-0.013458742,0.01855262,-0.032403197,-0.07386975,0.004459273,0.021227332,-0.033084653,0.019642947,-0.002970719,-0.021312514,-0.001973026,-0.022845788,0.034634963,-0.026713047,-0.021465842,-0.0152731165,-0.029200358,-0.03403869,-0.0067038164,0.015085716,0.037173383,-0.014881279,-0.010272938,0.0016908608,0.047531504,0.011601776,-0.044601247,-0.010996984,-0.015733099,-0.004774446,-0.03874073,0.06402272,-0.033629816,-0.01855262,-0.030307723,0.038536295,-0.007832477,-0.010724402,0.0062608705,0.025776045,0.0075173033,-0.011925467,0.038025204,0.052437983,-0.012010649,0.0037586517,0.005166283,-0.015664954,0.019711094,0.053051293,0.008680036,-0.0004557232,0.0075343396,-0.009310382,0.061910212,0.03173878,-0.020835495,-0.0029664598,-0.014898316,-0.016363444,0.01106513,0.019148894,-0.072711274,0.033595745,-0.0060862475,0.03224987,-0.022436915,0.0140039055,-0.024804972,-0.03395351,-0.0066825207,-0.04708856,0.019745165,0.030597342,-0.026815265,-0.025060518,0.013245787,0.031755816,0.006435493,0.042556882,0.013901687,0.08920249,0.03366389,0.0045785275,-0.0106988475,-0.0112184575,0.006273648,0.0016461404,-0.03003514,0.039865132,0.02156806,-0.0014470277,0.01855262,-0.014097606,0.044703465,-0.0035009764,0.013288378,0.0027748006,0.035129018,0.011235494,0.06201243,0.0045785275,0.016065309,-0.03700302,0.08552264,0.01967702,-0.010324047,-0.0077430354,-0.018331146,-0.039251823,-0.0065845614,-0.0003955635,-0.037445966,0.058025915,-0.062421303,-0.026627865,-0.0052940557,-0.027155992,-0.03713931,-0.029064067,-0.017061936,-0.01162733,0.0020784386,-0.026406392,-0.026730083,-0.025162736,-0.036798585,-0.0017973382,0.013577996,-0.033697963,0.00075971615,-0.01360355,0.023186516,0.057889625,0.0031346942,-0.025077553,0.070871346,0.047327068,-0.0036308789,-0.047190778,0.013782432,0.053187583,0.015988644,0.01346726,-0.014157233,0.006222538,0.034873474,-0.008705591,0.03216469,-0.026253063,-0.041841354,0.020937713,0.028348539,-0.027394501,-0.0035989357,0.0056944108,-0.10473967,-0.009574447,-0.02914925,-0.02773523,-0.0339024,0.0340898,-0.014080569,0.029779594,-0.044294592,0.0002078971,-0.033203907,-0.016601954,-0.056901515,0.035810474,0.004092991,-0.024515353,0.063239045,-0.038059276,-0.014634252,0.009753329,-0.057889625,0.015290152,-0.011124757,-0.025776045,-4.5718727e-05,0.015886426,0.000626087,0.026406392,-0.0266449,-0.03564011,0.01181473,0.008910027,-0.0060138428,-0.022675425,0.059150316,-0.04317019,0.031432126,0.036287494,-0.01525608,0.09008839,0.05230169,0.0853182,0.0034008876,-0.010656257,0.007368235,0.02998403,0.00983851,-0.06524934,0.00072670815,-0.043374628,-0.007883586,0.030290687,-0.02386797,-0.03248838,-0.036048982,0.013901687,-0.031772852,-0.017394146,0.01464277,0.028382612,-0.05550453,0.0090378,-0.030375868,-0.0019772851,0.02386797,-0.033970546,-0.030052178,0.06501083,0.004446496,0.0050725825,0.0113888215,-0.12913577,-0.058605153,0.025827155,-0.011465485,0.016755281,0.021874715,-0.026253063,-0.07312015,0.0036734699,0.007193612,-0.032181725,-0.020937713,-0.059014026,-0.008028395,-0.046918195,-0.043544993,-0.053937186,-0.025264954,0.052369837,0.011363267,0.09921989,-0.050666198,-0.0069423257,-0.04712263,-0.031670634,-0.03996735,0.005340906,-0.0033114466,0.0860678,0.026951555,0.024685716,-0.0026065663,-0.0077898856,0.0080837635,-0.012351377,0.04708856,-0.01892742,-0.05932068,-0.0018303463,-0.021295477,0.0043868683,0.003946052,-0.0087822545,-0.030989178,-0.028416684,0.026014555,-0.0006383319,-0.012555813,0.009523338,0.014191306,0.035708256,0.029541086,0.006158652,-0.016559362,0.040035497,0.01181473,0.0033774627,0.06954251,-0.056833368,0.010647738,0.009046319,0.009387046,-0.03451571,0.0074832304,0.029745523,-0.06422716,0.014319079,0.009472229,-0.005817924,-0.03724153,0.043204263,-0.059116244,-0.017223781,0.04562343,-0.0030005327,0.007312867,-0.02546939,-0.055777114,0.046850048,-0.0075982264,-0.02226655,0.030205505,0.0024383322,-0.0037629108,0.03139805,-0.0061842063,-0.03361278,-0.023646498,-0.0065973387,0.0007048803,0.06044508,-0.042216152,-0.017308963,0.00069157063,0.03405573,-0.021261405,-0.042250227,0.044294592,0.016934164,0.021823606,-0.018774092,-0.016363444,0.014957943,0.009932211,-0.03018847,-0.0029579417,0.011303639,-0.008019877,0.010272938,0.0064397524,-0.0165764,0.050768416,-0.019659985,-0.03979699,0.023407988,-0.020750312,-0.03771855,0.045282703,-0.021039931,-0.002523514,-0.0026534165,0.00804969,-0.043613136,-0.015971608,0.012930614,0.051824674,0.008901509,-0.013339487,-0.029643305,0.015145344,0.045759723,-0.027854484,-0.011908431,0.049780305,-0.033067618,-0.006337534,-0.013237269,-0.011916949,0.0068826983,-0.03587862,-0.0087822545,-0.042113934,0.016414553,0.02415759,0.04044437,-0.03460089,-0.016312335,0.07175724,0.010008874,0.008501154,-0.010562557,-0.017496364,-0.035094947,0.00016823427,0.07134837,0.0028897962,-0.011780658,-0.014131678,-0.011482521,0.024753863,0.012734695,0.00414197,-0.021721387,0.00026619347,-0.0033519082,0.02725821,-0.008415973,-0.0130157955,0.014847207,0.013586515,0.03344242,-0.021670278,0.058128133,-0.021414733,-0.0072021303,-0.020324403,-0.004995919,0.0044039045,-0.017343037,0.034686074,-0.004995919,-0.05424384,0.0029494236,-0.0051023965,0.012010649,0.03775262,-0.02829743,0.0029685895,-0.018620765,-0.0065973387,-0.020392548,0.022862824,0.007257499,-0.050257325,0.005396274,0.008130613,-0.002627862,-0.0010775512,-0.018228928,0.008620409,-0.0017366462,-0.035129018,-0.0015577641,0.0035797697,-0.021976933,0.040035497,0.01195954,0.03949033,0.050086964,0.007823958,-0.044294592,-0.061092466,-0.011244012,-0.02132955,-0.01940444,-0.024992371,-0.04548714,-0.0035648628,0.016346408,0.03819557,-0.010085538,0.06228501,0.0065078977,-0.01619308,-0.03139805,0.009531856,-0.047667798,0.0021103818,0.0043868683,-0.044941977,0.035333455,-0.0035797697,0.062966466,0.047327068,0.03230098,-0.0070786164,0.008424491,0.0051535056,0.010562557,0.0010466727,-0.009455192,0.030307723,0.03395351,-0.016644545,0.039251823,-0.01577569,-0.0070317667,-0.028263357,-0.015298671,-0.024038335,-0.0031474715,-0.055777114,-0.05165431,-0.0013000888,-0.053528313,0.014957943,-0.010562557,-0.017581547,-0.01412316,0.007453417,0.015230525,0.048281107,0.04463532,-0.04105768,-0.030018104,-0.007381012,0.03328909,-0.0040951204,0.02471979,0.03587862,0.048144814,-0.03224987,0.038400006,-0.029132213,0.018722983,0.017854128,0.014889797,0.01836522,-0.014727952,0.0152731165,-0.026713047,0.060104355,0.012163976,-0.025009409,0.007270276,0.015281634,0.001033363,-0.025997518,0.026491573,-0.029558122,0.07380161,-0.043953866,-0.033629816,0.011712512,0.038434077,-0.050018817,-0.006384384,-0.053357948,-0.0068273298,0.0061756885]');
INSERT INTO "public"."vector_store" VALUES ('b08883dd-a7d7-44bb-bebf-d81182caaa58', '164:9000/default/content/image_808ac6a2-b8ce-407b-883b-aa5ed7915cdc.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T112810Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=63877be98f06e69fb8206368bc8260df1f39f374b7f4c3ff6cc5df1666a485f0)

![微信图片_20260509192655_347_49.jpg](http://118.89.135.164:9000/default/content/image_7a8246a6-ca7e-4272-b58f-10a602a3eaef.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T112820Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=7480b894642b48d6088fd531066b0e8b5ae4ac1fbdcc2ac006cc76a58135c1bd)

![微信图片_20260509192726_348_49.jpg](http://118.89.135.164:9000/default/content/image_f73cf8f2-f4e6-4cca-bc0f-7f1d537bf8f2.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T112831Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=a6b6f295d037c74401e405d1c473bc2348a8930e076bdd4e2a1463282c1138db)

#### 🌪️ 风沙里的奔赴，是青春最滚烫的注脚
我们租来全新的单车，背上帐篷与行囊，在后勤车的陪伴下出发。没有精致的装备，没有舒适的旅途，只有车轮与地面的摩擦声，和耳边呼啸的风沙。
有人第一次骑行百公里，腿酸到发抖却不肯停下；有人在无人区里信号全失，却笑着说 “正好可以专心看风景”；我们在沙坡上滑沙、放风筝，在篝火晚会上唱歌、拔河，看牛羊与骆驼从眼前走过，追着初阳与落日按下快门。', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "6036ba2661a514b7f646a3f84e9f8ccb", "document_id": 160, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.004680245,-0.040211443,0.027838692,-0.06456131,-0.055461578,-0.04650572,0.025842506,-0.031759128,0.0007929666,0.1039455,0.064273566,0.023037056,-0.00031049896,-0.022641417,-0.071826704,-0.026435966,-0.05024632,-0.09070954,-0.08265286,0.04941907,0.040067572,0.037190188,0.05733188,-0.03733406,0.007863351,0.00067213894,0.048951495,0.05783542,-0.034258854,0.0152141685,0.0060155313,-0.0102057215,0.006289782,-0.012840327,0.01108692,0.0050174384,0.01739019,-0.024619618,-0.008124114,0.019476295,-0.00068225473,-0.020843051,-0.0198,0.0070900545,0.018451225,0.034402724,-0.021040872,0.026561853,-0.02605831,0.045642506,0.025554767,-0.03537384,0.0005189969,0.037405994,-0.008465803,-0.0106912805,0.015133242,-0.0037158718,-0.03920436,0.046433784,0.024403814,0.012354768,-0.019044686,-0.0035450272,0.06463324,-0.032388553,0.052044686,0.033071935,0.0035630108,-0.041290462,-0.034025066,0.01601444,-0.019170571,0.033737328,-0.01724632,0.038269207,0.019638147,0.02118474,-0.03580545,-0.020950953,-0.011572479,-0.05690027,-0.03787357,-0.0030122616,0.040966757,0.016140327,-0.018181471,0.014593733,0.025806539,0.05262016,-0.014171117,-0.0035158037,-0.014045231,-0.010349591,-0.057259943,-0.032298636,-0.043736238,0.007553133,-0.0236485,0.01713842,0.022029972,0.08049482,-0.039096456,-0.049383104,0.041542232,0.06492098,-0.03916839,-0.014917438,-0.024673568,-0.019098638,-0.008303951,-0.028899727,0.008308447,0.036326975,0.025554767,-0.015834603,0.02152643,-0.031651225,-0.02271335,0.031255584,0.025626702,0.028108446,-0.015807629,-0.04812425,0.009693188,0.0602812,0.039635967,-0.009185149,0.014557765,0.0010261921,-0.07948773,-0.031489372,-0.029996729,-0.0207891,-0.0061099455,-0.032928064,-0.0022783037,0.017381199,-0.06092861,0.02217384,-0.013766484,-0.027155312,0.13890572,-0.005561444,-0.0016151567,-0.016023433,-0.01724632,-0.038089372,-0.0067663486,0.0086141685,0.02566267,0.043592367,-0.05373515,0.055353675,0.028647956,-0.03138147,0.015789645,0.009846048,-0.054994002,-0.039887737,0.016634876,-0.011860218,-0.004280109,0.014279018,-0.025087193,-0.034007084,-0.0338812,0.01758801,-0.053195637,-0.0012127724,0.021418529,0.040139508,-0.012849319,-0.0024570164,0.0013217983,-0.016239237,0.02620218,0.032388553,-0.00012736078,-0.054706264,0.06556839,0.015717711,0.009203133,0.031417437,0.0035427792,-0.003088692,0.042045776,0.015349045,0.028827792,0.005610899,-0.022929154,0.005516485,0.0045566075,-0.005574932,0.012237874,-0.028737873,-0.040858854,0.04600218,0.01985395,0.008542234,0.01152752,-0.04409591,-0.022101907,0.02373842,0.048304085,0.00482861,-0.04078692,-0.042729154,-0.0031808582,-0.014638691,0.024637602,-0.019080654,-0.04222561,-0.005404087,-0.041218527,0.008996321,-0.07581907,-0.0132539505,0.002106335,0.038413078,0.0014521797,0.01256158,-0.03690245,0.0050084465,0.003965395,0.012498637,0.014270027,-0.020069754,0.011068937,0.008762534,0.023342779,0.0236485,-0.092076294,-0.05251226,-0.03393515,-0.046757493,0.015465939,-0.029978745,-0.033953134,0.028072478,0.013415803,0.03704632,-0.023306811,0.014737601,0.038880654,0.0041946867,-0.024511715,-0.026957491,0.008713079,0.0009666212,-0.0098370565,0.019979836,0.00085309945,-0.027874658,0.008263487,0.0063032694,0.009194141,0.02792861,0.023882288,0.013730518,-0.05517384,0.00822752,-0.009576294,-0.03467248,0.00349782,-0.026292097,-0.007872343,0.05585722,-0.016194277,-0.016913623,-0.031992916,0.0070136236,0.0006434775,-0.050210353,-0.0038979563,-0.0015657016,-0.015447956,-0.013712534,0.0071799727,-0.021112805,-0.049526975,0.0005406335,0.007935286,-0.035787463,-0.019817984,-0.0009514475,0.014593733,0.07197057,0.02684959,-0.026094276,0.0025469344,0.039923705,-0.043412533,-0.0044329697,-0.013856403,0.007975749,0.0019973093,0.021310626,-0.012606539,0.009045776,-0.03708229,0.033611443,-0.025428882,0.020069754,0.016122343,-0.0052242507,-0.010421526,-0.019674113,0.040031604,-0.032874115,-0.041937873,0.041650135,-0.024979291,0.0070855585,0.035643596,-0.031453405,0.015681744,-0.03231662,0.0008508515,-0.014135149,0.02472752,-0.031147683,-0.024961308,0.008663624,0.028899727,0.0023558582,-0.053123705,-0.031291552,0.017408174,-0.020555312,-0.024134059,0.009131199,-0.014683651,0.010952043,-0.0026975477,0.024619618,-0.038413078,0.032334603,0.019026702,0.050174385,-0.023180926,0.069273025,0.009000817,-0.014153133,0.03343161,0.0063032694,0.024349863,0.021418529,-0.009279564,0.0082455035,-0.043088827,0.003605722,0.009549319,0.018595094,0.015717711,0.038233243,0.027604904,0.028360218,-0.066575475,0.030752042,0.015411989,0.0018455721,-0.063734055,-0.0006333617,0.041218527,-0.010637329,0.039564032,0.016149318,-0.017030517,0.03625504,0.022227792,0.00699564,-0.0035023158,0.037621796,0.0017736375,0.022227792,-0.0024929836,-0.02472752,0.005966076,0.0454267,-0.022947138,-0.014566757,-0.0021816415,-0.02600436,0.0015106266,-0.008533242,0.024619618,0.00048106266,-0.0008407357,-0.03132752,0.011509537,0.019440327,-0.018810898,-0.015789645,0.025446866,-0.009441417,-0.0055839233,-0.013676566,0.062331334,0.02192207,-0.02866594,-0.00936049,-0.00026399439,0.07740163,0.009450409,-0.060497,0.027568936,0.047764577,-0.04733297,0.0062493184,-0.03255041,0.016230244,-0.01877493,0.030877927,-0.024134059,-0.01852316,0.0019950613,-0.026831606,-0.0007671151,0.046721525,-0.013298909,0.025159128,-0.08186158,0.0169406,-0.0023783378,0.1039455,-0.029996729,-0.02206594,0.023037056,-0.023378747,-0.06305068,-0.015690735,-0.009113215,0.017030517,0.018936785,-0.004932016,0.010034877,0.04262125,-0.042333513,-0.021868119,-0.024026157,0.013784468,0.012327792,0.017309263,-0.016805721,0.05610899,0.01620327,-0.00017618357,0.011446593,-0.011896185,0.012804359,-0.039312262,0.0031538827,-0.0072968663,-0.02373842,0.00753515,-0.009288556,-0.03620109,-0.044167846,0.009630245,-0.018298365,-0.024062125,-0.022209808,0.007152997,0.009068256,0.024295911,-0.0055839233,-0.0052737053,-0.024601635,-0.010160763,0.017318256,0.029547138,0.029079564,-0.042297546,-0.0018905313,-0.013478746,0.020411443,0.041434333,-0.008704087,-0.04290899,-0.03147139,0.02571662,0.0008087023,0.008771526,-0.036524795,0.05772752,-0.026507901,0.012147956,0.012085013,0.008088147,0.032046866,-0.0108171655,0.0470812,0.03906049,-0.07304959,0.012669482,0.014171117,-0.016194277,-0.0010615974,-0.03359346,-0.031687193,0.013433787,0.013415803,-0.028540054,0.021094821,-0.0086726155,-0.006289782,0.0093425065,0.0064651226,0.031435423,0.0023940734,-0.030086648,0.015447956,-0.010943051,0.0043520434,0.017659945,-0.04215368,0.051900815,0.0064066756,-0.030068664,0.03906049,0.031417437,-0.002259196,-0.0017185626,-0.011779292,-0.0003436563,-0.01906267,-0.019152587,0.08862343,-0.0313455,0.0063077654,-0.058950406,0.05769155,-0.019889917,-0.018918801,-0.02605831,-0.0015274864,-0.025500817,0.008654632,0.028629972,0.062978745,-0.027101362,0.008794005,-0.010952043,-0.010142779,-0.01369455,0.034204904,-0.008110627,0.011275749,0.0015600817,-0.0011599455,0.027766757,0.028899727,0.012705449,0.040571116,-0.01739019,-0.017201362,0.03044632,-0.0019849455,-0.019350408,-0.03747793,0.002935831,0.055929154,0.009000817,0.0009149182,-0.018253405,-0.028540054,-0.00709455,-0.044203814,0.01586158,0.013244959,0.011959128,-0.010034877,0.035841417,0.04010354,0.004217166,0.0043835146,0.044023976,0.14545177,0.025356947,0.0045700953,-0.015942506,-0.004558855,0.0236485,0.019098638,-0.007768937,-0.04941907,0.001953474,-0.0033786783,0.02172425,-0.009486375,-0.00980109,-0.046541687,0.00015159656,-0.042297546,0.044815257,0.020861035,0.12070626,-0.030122615,-0.004403746,-0.011212806,0.026507901,0.011464577,0.020231606,0.009203133,-0.0047656675,0.0029560626,-0.012588555,0.017947683,-0.014872479,0.048160218,-0.041254494,0.0066719344,-0.011698364,-0.031902995,-0.02897166,-0.031453405,-0.0048645777,0.018756948,-0.011599455,0.0038192777,-0.0016016689,-0.027353132,-0.026795639,-0.010061853,0.023864305,0.01832534,-0.0019130108,-0.0064471387,0.0037136239,0.058302995,0.04240545,-0.017821798,0.022875203,0.054670297,-0.043016892,-0.06970463,0.032388553,0.021796184,0.036614712,0.037190188,0.017210353,-0.015115258,0.031741142,0.007197956,0.002005177,-0.041758038,-0.05305177,0.030176565,0.030428337,0.06118038,-0.040858854,0.025482833,-0.06010136,-0.007148501,0.010880109,-0.00618188,-0.06420163,0.021238692,-0.019746048,-0.00013888156,0.015438964,-0.039276294,-0.0044914167,0.029475203,-0.018559128,0.011797274,0.014225068,-0.032010898,0.03393515,-0.03967193,-0.026022343,0.031902995,0.00025359757,0.018595094,-0.0082455035,-0.03242452,0.00094582763,0.030913895,-0.0032213214,0.028306266,-0.021310626,-0.033,0.013577656,0.019368391,-0.03478038,0.00034197036,0.02458365,0.021310626,0.0036439372,0.007220436,-0.03542779,0.050570026,0.043160763,0.024979291,0.015106266,0.026903542,0.009558311,0.060389098,0.016239237,-0.07783324,0.022947138,0.006959673,0.019817984,-0.010034877,-0.013029155,-0.00391594,-0.048304085,0.016086375,0.0349782,-0.066071935,0.014081199,-0.03276621,0.007971253,-0.0040957765,-0.003036989,-0.011455585,0.022443596,-0.00021903524,-0.015933514,0.04262125,0.01886485,-0.011113896,-0.0029987737,-0.10344196,-0.034510627,0.04290899,-0.011644414,-0.011572479,0.048160218,-0.021778202,-0.08135804,-0.024457766,-0.024907356,-0.03566158,-0.0029223433,-0.032280654,0.0033134876,-0.03571553,-0.06635967,-0.0059435964,-0.00985504,0.03902452,-0.040822886,0.15911934,-0.012705449,0.013451771,0.011734332,0.030572206,-0.0013465259,0.014162125,-0.0076925065,0.05794332,0.014063215,-0.027604904,0.0016915872,0.028755857,-0.024044141,-0.015151226,0.0014892711,0.017552042,-0.046038147,0.048663758,-0.03747793,0.006195368,0.011158856,0.011401635,-0.0026413486,-0.002416553,0.03945613,0.024853405,0.01703951,0.003963147,0.05941798,0.0037743186,-0.03220872,-0.008825476,-0.012489646,0.03670463,0.0030527248,-0.02891771,0.06394986,-0.063518256,-0.04053515,0.012076021,0.009203133,0.009086239,-0.007157493,0.030482288,0.009050272,-0.034204904,0.009810082,0.010799183,-0.006959673,0.008344414,-0.027712805,0.027712805,0.048663758,-0.01625722,-0.023612533,0.00047010387,-0.058051225,0.030913895,-0.0137395095,-0.0073193456,-0.004675749,-0.035535693,-0.011374659,0.022353677,0.009989918,-0.02586049,-0.08157384,0.005930109,-0.011059945,0.027065394,-0.05305177,-0.046829425,0.0155738415,0.01886485,-0.0017534059,-0.017066484,0.066719346,0.042009808,0.012804359,-0.058734603,-0.009234604,-0.012318801,-0.006582016,-0.012309809,0.013649591,0.06459727,0.031992916,0.0012936989,0.05452643,0.0031156675,0.03467248,-0.02059128,-0.014989372,-0.0071260217,-0.012948228,-0.04024741,0.043412533,-0.022389645,-0.020087738,-0.0025963895,-0.011698364,0.014449864,-0.0019568459,0.019422343,0.028144414,-0.023666484,0.024781471,-0.009783106,0.025626702,0.043268662,-0.002985286,-0.026417982,0.0738049,-0.020015802,0.022389645,0.016715804,0.030536238,0.0077374657,-0.002322139,-0.010745231,-0.01186921,0.02832425,0.029295366,0.039528064,-0.06341035,0.0120310625,0.046541687,-0.010277656,0.006127929,0.004994959,-0.030428337,-0.04474332,-0.03118365,0.044707354,-0.014908446,-0.058302995,0.009324523,0.011500545,0.012507629,0.033737328,0.0009980926,0.012327792,-0.00048612055,-0.03285613,0.049383104,0.04262125,0.010421526,0.005552452,0.008749046,0.0057457765,-0.07804904,0.032010898,-0.0038507492,-0.044959128,0.01931444,0.022407629,0.0050848774,0.013811444,0.029726975,-0.03754986,-0.006892234,-0.0041879425,-0.002621117,-0.041506264,0.0023985694,0.02300109,0.0013690054,-0.0014128406,-0.010709264,-0.020033786,0.02053733,0.015304087,-0.027640872,0.008915395,-0.008362398,0.006631471,0.025069209,-0.00034225135,0.020501362,0.0014094686,-0.024313895,0.027281199,0.033143867,0.026130244,0.012741417,0.015250136,0.011257765,0.03754986,0.016517984,0.009387465,-0.014908446,-0.05556948,-0.02792861,0.023162942,-0.0076025883,-0.010925068,-0.021166757,0.027119346,-0.00027101923,0.014018255,0.015232152,0.010952043,-0.002317643,-0.015906539,0.025842506,-0.04798038,-0.007206948,5.2247424e-06,-0.073732965,0.0047971387,0.0066044955,0.030158581,0.016580926,-0.033485558,-0.028216347,0.035463758,-0.030608173,0.01985395,-0.016643869,-0.013649591,-0.0043610353,0.029529154,-0.0302485,0.013424795,0.012004087,0.024134059,-0.038053405,-0.002060252,-0.03877275,-0.028468119,-0.06840981,-0.058267027,-0.034870297,-0.08934277,-0.015546866,-0.025500817,-0.010241689,-0.03458256,-0.019296458,-0.0011458957,0.025500817,0.032136783,-0.060820706,-0.03769373,-0.0034685966,-0.020375475,-0.012147956,0.05172098,0.036866482,0.0377297,-0.023972206,0.02631008,-0.07394877,0.057763487,-0.023774385,-0.0011200443,0.022947138,0.004680245,-0.004684741,0.015636785,0.059525885,0.04427575,-0.050605994,-0.00257391,0.03231662,0.0030594685,-0.0092256125,0.025806539,-0.044887193,0.03571553,-0.06114441,-0.03985177,0.011284741,0.0023064031,-0.045462668,-0.00080476835,-0.0023423706,0.02280327,0.019476295]');
INSERT INTO "public"."vector_store" VALUES ('5a977bb9-e12e-4347-ace8-32fe11b32e0d', '沙子倒不完，信号收不到，照片发不完 —— 这是属于旷野的浪漫，也是青春最鲜活的模样。
#### 🚲 分队不分家，我们是彼此的旷野同行者
20 支队伍，几十位队长，几百个陌生的我们，因为同一份热爱聚在一起。物资统一采购，饭菜一起分享，修车时搭把手，迷路时互相指引。
男生主动扛起重物，女生细心照顾同伴，有人在途中收获了友情，有人甚至遇见了爱情 —— 就像第四届骑行里促成的 13 对情侣，旷野从不设限，缘分也从不缺席。我们签好免责协议，买好保险，听从指挥，因为我们知道：在这片旷野里，彼此就是最可靠的依靠。
#### 🌅 当我们站在沙丘上，才懂旷野的意义
夕阳把我们的影子拉得很长，有人举着旗帜，有人比着剪刀手，有人只是静静望着远方。
我们曾以为人生要按部就班，要在既定的轨道上奔跑，直到来到乌海的沙漠才发现：原来可以不用赶时间，不用怕犯错，不用在意别人的眼光。斜坡可以慢慢爬，滑坡可以小心过，百公里的路可以一步步骑，就像人生，从来没有标准答案。
#### ✨ 写给每一个在路上的你
如果你也困在轨道里，如果你也想看看不一样的风景，不妨来一次旷野之行吧。
去骑一次百公里的单车，去住一次沙漠里的帐篷，去追一次没有信号的日落。你会发现：人生不是轨道，而是旷野—— 你可以走向任何方向，成为任何想成为的人。
下一次，我们还在旷野等你。', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "6036ba2661a514b7f646a3f84e9f8ccb", "document_id": 160, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.03818523,-0.08084291,0.024818707,-0.061699476,-0.036050655,-0.023395656,0.008491725,-0.028071398,-0.015001342,0.10462821,0.025293058,0.036220066,-0.0056329146,-0.015806044,-0.070136145,-0.04713013,-0.07054273,-0.051941402,-0.06684957,0.07481188,0.022819657,0.0435725,0.06881474,0.00013003616,-0.03181538,0.004042569,0.018296385,0.07616717,-0.07704811,0.028884571,0.0037333942,-0.0057303263,-0.040353693,-0.009139722,0.10354398,-0.018635206,0.010545833,-0.022446953,-0.027597047,0.011630063,0.017652623,-0.018652149,-0.0056456206,0.0043326854,0.018042268,0.007415965,0.007585376,-0.022734953,-0.041471805,0.03139185,0.05729479,-0.042047802,0.0023823418,0.012739705,-0.025648821,-0.06864533,0.003945158,0.0095378375,-0.024988119,0.009487014,0.03540689,0.022430012,0.004313627,0.0152046345,0.06319029,-0.032374438,0.033306196,0.03923558,-0.0030091624,-0.043335326,-0.011765592,0.012129826,0.021718487,0.0065223225,0.032916553,0.011604652,0.028156104,0.031188559,-0.04018428,-0.0025856348,-0.025919879,-0.037439823,-0.009910542,-0.015933102,0.06681569,0.034864776,0.0069246734,0.02764787,0.035440776,0.06827262,-0.0074286712,0.007030555,0.0031023384,0.029087864,-0.018042268,-0.012265354,-0.06573146,0.018719912,-0.0015374046,-0.0058658547,-0.014840401,0.026987167,-0.024683177,0.018974029,0.038253,0.01112183,-0.008407019,0.0017512859,-0.013476643,-0.006026795,-0.026614463,0.01095242,0.056854323,-0.024767883,0.031917028,0.00027979282,0.047807775,0.017237566,-0.022074249,0.037439823,0.040218163,0.03152738,-0.018465796,-0.022108132,-0.0121044135,-0.0064460873,-0.0025072824,0.009351485,-0.024598474,-0.011604652,-0.076980345,-0.03476313,0.0077505517,-0.035610184,-0.0044893906,-0.02549635,-0.008407019,-0.002824928,-0.0426238,0.004967977,0.032221965,-0.001061995,0.12427989,0.018889323,-0.03906617,-0.0077886693,0.009605602,-0.034356546,-0.024903413,0.024971178,0.03196785,0.051297642,-0.027681753,0.044860024,0.057972435,-0.036728296,0.0015257576,0.0036741004,-0.045097202,-0.04645249,-0.012494059,-0.044555087,-0.007263495,0.045639314,-0.00958019,0.009478544,0.017017333,-0.014925106,-0.057701375,-0.010816891,6.835997e-05,0.0361523,0.008207962,0.013934053,-0.023531184,-0.012578765,-0.00910584,0.010367951,-0.011359005,-0.045232728,0.046859074,0.024124121,-0.018330267,0.013688406,-0.010122306,0.0010937596,0.021074725,0.036863826,0.038727347,-0.0176018,-0.024276592,-0.0039028053,-0.0025856348,0.012028179,0.014391462,-0.04340309,-0.034644544,0.008724665,0.009097369,-0.020583432,0.002094343,-0.028223868,0.026224818,0.033390902,0.05624444,-0.017305331,-0.0012250531,-0.018804617,-0.05177199,-0.01870297,0.04198004,0.002765634,-0.01929591,0.010223952,-0.039777696,0.016881803,-0.04462285,-0.008542548,0.0041738627,0.029528333,-0.053364456,-0.0040595103,-0.04340309,-0.009876659,0.024395179,-0.01095242,-0.013298761,-0.01821168,-0.0093768975,-0.005704914,0.044148497,0.030155152,-0.11174347,-0.07108484,-0.026766934,-0.05173811,-0.0116893565,0.01900791,-0.030663386,0.015052165,-0.0073778476,0.024259651,0.009605602,0.00802161,0.013849347,-0.010774538,0.0163651,-0.034966424,0.04553767,0.008449372,-0.027275166,-0.016297335,-0.015069106,-0.031798437,-0.009775013,0.019278968,0.004544449,0.033119846,0.0034686895,0.007382083,-0.051331524,-0.008542548,-0.011960414,-0.036084536,-0.04387744,-0.010156187,-0.023124598,0.059666544,-0.0018201091,-0.038083587,-0.0053660925,0.045063317,0.005001859,-0.017229095,0.0037397472,-0.0083604315,0.0062639704,-0.02331095,0.02054955,0.017584858,-0.024056358,-0.010562774,0.011875709,-0.044250146,-0.008601842,0.00025861643,-0.02486953,0.009588661,0.009698778,-0.009232898,-0.012985351,0.035779595,0.0010582892,-0.00057229144,-0.0072042015,0.018313326,-0.008008904,-0.0012811704,0.0071745547,0.04174286,-0.054075982,0.030934444,-0.02100696,0.024530709,0.01870297,-0.029443627,-0.024683177,0.0009794072,0.08538313,-0.04658802,-0.021650722,0.04990847,-0.035915125,-0.033594195,0.007166084,-0.021837074,-0.022938246,-0.044080734,-0.02639423,-0.01790674,-0.010884655,-0.043165915,-0.0620383,0.008631489,0.019346733,-0.015983924,-0.03010433,-0.0032230436,0.005145858,-0.027004108,-0.015382516,0.0062343236,0.007039026,0.041370157,0.0012832881,0.0061877356,-0.035847362,0.029697742,0.038083587,0.016805569,0.0053957393,0.051467054,0.032509964,-0.008767018,-0.016331218,0.03876123,0.025733527,0.008491725,0.021566017,0.0026788109,-0.010266305,-0.024276592,0.02053261,0.0074371416,0.005294093,0.04926471,0.014018758,-0.0019831671,-0.0692552,0.016737804,-0.033933017,-0.024649296,-0.011172653,0.041607335,0.028545748,-0.03427184,0.017034274,-0.0077463165,-0.024496825,0.026783874,0.0010238775,-0.0023145773,0.022870481,0.020820608,-0.00020024907,-0.0026533992,0.0014230522,-0.02271801,-0.011265829,0.0277834,0.0012547,-0.026004585,-0.011104889,-0.040082637,-0.0015162282,0.013374996,0.045503788,0.006166559,0.017669564,-0.035610184,-0.007674317,-0.018025327,-0.010367951,-0.021549076,0.015941571,0.015077576,0.007504906,-0.003722806,0.040692516,0.00648844,0.0031849262,-0.0012504647,-0.019278968,0.04370803,-0.010147717,-0.021854015,0.025852114,0.07420201,-0.050619997,0.034373485,-0.026326464,-0.0056710322,-0.010359481,0.06654463,0.013527466,-0.0222606,0.0010789362,-0.028291631,0.018753795,-0.004726566,-0.044216264,0.013070056,-0.062377118,0.009935954,-0.015738279,0.06346135,-0.006344441,0.056617144,0.024073299,-0.034322664,-0.08158832,-0.025208352,-0.022531658,-0.04845154,0.012146766,-0.04309815,0.009487014,0.029596096,-0.032679375,-0.011181124,-0.032747142,0.008644194,-0.0073312595,0.008597607,-0.0054042097,0.076506,-0.0018794029,-0.007149143,0.0036868062,-0.007500671,0.021294959,-0.07494742,0.02871516,-0.0277834,-0.004125157,-0.015052165,-0.0013224644,-0.052720692,-0.021481311,0.0054889154,-0.027986692,-0.038795114,-0.034017723,0.0111303,0.020922255,0.07352436,0.032357495,-0.0713559,-0.0001659698,0.018008387,-0.0017279919,0.04184451,0.017110508,-0.0016739921,0.0008174079,0.031408794,-0.017305331,0.054482568,0.0020731667,-0.07765799,-0.00547621,0.02285354,-0.011553829,-0.030256798,-0.020498727,0.07047496,-0.014086522,-0.034678426,0.015992396,0.0035809244,0.021040842,-0.035305247,-0.02580129,-0.030748092,-0.022802716,-0.0010164658,0.031476557,-0.033712782,-0.019973554,0.0066154986,-0.056786556,0.014781107,0.02871516,0.004142098,0.036965474,-0.0019694024,-0.014425344,0.006484205,-0.0149844,0.013713818,-0.0056837383,-0.01993967,-0.029867154,-0.015645104,-0.008419725,0.0154587515,-0.0051966817,0.05854843,-0.004353862,0.021108607,-0.010876184,0.02038014,-0.016771685,-0.03720265,-0.014493109,-0.03213726,-0.021091666,-0.055634562,0.08748382,-0.036796063,-0.011147242,-0.045232728,0.04384356,-0.014128875,-0.007831022,-0.011367477,-0.010918537,0.0042966856,0.014340638,0.044690613,0.063563,-0.014425344,-0.009749602,0.03240832,-0.02532694,-0.0088686645,0.01977026,0.0066154986,0.005649856,-0.0148573425,0.029325038,0.030409269,0.015831456,-0.036253948,0.02022767,0.018126974,0.0016761097,0.013654524,0.012265354,-0.06003925,0.00036211594,0.0044089206,0.011384417,-0.033136785,0.02532694,0.0222606,-0.025360823,0.02422577,-0.039608285,0.015806044,0.03305208,0.012383942,-0.020109082,0.006683263,0.045774844,-0.006191971,-0.0038011586,0.0109015955,0.12380554,0.048417654,0.0127058225,-0.000989466,0.0053364458,0.009351485,0.013078527,-0.0026068112,-0.035711832,0.015162282,-0.009182074,0.00957172,-0.036118418,0.024937294,-0.038795114,0.00045423317,-0.018364148,0.038524054,0.014255933,0.11594487,0.01914344,0.04665578,-0.04973906,0.028918453,0.026597522,-0.019448379,0.007356671,-0.07088155,-0.050755527,-0.004493626,0.012002767,-0.013637583,0.04492779,-0.08267255,-0.031917028,-0.015340163,-0.0010053482,-0.004341156,-0.015619691,-0.0042098626,-0.021972602,-0.0059166783,-0.055668443,-0.015526515,-0.024988119,0.0073397304,-0.030155152,-0.008627254,-0.008563724,0.031205501,-0.01777121,-0.00014929342,0.054482568,0.006992438,-0.016568393,0.0401504,0.012028179,-0.03166291,-0.06671404,0.0112743005,0.024835648,0.0066917334,0.0127989985,0.0066070277,-0.013358055,0.04198004,-0.0055397386,0.011638533,-0.044250146,-0.06390182,0.022480836,0.025970701,0.044385675,-0.02332789,-0.0072211428,-0.047977187,0.012790528,-0.023971653,-0.008449372,-0.018855441,0.021023901,-0.055499032,0.013857817,-0.03305208,-0.021278018,-0.011054066,0.0077081993,-0.02409024,-0.025140587,0.0037037474,-0.03090056,0.027817281,-0.017584858,-0.0237853,0.007030555,-0.012629588,0.019905789,-0.013120879,0.0018624618,-0.0009285839,0.033865254,-0.00052305637,-0.01727992,0.011562299,-0.016432865,0.017237566,0.025106706,-0.02532694,-0.05759973,0.038964525,-0.01373923,0.022158954,0.037033238,-0.019888848,0.052110814,0.05190752,0.04458897,-0.02039708,0.010130776,0.023124598,0.03815135,0.015509575,-0.085925244,-0.0109270075,0.0014886989,0.03423796,0.038625702,0.0109947715,-0.030239858,-0.04153957,0.006844203,-0.011172653,-0.015323223,0.0013266996,0.022565542,-0.016712392,0.016271923,0.009317603,0.012883704,0.027037991,-0.016754745,-0.030358445,0.055024683,0.03737206,0.023819182,0.0426238,-0.120281786,-0.046825193,0.029257275,-0.004370803,0.011375947,0.03476313,-0.036626652,-0.06847592,-0.02732599,0.0078394925,-0.0155519275,-0.018296385,-0.022582483,-0.015119929,-0.025614938,-0.048553184,-0.052415755,-0.015230047,0.045097202,0.02176931,0.13125962,-0.012146766,0.022548601,-0.033018198,0.023565065,-0.03073115,0.026970226,-0.029867154,0.10361175,0.0361523,0.0029519862,0.0034475133,0.013561348,-0.00054846803,-0.014654049,0.017584858,-0.015797572,-0.057667494,0.018923206,-0.039574403,-0.006268206,0.033899136,0.026207877,-0.034068547,-0.028494924,0.042725448,0.020735903,-0.01727992,-0.0038329232,-0.007365142,0.014272874,0.00440045,0.0054126806,0.02009214,0.03335702,0.04092969,-0.009766542,0.058277372,-0.070068374,-0.016449805,0.005205152,-0.028376337,0.0107406555,-0.015899219,0.013417349,-0.07894551,-0.0018338738,0.012409354,0.010147717,-0.021633781,0.015958514,-0.026445052,-0.030714208,0.083824545,-0.021684604,-0.026445052,0.0038604524,-0.062309355,0.019380614,-0.019024853,-0.026495876,-0.018516619,-0.015560398,0.009961365,0.049027536,0.0039748047,-0.029138686,-0.026445052,0.0040277457,0.014840401,0.055634562,-0.05560068,-0.017076626,0.010622067,0.013535936,0.0041463333,-0.014704872,0.043470856,0.048925888,-0.006111501,-0.018110033,-0.007288907,0.0075599644,0.03184926,-0.003566101,-0.0059166783,0.031086912,-0.0021398724,0.0003758806,0.021803191,0.004421626,0.04076028,0.008169844,-0.022633305,0.007356671,0.0037863352,-0.030307623,0.007598082,-0.02146437,-0.008512901,0.00556515,0.031696793,-0.01544181,-0.0139086405,0.006674792,0.04831601,-0.0022552835,-0.0051627993,-0.03413631,0.0011117595,0.020041319,-0.020735903,0.005205152,0.07149143,-0.036050655,0.00026748405,0.004510567,0.0048239776,-0.0073905536,-0.007305848,-0.022345306,-0.027868105,0.026631404,0.0076573757,0.036084536,-0.034797013,-0.04987459,0.068679206,-0.0072846715,0.00033220433,-0.020346258,-0.01916038,-0.023598948,-0.0028143397,0.085654184,0.034221016,-0.061530065,-0.020244611,-0.000485733,0.022870481,-0.0059632664,0.012443236,-0.0154587515,-0.021040842,-0.033424783,0.027495401,0.02642811,0.020905314,0.0031870438,0.043640267,0.012866763,-0.034864776,0.023751417,-0.019719437,-0.03090056,-0.026495876,0.029714685,-0.01481499,0.013417349,0.048790358,-0.0046588015,-0.05438092,0.0054931506,-0.020922255,-0.012333118,0.017703446,-0.00671291,0.009512426,-0.039472755,-0.018347207,-0.009690307,0.0019588144,-0.021159431,-0.040523104,0.022006486,-0.0015416398,0.01482346,-0.004832448,0.0048239776,0.0031531616,0.0149844,-0.03754147,0.022650247,0.008551018,0.004103981,0.018923206,-0.017034274,0.0057515022,0.04940024,0.002801634,0.003413631,-0.039404992,-0.01251947,-0.030477034,-0.043606382,-0.008902546,-0.032289732,-0.0028164573,0.026190937,0.05109435,0.021057783,0.034610663,0.014086522,-0.009749602,-0.049332473,0.015153811,-0.057227027,-0.006158089,-0.021735428,-0.020126022,0.040218163,0.020041319,0.032188084,0.02580129,-0.018821558,-0.0063698525,0.0277834,-0.0071872603,0.0039832755,0.025055882,-0.041471805,0.025072824,0.006454558,0.0015935219,0.010918537,-0.019329792,-0.0019492849,-0.02486953,0.0009354662,-0.024344357,-0.02376836,-0.022175895,-0.066578515,0.0071618487,-0.085450895,0.030239858,0.022633305,-0.02608929,-0.025648821,-0.017991444,0.020922255,0.052246343,0.023361772,-0.037439823,-0.037439823,0.00162211,0.024259651,-0.030409269,0.02578435,0.024886472,0.055058565,-0.011325124,0.028816806,-0.061394535,0.054855272,0.006302088,0.020363199,0.029020099,0.0001851609,-0.0023738712,-0.014391462,0.037948057,-0.0060987948,-0.036355592,-0.029409744,0.004790095,0.0063740877,-0.030595621,0.01590769,-0.02532694,0.062953115,-0.035745714,-0.029257275,-0.0015098753,0.012299237,-0.046859074,-0.033170667,-0.027461518,-0.02364977,0.027681753]');
INSERT INTO "public"."vector_store" VALUES ('a3d12cd9-33bc-41b9-84ce-5397220d0279', '# 一件叛逆的大事——吸烟

**操作**: 更新  
**分类**: life  
**时间**: 2026-05-09 20:44:07  
**标签**: 童年  

## 简介

一群少年出于好奇，在秋日午后用作业本和干玉米秸秆自制“香烟”尝试吸烟，体验叛逆与成长的微妙时刻。

## 内容

也不知道你们抽过烟没有？反正我是抽过！不是吸别人的二手烟，而是真的自己点了，抽了！在我的认知里面，小孩子吸烟是一件很严重的事，如果被父母发现肯定要挨一顿骂！但是大人很多都在吸烟，这也免不了压抑在我们心中的好奇。小时候的我似乎是十分胆小，很多事情都不敢去做。

一个晴朗的下午，那时候的太阳好像很明媚，但是并不燥热。我们在王可莹家的附近，他的爷爷是一位老师，十分和蔼。有机会之后再讲。也不知道是几岁（我猜是12岁左右吧），反正很小就对了，我们一群人，有哪些人也记不清了。也不知道是谁突发奇想，我们尝试一下抽烟吧！应该是很突然吧，当时的我们只有一个打火机，我们还缺什么，一根香烟。我们总不能去找大人要一根吧，不被打死就怪了！这个没有的话，就准备想想其他办法。香烟是由什么组成的，它是被一张纸包着，里面有被晒干的植物的尸体——干草。我们就去找材料，就近一个朋友家，撕下了他的作业本。干草要去哪里找呢？外面不到处都是吗？我们找到了已经脱干水分shuo在墙边的玉米秸秆，我们小心翼翼的摘下它的一根纸条，再缓慢的碾碎它，发出了独属那个季节的声音，突然想起来应该是秋天，暑假。', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "1e4c91fbb8e0824516519d6dc879c2ee", "document_id": 161, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[0.012184435,-0.118069865,-0.02522117,-0.08982216,-0.01934203,-0.037605636,-0.016724246,0.042928174,-0.032283098,0.095944814,0.03607497,-0.055486575,-0.016906882,0.02499505,-0.0012882366,-0.007192382,-0.04167581,-0.0499901,-0.06400959,-0.030752435,-0.08766531,-0.0039071073,0.033883337,0.07291528,0.02294257,-0.0038027437,0.031239465,0.020942269,-0.085995495,0.03736212,-0.052007794,0.012758434,-0.02139451,0.009905833,0.009444893,0.023029538,0.01356725,0.00398538,0.02339481,-0.03597061,0.025186384,-0.015750187,-0.030700253,-0.033100612,0.026804017,0.036840305,-0.05510391,-0.012167041,-0.004215849,-0.021255359,0.011106012,-0.00611396,-0.041501872,-0.035153095,-0.045850348,0.038753632,0.009731893,-0.007409806,-0.0011925701,0.005252961,-0.019498574,0.040945265,-0.016785124,-0.0004400116,-0.001574149,-0.041780174,0.028212924,0.004235417,-0.032561403,-0.05778257,-0.049259555,0.09615354,0.0071315034,-0.00934053,-0.049259555,0.0061400505,-0.022872994,-0.010932073,-0.01702864,-0.005861748,-0.0034200777,-0.046233017,-0.0379883,-0.015784975,0.014402159,0.03268316,-0.037814364,0.028926075,-0.008788274,0.08564762,0.018350577,0.011566951,0.06470535,-0.024334082,0.007153246,-0.03645764,-0.03962333,-0.01854191,-0.025238564,-0.039484177,-0.009036137,0.011680012,0.00019391494,0.05607797,0.030543707,-0.03473564,-0.013549857,-0.023325235,-0.01779397,-0.0007327185,-0.007527215,-0.012271404,-0.044319686,0.035066124,0.024734141,0.0014078197,0.014158644,0.016298095,0.008710001,-0.039205875,-0.016706852,0.004870295,-0.014697854,-0.03510091,-0.014332583,0.031743888,0.004735492,-0.0075185183,0.019689908,0.023151295,-0.042267203,-0.033344127,-1.8379113e-05,-0.017863547,-0.0016241565,-0.078550905,-0.044737138,-0.009679711,-0.033639822,0.0027634576,-0.055973604,0.004557205,0.01474134,-0.007344579,-0.11034697,-0.036388062,0.020316089,0.0048572496,-0.022246812,0.027291046,0.025899533,0.010792922,-0.030891586,0.028873893,0.0619919,-0.019463787,-0.011158194,0.0017883115,-0.0026873592,-0.054721244,0.013045433,-0.03962333,-0.027551955,0.0374317,0.0038897134,-0.043554354,-0.01465437,0.02445584,-0.066862196,-0.02188154,0.012549707,0.0034461687,0.048981253,0.033692006,0.0051529463,0.015158794,-0.026282199,-0.033831157,-0.0063487776,-0.04901604,0.06317469,0.0030895935,0.015924126,0.016037187,0.03259619,0.032770127,-0.029569648,0.03757085,-0.02179457,0.032891884,-0.03259619,0.028317288,0.010305893,0.018037485,-0.06936692,-0.031865645,-0.03645764,0.0007300007,-0.0060487324,-0.052564397,-0.0007033663,-0.04358914,-0.034666065,-0.0024503672,0.024107961,0.01594152,0.070340976,-0.014236916,-0.004844204,-0.012593192,0.021464087,-0.007418503,-0.013201978,-0.0037788271,-0.0065748985,0.022177236,-0.03424861,0.013410705,0.021098815,-0.001119733,-0.010497225,0.024734141,0.010331983,-0.033378914,0.022229418,0.0045398106,0.044354472,0.0474158,-0.03861448,0.0071402006,0.025586443,0.03433558,8.907585e-05,0.07548957,0.05510391,-0.03299625,0.026630078,-0.009270955,0.0019524666,-0.0013425925,0.019724695,0.026247412,-0.016289398,-0.019515969,0.011601739,0.0015621906,-0.0070053977,-0.010871194,0.006131354,-0.0057747783,0.003887539,-0.016289398,-0.00384188,-0.0018002698,-0.0029134802,0.040040784,-0.05155555,0.0068184133,0.01245404,-0.034213822,-0.015515368,0.0031091615,-0.012149647,-0.012271404,-0.013054131,0.019446393,-0.0141412495,0.09010046,-0.01442825,-0.053608034,-0.007401109,0.051033735,-0.0012327934,0.0018013569,-0.00012495079,-0.00034162728,-0.0834212,-0.0018133152,-0.017359123,-0.0068662465,-0.031726494,0.00036934883,0.011506072,-0.04870295,0.014845703,-0.010158044,-0.03350067,0.057434693,0.036527213,0.018159242,-0.041501872,0.07166291,0.0053747185,-0.014697854,0.004605038,-0.038718846,-0.004639826,-0.015106612,-0.006018293,0.005818263,-0.024821112,-0.010114559,0.003413555,-0.0025547307,0.03673594,-0.017863547,-0.020959662,0.0417106,0.0055095213,-0.029830558,-0.03153516,-0.0024242764,-0.026543109,0.0078055174,-0.008749138,0.0022872994,-0.00052208913,-0.033204976,-0.008814365,-0.020263907,-0.0094275,-0.043484777,-0.0038070923,0.011488678,0.06098305,-0.037327334,-0.053886335,0.0030047982,-0.0011914829,-0.014697854,-0.023012144,0.0044289245,-0.009392712,0.008592592,-0.081055626,-0.06752316,0.02308172,0.0017133002,0.015002248,0.02356875,0.030839404,-0.036701154,-0.08015114,0.05576488,0.049468283,0.051729493,0.037327334,-0.0025351625,-0.047485378,-0.011158194,-0.014358673,0.0054269005,0.08182096,0.025916928,-0.0035157443,0.030265406,-0.003704903,-0.007309791,-0.043554354,0.039379817,-0.02659529,-0.01105383,-0.003876668,-0.0001248149,0.0015350126,0.023760082,-0.0030352375,0.015698005,-0.0007120632,0.021707602,-0.0024721096,-0.042858597,0.049155194,0.013384614,0.01576758,-0.0046572196,0.0052225217,-0.042058475,-0.01014065,0.07187164,-0.009279652,-0.017080821,0.0073619727,-0.0071836854,0.009062228,-0.012010495,0.037779573,0.0035026988,-0.005592142,-0.021585844,0.022786023,-0.0036027138,0.01045374,-0.015245763,0.003722297,-0.017289547,-0.055034336,-0.040875692,0.007988154,-0.016802518,-0.015028339,0.01162783,0.016106762,0.037640423,0.004250637,0.004478932,0.041571446,0.05573009,-0.013923826,0.037257757,0.00825341,0.0077011543,0.03944939,0.039031938,-0.024229718,-0.021377116,0.002874344,-0.022890387,-0.0012501874,0.028473832,-0.012775828,0.015124005,-0.06449662,-0.01214095,-0.014132553,0.05986984,0.018020092,-0.007988154,0.023499174,-0.026090866,-0.0033961611,0.022212025,-0.014950067,0.006879292,0.025377717,0,0.013575948,0.030856797,-0.036805514,-0.020333482,-0.03910151,0.010992952,-0.013645523,-0.02099445,-0.021324934,0.050268404,0.00794032,-0.039692905,0.016628578,0.010331983,0.015506672,0.010949467,0.047728892,-0.0020459588,0.03424861,0.028334681,0.020316089,-0.02539511,-0.027517168,-0.00014064608,0.054199427,0.016559003,0.010584195,0.019707302,0.0018524515,0.011166891,0.0022438145,0.022212025,-0.029500073,0.019220272,-0.018194031,0.0010632029,-0.010732044,-0.020002998,-0.056808513,-0.038997147,-0.010044984,0.050964158,-0.009540561,-0.05016404,-0.043345626,0.001556755,-0.060600385,-0.0007723984,0.012949767,0.03259619,0.04539811,0.005044234,0.018246213,0.038927574,-0.0068140645,-0.04838986,-0.03294407,0.0038657968,0.037327334,0.0039810315,0.0052660066,0.012810616,-0.03750127,-0.043206476,-0.028091166,0.03708382,-0.030039284,0.0021427125,0.01699385,-0.0017622206,0.01434128,0.012097465,-0.013880341,0.04842465,-0.010158044,-0.012888888,-0.019707302,0.0048398557,0.030717647,0.00834038,-0.01334113,0.052286096,-0.005261658,-0.060182933,0.03393552,-0.0030156693,0.0016556829,-0.011027739,-0.06536632,0.009610136,0.053121004,0.0148804905,0.025064627,-0.05945239,-0.0098101655,-0.020942269,0.029065225,0.028212924,0.0015328384,0.015532763,-0.008701304,0.004444144,-0.009462288,0.0014763082,0.024647173,0.003596191,0.0014567401,0.0091231065,0.01948118,-0.007261958,0.03882321,0.0141151585,0.0035983655,-0.005653021,0.016306791,0.03264837,0.039031938,-0.030126253,0.03282231,0.026838806,-0.064948864,0.026856199,0.046337377,-0.025673414,0.024247112,-0.028786924,0.02659529,-0.0009582958,0.006109611,0.006379217,-0.029430497,-0.025482079,-0.020246513,-0.005687809,-0.0076098363,0.03245704,-0.030874193,-0.004848553,0.05639106,0.025290746,0.0077663814,-0.020890087,0.076324485,0.006605338,-0.018628879,0.034300793,-0.0009082883,0.043867443,0.0063966108,0.010819012,0.006179187,-0.0106276795,0.012271404,0.004378917,-0.049085617,-0.024299294,-0.011366921,0.0031700402,-0.039205875,0.051033735,0.009479682,0.06383565,0.016437246,0.019463787,0.00036581568,0.015819762,0.014097765,0.056634575,-0.005409506,-0.0005131204,-0.00019935053,-0.05573009,0.036562,0.026734442,0.07813345,-0.036805514,0.021707602,-0.029030437,0.028456438,-0.0297088,-0.020716147,-0.040493026,-0.076046176,-0.012175738,-0.009131803,-0.019202879,0.018594092,0.0037657816,0.014750036,0.043067325,-0.042997748,0.0036244562,-0.03210916,0.018976757,0.060600385,0.018941969,-0.053747185,0.035379216,0.0112886485,-0.019063726,-0.013332433,-0.017506972,0.026577896,0.03958854,-0.008723047,0.022577297,-0.0053007943,-0.017411305,0.042719446,0.0074054576,-0.043241262,-0.01162783,-0.006927125,0.047241863,0.042128053,-0.007375018,0.00697061,-0.06721007,0.012410556,-0.042232417,-0.0021416254,0.020316089,0.029500073,-0.025168989,-0.028143348,-0.051242463,0.006444444,-0.061887536,-0.053747185,0.021011844,-0.033831157,-0.016863396,-0.051659916,0.0448415,-0.051485978,-0.022072874,-0.015480581,-0.02508202,0.0043658717,0.025621232,-0.002038349,0.0054442943,0.033431098,-0.009557954,0.054582093,0.009001349,-0.02690838,0.040945265,-0.011810466,-0.029604437,-0.049607433,0.027430197,-0.05252961,0.05051192,0.00046229755,-0.06421832,-0.016098065,0.016802518,0.07507212,-0.008949167,-0.026717048,0.007888138,0.01699385,0.0015328384,-0.061783172,0.0098623475,-0.034457337,-0.054199427,0.008136002,-0.015028339,-0.030543707,-0.010610286,0.0068401555,-0.03979727,-0.017898334,0.028543409,-0.015584945,-0.027204078,-0.011758284,0.037327334,-0.039379817,-0.0013893386,0.01082771,-0.03176128,-0.008562152,0.00075935293,-0.023812264,-0.0052486127,-0.027412804,-0.017115608,0.04539811,0.005592142,0.026316987,0.011636526,-0.011158194,0.0040092967,-0.014671764,0.020333482,-0.010958164,0.029413104,0.0030808966,-0.030143648,-0.006561853,-0.05176428,0.026299594,0.0016241565,0.015480581,0.019011544,0.15932822,-0.0119757075,-0.015263157,-0.010558104,0.016837306,0.012523616,0.026456138,-0.015950216,0.022855598,-0.007118458,0.027412804,-0.024264505,0.020872694,-0.015489277,-0.0074489424,0.028473832,0.019672513,-0.025516868,0.008470834,-0.05875663,0.016585095,0.011532163,0.009305743,0.0061922325,-0.017063426,-0.04139751,-0.008214274,-0.034439944,-0.016906882,-0.009210076,0.0112625575,0.021690207,-0.03362243,0.02076833,0.006809716,0.045919925,-0.02633438,0.029117407,-0.0836995,-0.00075283024,0.014132553,0.011097316,-0.03753606,0.060113356,-0.019985603,0.051033735,-0.012419253,0.013906432,-0.012427949,-0.01194092,-0.006109611,0.008705652,-0.0069053825,0.043519564,0.0069488673,-0.0034005097,0.059208874,-0.07924666,0.051033735,-0.022646872,-0.0024808066,-0.036214124,-0.025290746,0.04070175,0.034405157,0.03301364,0.011114709,-0.015480581,-0.01234098,0.0068879887,-0.018002698,0.0033265855,-0.026438745,0.027204078,-0.020159543,-0.033605035,-0.0061661415,-0.00047806077,-0.011706102,0.05492997,0.019063726,0.024334082,-0.038023088,0.025777776,-0.010966861,0.03833618,0.072289094,-0.021585844,-0.002648223,0.045363322,-0.015271854,0.005322537,-0.012662767,0.015689308,0.017759183,-0.00054491864,-0.016472034,0.028526014,-0.010392861,0.024821112,-0.015167491,0.00062726793,-0.024316687,0.0052486127,0.012036586,0.032439645,0.027830258,0.020472633,0.015845854,0.007888138,0.043345626,-0.024525415,-0.014463037,0.07242825,-0.08265586,0.033065826,0.011332133,-0.053121004,0.018037485,-0.024264505,-0.01562843,0.0053094914,-0.00070771476,-0.018507121,0.028543409,-0.06773189,-0.05461688,0.06247893,0.005296446,0.018437546,0.019776877,-0.04745059,-0.007892488,0.022125054,0.0028612984,-0.017776577,0.052842703,-0.0013632477,0.014584795,0.025916928,0.064357474,-0.014228219,-0.041919325,0.0013045433,-0.016759034,-0.014689158,0.0024982004,-0.028038984,-0.0010811402,0.0702714,0.0029047832,-0.0331354,0.025586443,0.018837607,-0.03861448,0.027412804,0.052077368,-0.048320286,-0.045780774,0.0070575792,0.0040897434,-0.0031439494,0.005496476,-0.004283251,-0.016098065,-0.019620331,0.0045224167,0.0135846445,0.03597061,-0.045502473,-0.024873292,0.002639526,0.07249782,-0.060461234,-0.013367221,0.017193882,0.01262798,0.04967701,-0.035013944,0.0148544,0.023325235,0.017133003,0.024473233,0.018437546,0.015680611,0.024229718,0.01759394,0.015524066,0.05764342,0.029952316,0.013228069,0.005122507,-0.07667236,-0.057469483,0.006679262,-0.013306342,-0.0058747935,0.03167431,-0.033257157,-0.02602129,0.017724395,0.0091231065,0.028038984,-0.00027585655,0.0024960262,-0.046580892,-0.037918728,0.03784915,-0.023516567,-0.05938281,-0.013976008,0.025447292,0.046267804,5.2759264e-05,-0.043032534,-0.034457337,0.0046311286,-0.039379817,0.03757085,0.020559603,0.021498874,0.0431369,-0.008701304,-0.012288799,-0.018646272,0.012975858,0.0013078047,0.0010061291,0.009636227,-0.013784675,-0.058687057,0.091422394,-0.0345617,-0.0061487476,-0.0442849,-0.009453591,-0.037292544,-0.0043115155,-0.03736212,-0.018750636,-0.005687809,0.043971807,0.007318488,0.010688558,-0.025638625,0.00053948304,0.016846003,-0.024821112,0.031552553,0.04532853,0.015524066,-0.044493623,0.014036886,-0.018194031,0.04122357,-0.01836797,-0.007509821,0.04317169,-0.036631577,-0.0054442943,-0.0072750035,0.019950816,0.012471435,-0.032700554,-0.05322537,0.000564215,0.02948268,0.018089667,-0.009157894,0.0025199428,0.013802068,-0.088987246,-0.025464686,0.0018317963,0.026856199,-0.026943168,-0.036527213,0.02196851,-0.015898034,0.013775977]');
INSERT INTO "public"."vector_store" VALUES ('7bee2a3b-51dc-4bf8-8d6a-572f3892a593', '将碾碎的干草卷进了作业本中，然后用口水封住不让他展开。紧接着，便是吸烟中的最重要的一步，点燃它。掏出了小超市五毛钱一支的打火机，在一声清脆的可啪（拟声，字对不对别介意）下，那支香烟（作业本卷的干草）被我们点燃了，它似香烟一样冒着火星，我心中的叛逆藏在里面，如同心脏一般有韵律的闪烁着。他们一个接一个的贪婪着小小的叛逆，紧接着发出了剧烈的咳嗽，在我们害怕、紧张的心情下，转瞬即逝。

可轮到我的时候，我却迟疑了，现在的我也迟疑了，因为我已经记不清我到底有没有尝试那被作业本卷的干草。现在的我认为当时的我不敢，对，是不敢。或许我猜对了，也或许没猜对，可它一直留在我的记忆中，只要想到就会闪烁出来的画面，让我也无法追寻。无所谓了，因为在乎的，可能只有当时的我吧！', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "1e4c91fbb8e0824516519d6dc879c2ee", "document_id": 161, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[0.0416029,-0.070426755,-0.017970536,-0.08341879,-0.012637058,-0.0791591,-0.022114852,0.017997159,-0.036881752,0.10351028,0.0002898026,-0.041851383,-0.032906048,0.03730772,-0.021671135,0.0013644296,-0.04270332,-0.062084872,-0.06396623,-0.05168415,-0.030101757,-0.01100418,-0.0030993628,0.055127393,-0.0015541186,-0.008124457,0.01194486,-0.015148496,-0.06527963,0.045330122,-0.06946832,0.001920185,0.009460045,-0.002504782,-0.02577108,0.013923838,-0.0075343135,-0.0022496448,-0.022452077,-0.00094234385,0.037130233,-0.031628143,-0.050122265,-0.02791867,-0.018600615,0.017207343,-0.01867161,-0.023960715,0.014802397,-0.034840655,0.025327362,-0.0077961064,-0.04820541,-0.028344639,-0.018866844,0.043129288,-0.0035652656,0.0009634204,-0.022416579,0.01724284,0.003711692,0.0442652,0.0055952705,0.0023738856,0.0044238577,-0.05072572,0.041141436,-0.008963082,-0.017624436,-0.052642576,-0.04000552,0.032355838,0.02536286,-0.006283032,-0.06485367,-0.008803344,-0.029214323,-0.001589616,-0.02671176,0.032018613,-0.055056397,-0.05395598,-0.03129092,-0.016595013,0.010427348,0.035479605,-0.020056006,0.025540346,0.023446003,0.06900686,0.004512601,0.008798907,0.054417446,-0.00076485705,0.017198468,-0.02724422,-0.03581683,0.022452077,-0.02161789,-0.028806103,-0.028255895,0.011581012,-0.035603847,0.016186794,-0.0022019453,-0.051222682,-0.007237023,-0.011793996,-0.037662692,0.022913542,-0.016124673,-0.022203594,-0.039757036,0.027812177,0.04841839,0.015814072,0.03780468,0.040715467,0.023978462,-0.008013528,-0.013719727,0.06251084,-0.044797663,-0.03837264,-0.010631458,0.022842547,0.00429518,0.016151296,0.0301905,0.030829452,-0.029445056,-0.0013466809,-0.011110672,0.021706633,0.021759879,-0.0068598636,-0.051329173,-0.029107831,-0.017393705,-0.0054665925,-0.03409521,0.009921511,0.02294904,-0.0060168016,-0.13936262,-0.017296087,0.0006500453,-0.0110308025,-0.024351185,0.024865897,0.05313954,-0.0102498615,-0.015228366,0.049057346,0.033101283,-0.022345584,0.0062919063,0.031450655,0.03784018,-0.027386209,0.018582866,-0.04309379,-0.024262441,-0.007068411,-0.005027313,-0.04792143,-0.00647383,-0.0016217853,-0.05970655,-0.00579938,0.010658081,-0.007667429,0.022203594,-0.010019128,-0.013329256,-0.0069885417,-0.04373274,-0.03808866,0.005817129,-0.07809418,0.067480475,-0.007103908,-0.052500587,-0.008328567,-0.024262441,0.0063629006,-0.00216312,0.000902964,-0.0057017626,0.0074100727,-0.02710223,-0.022789301,0.02967579,0.01221109,0.00067334046,-0.03272856,-0.05459493,0.013276011,0.027563697,-0.033757985,0.009433422,-0.01945255,0.017615562,-0.022097103,0.019505797,0.023108779,0.06897136,-0.039366566,0.012228839,7.612519e-05,0.0022962352,-0.0046457164,-0.02440443,-0.024723908,-0.0008835514,0.026924744,-0.04117693,0.011935986,0.04639504,-0.016062552,-0.028965842,-0.026498776,0.01274355,-0.021316161,0.016177919,0.022150349,0.039295573,-0.01945255,-0.035763584,0.01732271,-0.025185373,0.05690226,-0.015192868,0.022523072,0.021191921,-0.03808866,-0.03677526,-0.007605308,0.0041487534,-0.02964029,-0.0043173656,0.033864476,0.014660408,0.00021617334,0.019896267,0.0031747946,-0.0167725,-0.024191447,-0.012912163,0.009717401,-0.026143802,-0.014944387,-0.025611341,0.006731186,0.04082196,0.031042436,-0.015485721,0.026782755,0.022895794,-0.04898635,-0.026072808,-0.0021808688,-0.027403958,0.004301836,-0.022700557,-0.003305691,-0.022150349,0.11998106,-0.027687937,-0.034982644,-0.0068776123,0.051435668,0.0014065827,0.038301647,-0.03317228,-0.00064061634,-0.0049119466,-0.014403052,-0.0040200753,-0.010693578,-0.051577657,0.004672339,-0.0020255677,-0.037272222,0.027829926,0.016621636,0.02845113,0.023623489,0.00741451,0.020322235,-0.021653386,0.07124319,0.0077916696,-0.016408652,-0.043661747,-0.04802792,-0.0085593,-0.0018780319,0.006704563,-0.007982467,-0.023871971,-0.030385736,-0.0041598463,0.0063762125,0.05434645,0.019470299,0.0021431528,0.07103021,0.0040977257,-0.040254,-0.04898635,0.026090555,-0.039899025,-0.006083359,-0.01804153,0.010888814,-0.015192868,-0.02671176,0.004144316,-0.0059413696,-0.04344876,0.014793523,0.01663051,0.026694011,0.03553285,-0.0241737,-0.026516523,0.0024493174,0.0016273318,-0.034911647,-0.034680914,0.017562317,-0.0214759,0.007986905,-0.069148846,-0.026498776,-0.0039779223,0.0043306774,-0.019221818,-0.0052269856,-0.0037050364,0.022860296,-0.049802788,0.050761215,0.05463043,0.0375917,0.025203122,-0.010365227,-0.03528437,0.0073745754,0.02980003,-0.0028531,0.039153583,0.022434328,0.003973485,0.02869961,-0.017402578,0.021298412,-0.01663051,0.027457204,-0.021511396,-0.0063096546,-0.041744888,-0.03100694,-0.008763409,-0.00014025615,-0.030758457,0.030314742,-0.018245641,0.0077872323,0.014740276,-0.035586096,0.047708444,0.027812177,-0.01804153,0.026765006,-0.013409126,-0.03528437,0.011021929,0.04376824,-0.013613235,-0.049802788,0.018724855,0.020677209,0.035461858,-0.042064365,0.007285832,-0.032515578,0.004934132,-0.005080559,0.02307328,0.0026578645,-0.023179773,-0.015574465,0.035763584,-0.0043284586,-0.037662692,-0.038017668,0.0051471163,-0.029019088,-0.02186637,0.019612288,0.011714127,0.041851383,0.031521652,-0.0020233493,0.039792534,0.050619226,-0.032355838,0.018955586,-0.017384829,0.019896267,0.051329173,0.0139948325,-0.027652439,-0.0066380054,-0.02106768,-0.025558095,0.0076319315,0.04951881,7.1714016e-06,0.013861717,-0.057363726,-0.0008014637,-0.021422654,0.111319706,0.025274117,0.016355406,0.019150823,-0.029036837,-0.06645105,0.012672556,-0.066486545,0.025664587,0.015822945,-0.020073755,0.023729982,0.0295338,-0.06890037,-0.017162971,-0.0510097,0.0032457893,-0.025238618,-0.026694011,-0.02468841,0.026445528,-0.0006788869,-0.024883647,0.014074701,-0.001145899,0.047672946,0.027031235,0.05246509,-0.02145815,0.04376824,0.021049932,0.020641712,-0.042774312,-0.008630294,0.027137728,0.09101522,0.017349333,-0.04213536,0.009584285,0.005040624,0.034432434,0.014340932,-0.015246114,-0.03059872,-0.0017848513,-0.04078646,0.003225822,-0.011226038,-0.019665534,-0.0617654,-0.025132127,-0.02429794,0.05686676,-0.025238618,-0.0049740667,-0.02722647,0.024670662,-0.04909284,-0.023747731,-0.0009739587,-0.01904433,0.017331583,0.018352132,0.03862112,0.014518418,-0.044726666,-0.04657253,-0.04912834,0.032320343,-0.0142788105,-0.024510924,-0.019576792,0.017411452,-0.039615046,-0.044371694,-0.03597657,0.04614656,-0.012690304,-0.020091502,0.0027088919,-0.008488305,0.000812002,0.031432908,-0.0079780305,0.023516998,-0.033509504,-0.023179773,-0.0069131097,0.0077384235,0.03072296,0.027652439,-0.021422654,0.037272222,0.015086376,-0.054985404,0.024883647,0.011501143,-0.017535694,-0.023037784,-0.04036049,0.040715467,0.027687937,-0.010551589,0.0022895795,-0.059777547,-0.045720592,-0.028025161,-0.006496016,0.018440876,-0.020641712,0.058961105,0.024972389,-0.0048542633,-0.0005468811,0.033988718,0.035071388,0.0042064367,0.007436696,0.022611815,0.0054089096,-0.03326102,0.03720123,0.0007221493,0.017331583,-0.027190974,0.0062697204,0.0049740667,-0.002083251,-0.05715074,0.013453498,0.020038256,-0.022878045,0.029871024,-0.0022440983,-0.012131221,-0.029888773,-0.0043129288,-0.02041098,0.020641712,0.034592174,-0.005524276,-0.026001813,0.007498816,-0.044939652,-0.0009783958,-0.013373628,0.030793956,-0.014403052,-0.011101797,0.069716804,0.005400035,0.011394651,-0.0072414605,0.14923088,0.012938785,-0.02307328,0.011545515,-0.028504375,0.019772027,0.02200836,-0.018148022,0.007782795,-0.0042973985,0.0044793226,-0.0072503346,-0.061090946,0.017091976,-0.041744888,-0.003236915,-0.06197838,0.037911173,0.007920347,0.09428097,0.02577108,0.00891871,0.014110198,0.030350238,0.021529146,0.045401115,0.02160014,0.008914273,0.016328784,-0.029001338,0.041425414,-0.0009068465,0.0113325305,-0.027652439,0.015787449,-0.035657093,-0.009495542,-0.0389051,-0.008470557,-0.040254,-0.01918632,-0.014163445,-0.02791867,-0.019257315,0.014403052,0.0062076,-0.0023162025,-0.0060656103,-0.006895361,-0.023942966,0.0028397883,-0.014065827,0.026587518,-0.015157371,-0.025433855,0.027066734,0.010152243,0.0032568823,-0.0063274032,0.008186578,0.022842547,0.058712624,0.018210143,0.0039712666,-0.0026534272,-0.009619783,0.013515618,0.021848623,-0.016009307,-0.03787568,-0.0077428604,0.04628855,0.008026839,0.036952745,0.0022962352,-0.05569535,0.0032990354,-0.06222686,0.0046279677,0.041638397,0.018866844,-0.038159657,-0.014997632,-0.0038603374,0.0023228582,-0.026285792,-0.0029240947,0.03847913,-0.03272856,-0.0033079097,-0.05715074,0.0234815,-0.052216608,-0.03553285,-0.015432475,-0.0025669024,-0.022665061,0.009309181,0.0027488265,0.051613152,0.04373274,-0.01867161,0.013950461,0.040999446,-0.0016650478,0.05033525,-0.055304877,-0.014997632,-0.022097103,0.025167625,-0.028859349,0.024475425,0.011927111,-0.0885304,-0.003738315,-0.0032835053,0.039153583,-0.036526777,-0.02939181,-0.02135166,0.0145805385,0.02133391,-0.044584677,0.014225565,-0.07056874,-0.047175985,0.008905399,-0.00058847957,-0.0106847035,-0.03862112,-0.00020702169,-0.059777547,0.020925691,0.021706633,-0.020233491,-0.005817129,0.0075831222,0.026268043,-0.018707106,-0.018263388,0.009069574,-0.044620175,-0.021706633,0.04604007,-0.030545473,0.021298412,-0.03366924,-0.025469352,0.055091895,-0.006078922,0.035337616,0.013187267,0.009353553,-0.030421233,-0.0100989975,-0.009460045,-0.036491282,0.07177565,-0.030438982,-0.022097103,-0.0054089096,-0.042206354,-0.0077428604,-0.006030113,0.011101797,-0.013568864,0.16626962,-0.026179299,-0.029746784,0.038976096,-0.036189552,-0.047672946,0.029178826,-0.006802181,0.09094422,0.023534747,0.03812416,-0.020073755,-0.00506281,-0.023836473,-0.01893784,0.021830874,0.021813124,-0.031965367,0.014474046,-0.047708444,0.02736846,0.032284845,0.013054152,-0.016248913,-0.03819515,-0.02550485,-0.0029440618,-0.035071388,-0.012672556,-0.026374534,0.016657135,0.02859312,-0.0016350969,0.018724855,0.010817819,-0.0113325305,-0.0063229664,0.031699136,-0.0765323,-0.033757985,0.01622229,-0.017633311,-0.0375562,0.03787568,-0.009610909,0.01564546,-0.020978937,-0.008612546,0.005630768,-0.04089295,-0.0007726221,-0.023747731,-0.010808945,-0.007436696,0.001290107,-0.0015130747,0.0315394,-0.08157292,-0.008075648,-0.048666872,-0.015521218,-0.07809418,-0.006917547,0.01998501,0.0022784865,-0.00500069,0.0042374968,-0.031077934,-0.011563263,-0.016257789,-0.0052269856,-0.016541768,0.0020788137,0.020091502,-0.005746134,-0.002409383,-0.012131221,0.021245167,-0.0060478617,0.04628855,0.027173225,-0.006651317,-0.047495462,-0.013267136,-0.014438549,-0.0017560098,0.031628143,-0.02120967,-0.024652913,0.040076513,0.004503727,-0.02161789,-0.007902599,0.025700085,-0.020339984,0.0044904156,-0.014962135,-0.007276958,-0.0119182365,-0.008062337,-0.072095126,0.019026581,-0.008523802,-0.0026911432,-0.02041098,0.07234361,0.030918196,0.023907468,-0.01094206,-0.014545041,0.012264336,-0.0048453887,-0.00547103,0.05175514,-0.022611815,0.016985483,-0.0075609367,-0.036278296,0.043803737,0.007623057,-0.035799082,-8.486086e-05,-0.0049430067,0.004155409,0.0026733945,-0.06964581,-0.06478267,0.11735425,0.011465645,0.013515618,0.020783702,-0.07766821,-0.012317582,0.0032302593,-0.0044837594,-0.0013100742,0.019523544,0.034556676,0.025469352,0.01159876,0.04575609,-0.01018774,-0.046466038,0.026197048,0.031557146,-0.0065226387,-0.0055420245,-0.0037738124,-0.011527766,0.06023901,-0.0043839235,-0.028468879,0.018210143,0.0072680833,-0.014589413,0.016461898,0.026729507,-0.071314186,-0.05434645,0.01998501,0.011909363,-0.018458625,0.023499249,0.0005632432,-0.013098524,-0.0171186,0.024351185,0.0102498615,0.0070196018,0.0034587735,-0.0124595715,-0.00084639003,0.044975147,-0.018316636,-0.01630216,0.019541293,0.021245167,0.025274117,-0.020606214,0.026072808,-0.018582866,0.0036628833,0.027066734,0.015228366,0.0050228755,0.02309103,0.0035697026,0.017544568,0.035745837,0.030527726,0.019239565,0.029001338,-0.06556361,-0.016967736,0.019381555,-0.05892561,0.0018103651,0.019701032,-0.000990598,-0.021990612,0.046608027,0.010107872,0.008976393,-0.015423601,-0.01650627,-0.036668766,0.012432949,0.02722647,-0.029125579,-0.05207462,-0.017597813,-0.024919143,0.030350238,-0.022913542,-0.0564053,-0.022736056,0.041389916,-0.0035697026,0.005684014,-0.0024759404,0.011687504,0.037130233,0.020304486,0.01769543,-0.0065625734,0.03876311,0.0026556458,0.012832293,-0.0065226387,0.009823893,-0.054807916,0.0765323,-0.03113118,-0.00785379,0.0013322601,-0.014616036,-0.03317228,-0.017846296,-0.011731876,0.0065403874,-0.024777154,0.030527726,0.00044316228,0.022434328,-0.036296044,-0.0037538453,0.026747257,-0.013852843,0.013453498,0.055801842,0.0035208939,-0.080508,-0.011323656,0.003975704,0.023375008,-0.002777668,-0.011581012,0.047424465,-0.02898359,-0.02026899,0.01986077,0.024510924,-0.007880413,-0.015902815,-0.06240435,-0.0039779223,0.027900921,-0.014598287,-0.025291866,-0.011119546,0.027989665,-0.09094422,-0.04454918,-0.0090606995,0.015885066,-0.024883647,-0.01489114,0.016932238,-0.02429794,0.05129368]');
INSERT INTO "public"."vector_store" VALUES ('2229ac21-0402-45fa-827a-e1f7fa6a3a16', '#  Axios网络请求_04

**操作**: 更新  
**分类**: study  
**时间**: 2026-05-09 20:44:10  
**标签**: Vue3  

## 简介

本文介绍了Axios这一基于Promise的网络请求库，涵盖其安装、引入方式及GET/POST请求的基本用法，并提示POST请求需额外处理参数格式。

## 内容

Axios是一个基于promise的网络请求库。

##### 安装

Axios的应用是需要单独安装的==npm install –save axios==

##### 引入

组件中引入：==import axios from “axios”==

全局引用

##### 网络请求基本示例

###### get请求

###### post请求

> **温馨提示**
>
> post请求参数是需要额外处理的
>
> > 安装依赖： ==npm install –save querystring==
> >
> > 转换参数格式：==qs.stringify({})==

##### 快捷方案

###### get请求

###### post请求', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "4c8ec4fc2213afd8ec9cab074f9f4433", "document_id": 162, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.027810207,-0.023503898,-0.022714956,-0.006590953,-0.036948785,-0.046284597,0.03244524,0.11511979,-0.028977184,0.08204997,0.09894648,0.05230028,0.053089224,0.015770622,-0.06485761,0.013535286,0.014554337,-0.08836151,-0.0073552406,0.043457557,0.009607012,0.006237573,0.08606043,0.0051445593,-0.03155768,0.03022634,-0.009434432,0.01706087,0.020118022,0.062688015,0.03098241,-0.018622318,0.040630516,-0.005802011,0.045364168,0.02868133,-0.021531543,0.013436669,-0.0037598019,-0.06584378,-0.059959594,0.019723551,-0.033299927,0.004096746,-0.014069466,0.05003207,-0.00788942,-0.005838993,0.015967857,0.013116161,-0.01631302,-0.035206538,0.023421716,-0.01458721,-0.05101825,0.013716086,0.022961501,0.028467657,0.020594673,-0.008719453,0.0016456838,0.021334307,0.052464645,0.011653331,-0.0017792286,-0.0418468,-0.0016169202,-0.0110944975,-0.01383114,-0.028878566,0.040170297,0.033152003,0.006767643,0.01893461,-0.02823755,0.047106415,-0.02504891,0.042044036,-0.0039221104,-0.014874845,0.010584972,0.066304006,-0.00824691,0.0040227827,-0.013181906,0.00877698,0.00075966486,0.0043104175,0.016066475,0.0561135,0.023421716,-0.0014576936,-0.026725411,0.02384906,-0.056803826,0.020939836,-0.019937223,0.016502038,-0.015861021,0.021038454,-0.02149867,0.03435185,-0.006903243,-0.02411204,0.058907673,0.04730365,-0.001631302,0.0023996986,-0.009253632,0.00078945566,0.025541998,-0.047763865,-0.02748148,0.040170297,0.019657806,-0.013280524,-0.033299927,0.034779195,0.0118752215,0.014652954,0.00527605,0.045988746,-0.050262183,-0.017537523,0.01383114,-0.03997306,-0.010231592,0.003817329,0.0087687615,0.033924505,0.017175926,-0.01564735,-0.023175173,-0.011341042,0.019887913,-0.04500257,-0.009467305,-0.041518074,-0.080735065,0.017027998,-0.03058794,-0.051083997,0.06955839,0.021284997,-0.0040803095,-0.018112794,0.009064615,-0.039874446,0.040005933,-0.010773989,-0.0107164625,0.0118916575,-0.044608098,0.037441872,-0.025476253,0.005152778,0.004676125,0.026725411,0.010511009,-0.05141272,-0.043852028,0.023306662,0.029979797,0.025163963,-0.035568137,-0.036554314,0.018786682,0.014726918,-0.028122496,-0.0360941,-0.0043432903,0.012557327,-0.012203947,-0.011447878,-0.022057503,0.007774366,-0.032330185,0.02886213,0.001658011,-0.08461403,0.020364566,0.02212325,0.008612617,0.030177033,0.00014433119,-0.014077684,0.0499992,0.052596133,-0.049407493,-0.0122943465,0.051281232,0.05608063,0.013568159,0.05440413,-0.016115785,0.00011909891,-0.025213271,0.039414227,0.059597995,-0.0024181895,-0.019608496,-0.03157412,-0.0357325,-0.0014124939,0.030818047,0.022369793,-0.0060978644,-0.022041067,0.03098241,-0.0043515083,0.012738126,-0.020101584,-0.0015902113,-0.031722043,-0.011957402,-0.027974568,-0.045462783,-0.022156121,0.045890126,-0.004618598,-0.0050500506,0.039151248,-0.0646275,-0.038099326,-0.010609627,0.046974923,0.033924505,0.01125886,0.005843102,0.043358937,0.0013498305,0.06686284,0.013748959,0.07777654,0.026035087,-0.022041067,-0.017537523,-0.03448334,-0.004614489,0.067586035,0.047270775,0.03160699,0.009113924,-0.023964114,0.01494059,0.023964114,-0.008670144,0.0060033556,0.007634658,0.00979603,-0.017718323,-0.03320131,-0.054667108,0.0059992466,0.015154261,-0.029585326,-0.020446748,0.019904349,0.050689526,0.014595428,-0.011554713,0.018983917,0.033299927,0.02531189,-0.014891281,-0.0026174795,-0.020643983,-0.008809852,0.0008320873,0.037343256,-0.011423223,-0.020364566,0.0007134378,-0.012705253,0.025492689,-0.035075046,-0.0154008055,0.039085504,0.0032913676,-0.04072913,-0.0006189291,-0.001635411,0.023438152,-0.0067964066,0.011653331,0.009122143,0.08941343,0.002401753,-0.030029105,0.026955519,0.046317473,0.030998847,-0.015852803,-0.0044213627,-0.006475899,0.016649963,0.024917418,0.038954012,-0.0111027155,0.011784822,-0.044838205,-0.01941126,-0.0585132,0.03954572,-0.030505758,0.04894728,-0.030177033,-0.096908376,0.035798244,-0.004123455,-0.034154616,0.029782562,0.0026503522,-0.019263335,-0.014554337,-0.0028804601,-0.052070174,-0.024769492,-0.014883063,-0.040794875,0.044871077,0.048388444,0.000689297,0.010782207,0.03178779,-0.018310029,0.02698839,0.014283137,0.017734759,-0.0025291345,-0.061734714,0.02034813,0.034746323,0.037277512,-0.011267078,-0.025509125,0.050262183,-0.010174065,0.024457203,0.008398945,0.047402266,0.0052144136,0.05213592,-0.004104964,0.038493797,0.015548732,0.0032995855,0.04644896,0.015893895,0.005456849,0.014529683,-0.014743354,0.0036632386,0.03790209,0.044213627,0.020282384,0.028451221,0.0005963292,-0.0015378206,0.015573387,0.02912511,-0.0069689876,-0.057099678,-0.0032810948,-0.0020463183,-0.059926722,0.028878566,0.019230463,0.0012090948,0.0029318237,-0.018983917,0.02823755,0.06778327,0.024407893,0.035206538,0.02411204,0.028171804,-0.008546872,0.009919303,0.03602835,-0.028253986,0.034910686,-0.017356725,-0.07646163,0.015844585,0.01812923,0.007831893,-0.0248188,-0.015310406,-0.041616693,0.023520334,0.010206938,-0.015992513,-0.014554337,-0.007593567,0.004495326,-0.035929736,0.019263335,0.06817774,0.012606636,0.0038111652,-0.030801611,-0.025657052,0.0016539019,0.036554314,-0.04082775,0.045923002,0.054272637,-0.028566275,0.062490784,-0.089018956,-0.03487781,0.01604182,0.031146774,-0.016477384,-0.0099439565,-0.006932006,-0.009171451,0.008197601,0.024029858,0.017175926,0.012220384,-0.060321193,0.042274144,-0.010486354,0.0844168,-0.037211765,0.01569666,0.011398569,-0.043556172,0.015499423,-0.05874331,0.041222222,0.012803871,-0.014307792,-0.0044665625,0.002668843,0.022994373,-0.0042652176,0.004893906,-0.008842725,0.007831893,-0.0126805995,0.017964868,-0.027596535,0.016567782,0.0027366427,-0.02716919,0.0029153873,0.01914828,-0.03599548,0.014784445,0.016288366,0.034253232,-0.012014929,-0.016271928,0.0033899853,-0.043654792,-0.034779195,-0.04299734,0.031672735,0.045199804,0.014743354,0.029683944,0.015055643,0.066304006,-0.020200202,-0.034812067,0.003946765,-0.009787812,0.0053869947,0.065482184,0.014726918,0.0037700746,0.016740363,-0.028977184,-0.00970563,0.020249512,0.002194245,0.100524366,-0.022714956,0.035305157,-0.01959206,-0.010412391,-0.08625766,-0.06968988,-0.022862881,0.01613222,-0.026544612,-0.026166577,0.016419856,0.00935225,0.029240163,0.06597528,-0.029141545,0.06485761,0.033234183,0.031459063,0.023783315,-0.016880073,-0.030390704,-0.0047747428,0.006808734,-0.007601785,0.015721314,0.015565169,0.01236831,-0.029848307,0.007289496,0.0083825085,-0.05213592,0.01494059,0.056935314,0.040762004,0.039414227,0.010223374,0.056343608,0.044509478,0.0020504275,0.023964114,0.028730638,0.04312883,0.006853934,-0.017915558,-0.07258267,0.020364566,0.027760897,-0.016008949,-0.0022497175,-0.040170297,0.0009106733,-0.003270822,-0.026561048,0.019000353,0.026939083,0.04464097,0.020019405,-0.01697869,-0.0091550145,0.020643983,-0.001704238,-0.015548732,-0.002623643,0.01494059,0.021334307,0.00846469,0.008826289,-0.027366426,0.0069977515,0.039118376,0.01014941,0.0357325,0.020397438,-0.017044434,-0.0016806108,0.02087409,0.02615014,-0.005978701,0.030127723,-0.043556172,-0.017882686,0.00022548539,0.031015282,-0.018145667,-0.017948432,-0.049440365,-0.0029420962,0.030752303,-0.0026318613,-0.02633094,0.01285318,0.020134458,-0.007330586,0.007642876,-0.009196105,0.001095068,-0.028615585,0.013502414,0.08362786,0.051938683,-0.0018501101,-0.02664323,0.007367568,0.00088704616,0.040005933,0.010305556,-0.014011939,-0.02021664,0.023306662,0.011932748,0.03191928,-0.0601897,-0.055160195,-0.0043391814,0.0012604581,0.03494356,0.048914406,0.041386582,0.028796384,-0.002818824,-0.025426945,-0.034253232,0.015252879,0.010560318,0.02429284,-0.020233076,0.029355219,-0.060386937,0.023947679,-0.016477384,0.04312883,0.004367945,-0.028204678,-0.0009286505,-0.018622318,0.018720936,0.016370546,-0.025788542,-0.026035087,0.013288742,-0.017093744,-0.013231215,0.024917418,-0.012992889,-0.033891633,0.023372408,0.007909966,-0.016723927,-0.03750762,0.0021572635,0.06410154,0.057066806,0.011004098,0.021383615,-0.028845692,0.028977184,-0.03931561,0.0005778384,-0.0006230382,0.007478513,-0.031261828,0.015474769,-0.012080675,-0.03803358,-0.0019230462,-3.595439e-05,-0.024670875,-0.029486708,0.023964114,0.048289828,0.032248005,0.0050993594,-0.05078814,-0.022747828,-0.0357325,-0.008259237,0.053483695,-0.05772426,-0.01475979,-0.010272683,-0.07725057,-0.09210898,0.004041273,0.001558366,-0.050558034,-0.017603269,-0.048519935,-0.028204678,0.011653331,-0.041879673,-0.074949495,-0.048421316,0.0067799706,-0.03045645,-0.0040762005,0.019230463,0.041912545,-0.013896885,0.045068312,0.020118022,0.0057773567,-0.029404527,-0.014685827,-0.031524807,-0.045495655,-0.029207291,-0.009335814,-0.0019353734,-0.022928627,0.028714202,-0.01640342,0.027892388,0.037409,0.012014929,0.008505781,-0.049506113,-0.029437399,-0.013748959,0.08251019,0.019855041,0.025426945,-0.014792663,-0.08691511,0.058085855,0.03612697,-0.024029858,0.02434215,-0.0055513578,0.0050952504,-0.09197749,0.03223157,0.025377635,0.009048179,-0.04477246,-0.0026277523,-0.019838605,0.024950292,0.03997306,0.02468731,-0.012335437,0.016732145,0.02836904,-0.008941343,-0.014028375,-0.038329434,0.018638756,0.009483741,0.0018942826,-0.056540843,0.001999064,-0.051281232,-0.06400292,0.023355972,0.004197418,0.023191608,-0.02562418,-0.029946925,-0.00935225,-0.01839221,-0.034154616,-0.009286505,-0.03563388,0.0014659119,-0.02176165,0.061504606,-0.0048240516,0.0061348462,0.020331694,-0.016806109,0.042964466,0.043030214,-0.01927977,-0.040104553,0.03213295,-0.0028332057,-0.0038584196,0.033793017,-0.0107246805,-0.021317871,-0.011587586,-0.05700106,-0.011234205,-0.00028866238,0.036915913,-0.05877618,0.045199804,-0.010042574,-0.053615186,-0.046974923,-0.005399322,-0.020989144,0.007474404,0.02358608,0.028221114,0.05440413,0.022435538,-0.029618198,0.016025385,0.004885688,-0.023043681,0.025870724,-0.00230519,-0.051215485,-0.010215156,0.027760897,0.07606716,0.016197966,-0.008230473,-0.025377635,-0.06324685,-0.009081052,9.521493e-05,0.013781831,0.0010493546,0.020381002,-0.0039611463,-0.017340288,-0.008834507,0.0070182965,-0.008489345,0.0687037,0.05302348,-0.029305909,0.007852439,-0.015220007,0.0027818424,-0.023701133,-0.014891281,0.03288902,-0.0071045873,-0.047237903,-0.029207291,-0.01927977,-0.012097111,0.023010809,-0.014735136,-0.05430551,-0.00797982,0.03921699,-0.035140794,-0.001972355,0.008296219,0.006533426,0.015096734,-0.009590576,-0.033135563,-0.0005644839,-0.04273436,0.016863635,-1.4542266e-05,-0.008974216,0.05483147,-0.035502393,0.017504651,-0.032165825,0.021613725,-0.03612697,-0.0064471355,-0.036225587,0.022090377,0.02021664,-0.020676855,0.00935225,-0.017767632,0.0074538584,-0.01103697,0.024539385,0.0012994943,-0.00078329205,0.019394824,-0.09585646,-0.031985026,-0.052070174,0.01507208,0.04464097,0.053483695,0.0047459793,-0.01418452,-0.01711018,0.02016733,-0.013814704,-0.020561801,-0.003644748,-0.012598418,-0.013617468,-0.028845692,-0.02016733,-0.0019199643,-0.0333328,0.0503608,-0.012384746,-0.0012912762,-0.050656654,0.010100101,-0.038329434,-0.05506158,-0.018951045,0.009081052,0.04924313,-0.004441908,-0.019624934,-0.0070676054,-0.0013087398,-0.01804705,0.024917418,-0.03448334,0.027777333,0.0059376108,-0.029996233,0.033579346,0.044805333,0.020397438,-0.011982057,-0.032461677,0.022550592,-0.035140794,-0.0042528906,0.06975562,0.024243532,0.00398991,0.011719076,0.011957402,-0.0048569245,0.029305909,-0.035765372,-0.048355572,0.00030895093,0.013025762,0.00058913836,-0.0059293923,-0.01799774,0.010034356,0.0021510997,-0.038493797,0.029157983,-0.0030694776,0.009845339,-0.051577084,0.019361952,-0.012820308,-0.013132597,-0.004495326,0.028221114,0.011053407,0.0017607377,-0.0008824234,0.02003584,-0.01998653,-0.020906964,-0.0006307427,-0.027202064,0.07665887,-0.014307792,0.02340528,-0.014077684,-0.0114971865,-0.016781455,-0.024375021,0.0099357385,-0.032067206,-0.0025722797,-0.0038152742,-0.0019744097,-0.02504891,-0.011710858,0.019707114,0.011160242,-0.017964868,-0.023898369,0.022238303,-0.015836367,0.0077990205,-0.00014471641,-0.005962265,0.025541998,0.031212518,-0.037376128,-0.03484494,-0.008538654,-0.019361952,-0.0017247834,-0.016830763,-0.026051523,-0.03142619,0.04720503,0.0125902,-0.0037002203,0.030292086,0.040137425,-0.010363082,-0.041583817,-0.0111191515,0.013346269,-0.07028159,0.0041953637,0.013880448,-0.023635387,-0.022435538,0.013773613,0.0019846822,-0.01303398,0.026429558,0.01090548,-0.0012666218,0.01582815,-0.0126723815,0.021712342,-0.024851674,-0.039611463,0.0028722421,-0.0014648845,0.032658912,0.06975562,0.010494572,0.06354271,-0.061997693,-0.030785175,-0.03292189,0.007807239,0.02149867,0.0251804,0.026478866,-0.011653331,-0.048454188,0.05657372,0.04858568,-0.020676855,0.05289199,0.016912945,-0.022304049,0.03786922,-0.012006711,0.013099724,-0.04894728,0.019000353,-0.08625766,-0.036521442,0.009697412,-0.022369793,-0.025509125,-0.021169944,0.026100831,-0.011867003,0.010535663]');
INSERT INTO "public"."vector_store" VALUES ('3d80a87a-4a0b-4344-98a9-f48d90167629', '# Vue引入第三方_03

**操作**: 更新  
**分类**: study  
**时间**: 2026-05-09 20:44:14  
**标签**: Vue3  

## 简介

Vue项目中引入开源滑动插件Swiper，可实现触屏轮播、Tab切换等移动端交互效果，支持通过npm安装指定版本。

## 内容

#### Vue引入第三方

==Swiper==开源、免费、强大的触摸滑动插件

==Swiper==是纯JavaScript打造的滑动特效插件，面向手机、平板电脑等移动终端

==Swiper==能是实现触屏焦点图、触屏Tab切换、触屏轮播图切换等常用效果

> **温馨提示**
>
> 官方文档：https://swiperjs.com/vue
>
> 安装指定版本：‘npm install –save swiper@8.1.6 ’

##### 基础实现

![image-20240821224247128.png](http://118.89.135.164:9000/default/content/image_f31d9741-14c6-4df2-aecf-5b177754c7ae.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20260509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260509T094122Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=0f9b8e39e99dbcdb65013dda974318ae97b62304e2a0c4ff1e7c2e20b36b3553)', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "48f3d313bf923e3b34e9f60ce7ab3521", "document_id": 163, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[0.009634142,-0.027240828,-0.013378585,0.030454809,-0.05048758,-0.031609345,0.0031593742,0.12830961,-0.03841175,0.07601221,0.044870917,0.026991198,0.03622749,-0.016257126,-0.035041753,0.032607865,0.02987754,-0.06446684,-0.06708795,-0.019705135,0.024214068,0.01831657,0.072517395,-0.0089086555,-0.05142369,-0.005612765,0.0007469385,0.037007585,0.0040486795,0.045838233,-0.0011594123,0.026008282,0.019252682,-0.042655453,-0.02497856,0.024385689,-0.035322584,0.026913188,-0.029893141,0.023168745,-0.05360795,0.007898436,-0.03410564,-0.0044426266,0.010024188,0.031936985,0.011030507,0.004887279,0.00776192,0.023964439,-0.012887127,-0.01543803,0.0001512648,0.014392706,-0.0024163362,0.019658329,0.010180206,0.012512683,-0.018831432,-0.0067634014,0.009353308,0.029331475,0.0278493,-0.006455265,0.020391617,-0.05079962,-0.043685175,-0.013245969,-0.024619717,-0.020968884,0.013230368,0.009587336,0.019533515,-0.008643424,-0.021702172,0.045931842,-0.021655366,0.030314391,0.020454023,-0.010679466,0.002726423,0.01568766,0.03332555,-0.03678916,0.047554433,-0.011131919,0.003061863,-0.046649527,0.048833787,0.042717863,-0.012465877,-0.0107496735,0.012504881,0.009634142,-0.025758652,0.074639246,-0.053171102,0.017692497,-0.03451129,0.039035827,-0.017739302,0.019361895,-0.016007496,-0.02937828,0.046462305,0.043872397,-0.019221477,-0.005663471,-0.0011945165,-0.0120680295,0.032420643,-0.008659026,-0.014657937,0.036321104,0.014782752,0.042593047,-0.017318051,0.033138327,-0.02017319,0.006935022,-0.0028492876,0.031110086,0.008799443,-0.015399025,-0.011880808,-0.022185829,-0.029409485,-0.0013446843,0.029191058,-0.00438802,0.016257126,0.022731893,0.024198467,-0.056603506,-0.0025489521,-0.066963136,-0.012582891,-0.04243703,-0.03644592,0.00060798455,0.0063499524,-0.0168812,0.06440443,0.019892357,0.029253466,-0.044933323,-0.029643513,-0.020017171,0.007863332,-0.03156254,-0.0043529156,0.011912012,-0.04524536,0.03426166,-0.0041071866,-0.024635319,0.0020204394,-0.011420554,0.01029722,-0.042062584,-0.045432582,-0.014837358,-0.036071476,0.012504881,0.011467359,-0.06914739,-0.013066548,-0.007855531,-0.010983702,0.0062407395,0.0066112834,-0.022014208,-0.028052123,-0.041656937,-0.025274994,-0.013206965,0.02346518,0.047804065,0.01172479,-0.0843748,0.049239434,0.017068421,0.028816614,0.021983005,0.0017054771,0.016413145,0.005698575,-0.013027543,-6.734391e-05,0.0017444817,0.00021050307,0.08737035,0.0060067116,0.03198379,-0.026367124,0.005772684,-0.064154804,0.049333047,0.040096752,-0.007184651,0.040315177,-0.012348863,0.006771202,-0.010663863,-0.03476092,0.008003748,-0.02574305,-0.03104768,-0.027225226,0.012294257,-0.024370087,-0.01139715,0.016771987,-0.055667397,-0.024011245,0.005433344,-0.014884164,-0.008190971,0.028676197,0.027864901,0.02227944,0.026179902,-0.041095268,-0.0049886913,0.009821364,-0.030095967,-0.0006279744,0.007332869,0.0060730195,0.010250415,-0.045619804,0.057258785,-0.002270069,0.03579064,0.03644592,-0.0018156652,-0.036664344,-0.032763883,-0.0076605077,0.003771747,0.062719434,0.052952673,-0.015430228,-0.023917634,-0.020641245,-0.024089254,-0.035977863,0.015672058,0.029503096,0.037787676,-0.0037775976,-0.009322105,-0.008362591,-0.022607079,-0.008261179,-0.021826986,-0.019096663,0.051860545,0.046555918,0.0031827772,-0.02000157,0.017739302,-0.019658329,0.0120680295,-0.03560342,-0.011334743,0.0143380985,0.02220143,-0.06521573,0.0012588742,0.006650288,0.0026893686,0.005035497,-0.013378585,-0.0013056797,0.0022739694,0.03165615,0.04034638,-0.017614488,0.010874488,0.015266409,-0.027287634,0.02084407,-0.012317659,0.057570823,-0.013144557,0.08137924,0.04686795,-0.0033895017,-0.024697727,0.015804673,0.017442867,-0.010070994,0.002008738,-0.021421338,-0.0059209014,0.040439993,0.018488191,-0.032295827,0.039597493,-0.019221477,-0.021748977,0.00194048,0.0026601152,0.045931842,-0.008495207,-0.04693036,-0.10871368,0.056915544,-0.036321104,-0.041313697,0.027552865,-0.0017844614,0.009470322,0.015297612,0.00649817,-0.01670958,0.02928467,0.0155316405,-0.017786108,0.10403313,0.040283974,0.024245273,0.017832913,0.013089951,-0.025930272,0.02337157,0.024323283,-0.0032178813,0.030564021,-0.010429836,0.03866138,0.03298231,-0.008424998,-0.035977863,-0.022092218,-0.007527892,0.004177395,0.048833787,0.009415716,0.035977863,0.015789071,0.03164055,0.008339188,0.056946747,0.027552865,-0.028894624,0.03838055,0.0013378585,0.003781498,-0.0014353701,-0.0034811625,-0.002498246,0.009649743,0.0202512,0.010336225,0.013214766,-0.0004617172,-0.043061104,0.04362277,0.024838142,0.016397543,-0.00438802,-0.022466661,-0.014751548,-0.0056478693,0.0177237,0.048428137,-0.050674804,0.009883771,-0.013058747,-0.041407306,0.07076999,0.03529138,0.027568467,0.028941428,0.021499347,0.035478603,0.009220692,0.028504577,-0.048240915,0.014447312,-0.0012510732,-0.051673323,-0.03622749,-0.02185819,0.023855226,-0.010944697,0.019611524,0.009134882,0.04455888,0.067275174,0.02337157,-0.016553562,0.012902729,0.004126689,0.008362591,-0.005932603,0.030938465,0.00051973655,-0.008183169,-0.029425086,-0.026289115,-0.033356752,0.0048794784,-0.07045795,0.035072956,0.05470008,0.0024455898,0.033793606,-0.05638508,-0.05697795,-0.0038868105,0.027116014,-0.0219518,0.0037463938,-0.028582586,-0.0072431583,0.02009518,-0.0023246754,0.05519934,0.017240042,-0.05713397,0.043185916,0.019065458,0.11096035,0.0015075286,0.014033862,0.040408786,-0.022061015,-0.021202913,-0.056853138,0.027396847,0.021078097,-0.017162034,-0.01004759,0.046462305,0.042717863,-0.034916937,0.00032641992,-0.022154626,0.024073653,-0.031453326,0.08649665,-0.0033465966,0.026663559,0.0039024125,-0.017708099,0.011919812,0.01873782,0.0008688279,0.024604116,-0.020407218,0.05030036,-0.024323283,0.01408847,0.03087606,-0.021904996,0.02009518,-0.002396834,0.035135362,0.012965136,0.022076616,0.017037218,0.012621895,0.03644592,0.007028633,0.008027151,0.03089166,-0.016069904,-0.0062680426,0.02515018,0.0084484015,0.0019785094,-0.0014509719,-0.03644592,-0.0037951497,0.008190971,0.015633052,0.08624702,-0.03360638,0.035197772,0.020875273,0.016054302,-0.08112961,-0.09673146,-0.00061286014,-0.0060340147,-0.00092294684,-0.061377674,0.027958512,0.013487798,0.037818883,0.05179814,-0.01172479,0.013667219,0.017333655,-0.068398505,0.04162573,-0.058038875,-0.017427266,0.0031457227,-0.019564718,-0.0320462,-0.053233508,0.017411662,-0.009649743,-0.038505364,0.01628833,0.028644994,-0.028644994,-0.010359627,0.030002356,0.0075083897,-0.051954158,-0.004793668,-0.0045713414,0.03990953,0.015430228,-0.024448097,0.026023883,0.042093787,0.06540295,0.00077277905,-0.038255733,-0.015906084,-0.0506436,-0.03822453,0.037319623,0.007949142,-0.03087606,-0.018581802,-0.019455506,-0.028707402,-0.027162818,0.0506436,0.014509719,-0.006455265,0.023902033,0.011615576,-0.02354319,-0.013004141,0.0047000567,0.06465406,0.0037268915,0.010281619,-0.023605596,0.0024494901,0.037787676,0.0064201606,-0.010102197,0.016569164,0.027303236,-0.054450452,-0.0069857277,0.04736721,-0.009860368,0.039129436,-0.008268979,-0.05663471,0.00886185,-0.013222567,-0.010663863,-0.043154713,0.043404344,-0.043404344,-0.00607692,0.010695067,0.01697481,0.014665738,-0.006786804,0.018597404,-0.02329356,0.007758019,0.005074501,0.021530552,-0.0019892356,0.03148453,0.10272257,0.031453326,0.014954372,-0.010102197,-0.011202128,0.01805134,0.013479997,-0.016849997,-0.05182934,-0.044090826,0.0150401825,-0.0362899,0.025930272,-0.063062675,-0.044839714,-0.011342544,-0.008503008,0.013495599,0.010070994,0.017349256,0.057602026,-0.0070013297,-0.019720737,-0.016647173,0.0044270246,-0.020968884,-0.032389436,-0.040127955,0.018581802,-0.05139249,0.010141201,0.0016664724,0.036165085,0.071518876,-0.032795087,0.010476641,-0.035322584,-0.009298702,0.012676502,-0.045619804,0.03332555,0.016678376,-0.01569546,-0.0017513075,0.062344987,0.033200733,-0.017692497,0.033107124,0.0005343633,0.019658329,-0.011326942,-0.01806694,0.04446527,-0.016662775,-0.0073562716,0.0074069775,0.031125689,0.02710041,0.007972545,7.0695874e-05,0.05207897,-0.026725966,-0.01593729,0.017115228,-0.0065605775,-0.05975508,0.003132071,0.037694067,-0.003604027,-0.06275064,-0.013659419,0.03190578,0.022653883,0.022653883,-0.017193237,-0.047648046,0.0041461913,-0.04034638,0.0065527763,-0.04920823,-0.0025118976,-0.008370392,-0.044933323,-0.046275083,-0.025665041,0.010273817,-0.04331073,0.0027400746,0.00936891,-0.02007958,0.0074498826,0.020017171,-0.028223744,-0.025633838,0.024494903,0.030782448,0.007539593,-0.0041383905,-0.0077541186,-0.03332555,0.051454898,0.04945786,0.031016475,0.00088638003,-0.030579623,-0.008027151,-0.030782448,-0.0540136,0.0011028557,-0.0060808207,-0.047554433,0.03560342,-0.022809902,0.057414804,0.01755208,-0.047616843,-0.012021224,0.018613005,-0.016397543,-0.029846337,0.02007958,0.0202512,0.056104247,0.008190971,-0.06009832,-0.009860368,0.008588818,-0.04184416,0.012793516,-0.021546153,0.023855226,-0.030907262,-0.021686569,0.0312193,0.043497954,-0.025696244,-0.013877844,0.022076616,0.061128043,-0.00734457,-0.015422427,-0.020188792,0.024744531,0.07320388,-0.007828227,0.019205876,-0.08312665,-0.0040915846,0.0396599,0.015063585,0.0046181474,0.019564718,-0.04377879,-0.07045795,0.02490055,0.0011876908,0.012512683,-0.039472677,-0.020017171,-0.061627302,-0.07276702,-0.012692104,-0.00025206737,-0.048272118,0.07058276,-0.04412203,0.11408072,-0.00037615083,-0.035884254,0.032857493,-0.016600367,0.01806694,0.07008351,-0.017115228,-0.07701073,-0.0018556449,-0.0037756474,0.010858887,0.099976644,0.003173026,-0.034043234,0.015906084,-0.0632811,-0.0070364336,-0.012083632,0.025368607,-0.039940733,0.008768239,-0.026086291,-0.06421721,-0.026710365,0.022357449,-0.027381245,0.029035041,0.025945874,0.008791641,0.033075918,-0.016491154,-0.04312351,0.026398327,0.015211802,-0.021717774,0.01493877,0.01847259,-0.05376397,0.015672058,0.014353701,0.037101194,-0.010897892,0.014104071,-0.002710821,0.031297307,-0.0030852656,0.0023227253,0.03872379,0.012052428,0.010250415,0.003847806,0.020407218,-0.019283885,0.013479997,0.009431317,0.0071378457,0.006825809,-0.012676502,-0.005460647,-0.0039706705,-0.011771595,-0.012216248,-0.006455265,-0.0227787,0.017614488,-0.029815132,-0.04184416,-0.003789299,-0.0009092952,0.035228975,-0.01131134,-0.032420643,-0.0034850629,0.017988931,-0.01806694,-0.015991895,-0.02270069,0.014228886,-0.04346675,0.009431317,-0.018550597,0.024884949,-0.009657544,0.021670967,0.07913258,-0.013027543,0.040096752,-0.030033559,-0.030064762,-0.019954765,0.03984712,-0.0011282087,0.023839625,-0.026008282,0.047273602,0.021078097,-0.013347382,-0.012286455,-0.016990414,-0.002582106,0.0177237,0.014798353,-0.03401203,0.040970456,0.02564944,-0.093111835,-0.017318051,-0.036477122,0.05182934,0.06952184,-0.002972152,0.028005319,0.05045638,-0.013214766,-0.009103679,-0.0069077183,-0.011966618,-0.0027985815,-0.024853745,-0.0011789147,0.0005914076,0.02997115,-0.013308377,-0.0029819033,0.040783234,0.014314696,0.022934718,0.014197682,0.0061549293,-4.2905085e-05,-0.050331563,-0.019268284,0.0097355535,-0.006455265,0.012387868,-0.034074437,0.02354319,0.027896106,-0.044777304,0.019003052,-0.020578839,0.035853047,-0.0025645539,-0.020469625,0.00018673463,0.03703879,0.02589907,0.017271247,-0.00020428671,-0.0048248717,-0.043997213,0.039098233,-0.0031613247,0.020953283,0.020953283,0.040471196,0.0011545368,-0.021686569,0.025306199,0.012668701,-0.05173573,-0.005476249,0.012286455,-0.057789247,0.004001874,-0.02017319,0.011046109,0.009626341,-0.04930184,0.03838055,0.041064065,-0.0037463938,-0.08612221,0.023886431,-0.009907174,-0.005998911,-0.024323283,0.012356664,0.0030950168,0.017910922,-0.0016177166,0.004532337,-0.0194087,-0.0052032163,-0.026117494,0.011163123,0.05981749,0.0134175895,0.05975508,0.009049072,-0.021124903,-0.023324763,-0.05682193,0.027506059,-0.019564718,-0.024744531,-5.3631356e-05,-0.021873793,0.013160159,0.01739606,0.02344958,0.0132927755,-0.034480084,-0.013573608,-0.019720737,-0.043248326,-0.019065458,-0.03604027,-0.056946747,0.0008415247,-0.0014070917,-0.038474157,-0.048771378,-0.017489672,-0.020485228,-0.022139024,-0.021405736,-0.0038224529,-0.038692586,0.0053982395,-0.014353701,0.0068999175,0.019861152,-0.008900855,0.037506845,-0.05457527,-0.014751548,-0.007773621,-0.04911462,0.01080428,0.061377674,-0.029737124,-0.038442954,-0.002634762,-0.0010580004,-0.03941027,0.035697028,0.005597163,0.013331779,0.0031203697,-0.014486317,-0.006860913,-0.023948837,-0.037413232,0.014205483,0.013612613,0.0396599,0.0025450515,-0.011155322,0.020641245,-0.017364858,-0.03838055,-0.0337624,0.007570797,0.028145734,0.047804065,-0.007730716,-0.011834002,-0.052703045,0.013745229,0.04380999,0.019049857,0.016444348,-0.013058747,-0.0015085037,0.048896194,-0.036820363,0.04618147,-0.012504881,-0.0018595454,-0.037101194,-0.05360795,0.018706616,0.007972545,0.011857405,-0.044839714,-0.057352394,-0.0020886974,0.05753962]');
INSERT INTO "public"."vector_store" VALUES ('726bea61-8697-4418-9eca-a99bcd9d6a98', '# Vue事件处理_02

**操作**: 更新  
**分类**: study  
**时间**: 2026-05-09 20:44:18  
**标签**: Vue3  

## 简介

本文介绍了Vue中的条件渲染（v-if、v-else、v-show）及其区别，并简要提及列表渲染。

## 内容

#### 条件渲染

##### v-if

==v-if==指令用于渲染一块内容。这块内容只会在指令的表达式返回==true==值的时候被渲染。

##### v-else

你可以使用==v-else==指令来表示==v-if==的“else块”

##### v-show

另一个用于条件性展示元素的选项是==v-show==指令。

##### ==v-if==VS==v-show==的区别

==v-if==是“真正”的条件渲染，因为它会确保在切换过程中，条件块内的事件监听器和子组件适当地被销毁和重建。

==v-if==也是**惰性的**：如果在初始渲染时条件为假，则什么也不做—直到第一次变为真时，才会开始渲染条件块。

相比之下，==v-show==就简单得多—-不管初始条件是什么，元素总会被渲染，并且只是简单地基于CSS进行切换。

一般来说，==v-if==有更高的切换开销，而==v-show==有更高的初始渲染开销。因此，如果需要非常频繁地切换，则使用==v-show==较好；如果在运行时条件很少改变，则使用==v-if==较好。

#### 列表渲染

##### 用==v-for==把一个数组映射为一组元素

我们可以用==v-for==指令基于一个数组来渲染一个列表。==v-for==需要使用==item in items==形式的特殊语法，其中items是源数据数组，而==item==则是被迭代的数组元素的**别名**。

##### 维护状态

当Vue正在更新使用==v-for==渲染的元素列表时，它默认使用“就地更新”的策略。如果数据项的顺序被改变，Vue将不会移动DOM元素来匹配数据项的顺序，而是就地更新每个元素，并且确保它们在每个索引位置正确渲染。

为了给Vue一个提示，以便它能跟踪每个节点的身份，从而重用和重新排序现有元素，你需要为每项提供一个唯一的==key==attribute：

#### 事件处理

##### 监听事件', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "ae81d3149f7bc743cd8b24f0d7592854", "document_id": 164, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.06505301,-0.048958745,-0.01778416,-0.031287245,-0.05913032,-0.062477924,0.0012010343,0.133518,-0.0675959,0.05893719,0.031222869,-0.026764758,0.027778696,-0.010348611,-0.05845436,0.016456382,0.03318637,-0.07274607,-0.009270295,-0.00061912613,-0.023079172,0.00029698943,0.058100287,0.01755884,-0.059516583,-8.323751e-05,0.017735876,0.051051,0.012513289,0.06914095,0.022274459,-0.025509406,0.040396597,-0.04644804,0.013760594,0.022676814,0.00077755406,0.06379765,-0.05130851,-0.022177894,0.002251185,0.021630688,-0.026233647,-0.03278401,0.02734415,0.07371172,0.025412839,0.009503662,-0.007568327,0.02734415,0.037242122,-0.054656114,0.00889208,-0.0022733146,0.012030461,0.030595193,-0.030933172,0.0042730267,-0.0070895227,-0.038497474,-0.027617754,0.017253049,0.051211942,-0.0066791186,0.025815196,-0.08587898,-0.00047276894,0.0015872966,-0.025976138,-0.005769793,0.0014062362,0.01952234,0.03859404,-0.009914066,-0.03318637,0.025396746,-0.023932168,0.044548918,-0.005806005,0.021389274,0.010960192,-0.0029975562,0.017140388,-0.020359242,0.048862178,0.013108777,0.026877418,-0.06740277,0.00964851,0.08877595,0.011129182,-0.020858163,0.018942947,0.0010350622,-0.020037357,0.020327052,0.033701386,0.030015798,-0.03553613,-0.027987922,-0.013824971,0.019812036,0.023755131,0.029372029,0.058550924,0.03910906,-0.011829283,-0.020487996,-0.016223015,0.0076568453,0.0409438,-0.028213242,-0.019329209,0.003798246,0.012923692,0.021196144,0.057005875,-0.03247822,-0.010026725,-0.033443876,0.017381802,-0.004944962,-0.06714526,-0.0117246695,-0.0036191973,-0.005769793,-0.007773529,0.013269719,0.0031102162,-0.009213965,-0.021743348,-0.0054398607,-0.0067475196,-0.02378732,-0.027295869,0.037370875,-0.0045788176,-0.009447332,-0.009568038,-0.008594336,0.0020570478,-0.024720786,0.06518176,0.05150164,0.0056168973,-0.043261375,0.004156343,-0.006594624,0.019506246,-0.034570474,-0.0017854573,0.019570623,-0.0025951997,0.023867792,-0.0215985,-0.0052024703,-0.0015249313,-0.051372886,0.036759295,-0.07364734,-0.018395742,0.0037700809,-0.0605788,-0.025911761,-0.0024443162,-0.05343295,0.030820511,-0.010734873,-0.013760594,0.011282078,-0.0045627235,0.02549331,0.0092542,-0.03202758,0.025799101,-0.0147262495,-0.014710155,0.052370727,0.030144554,-0.044130467,0.006461846,0.024720786,0.007978731,-0.02446328,-0.0010089091,-0.011088947,0.036888048,0.020970823,-0.0023437268,0.022837758,0.0047115954,0.03296105,0.024930011,0.067016505,-0.024060922,0.018234799,-0.0040235654,0.034699228,0.01752665,0.019924697,-0.014090527,-0.032413844,-0.0025891643,0.0036936332,0.008658713,-0.0018880581,0.040171277,-0.008304639,0.004973127,-0.020520184,0.030418156,0.011113088,-0.008489723,-0.020697221,-0.057231195,-0.01842793,-0.041523196,0.0005492167,0.0051903995,0.003130334,-0.0092542,0.008216121,-0.0011547633,0.042649794,-0.018862475,-0.022982607,0.05903375,0.0065543884,0.049795646,0.022564156,0.011032617,0.036984615,0.0041804845,0.008594336,0.037853703,-0.02594395,-0.022596344,-0.0350533,0.024414996,0.067080885,0.014130762,0.028969672,0.0028828846,0.0042368146,0.0145492125,0.020310959,-0.00774134,-0.03881936,0.03904468,-0.032124147,0.00013064014,-0.018717626,-0.03775714,-0.062091663,0.016705845,0.011523492,-0.026668193,-0.011869518,0.02594395,-0.018492308,-0.01918436,0.049184065,-0.004009483,0.042617604,-0.063926406,-0.009069117,0.020761598,-0.056104597,0.0015017958,0.053368572,-0.0060876547,-0.001074292,0.019136077,-0.04799309,0.023240114,0.0051823524,0.024640316,0.03486017,-0.030047987,0.024414996,-0.021196144,-0.012038508,0.047027435,0.011475209,0.0468343,-0.013993961,0.025428934,0.052821368,0.018041668,0.0018699521,0.007785599,0.00055625796,0.035858016,0.06466675,-0.026764758,-0.02269291,0.020713314,0.007962636,0.0034260661,0.02114786,-0.010984334,0.0045063933,-0.00993016,0.011040663,-0.022145705,0.02352981,-0.025927857,-0.0818876,0.044838615,0.027939638,-0.048669048,-0.009318578,-0.005950853,0.0124811,0.023256209,0.008473629,-0.06325045,-0.007713175,0.012505242,-0.042392287,0.048733424,-0.0011929872,-0.027585566,0.009745075,0.028229335,-0.01582066,0.005447908,0.014581402,-0.016705845,0.0010149444,-0.04322919,0.015868943,-0.00560885,-0.0032067818,-0.013680123,0.0112177,-0.027295869,0.031158492,0.059098132,-0.018041668,-0.0015118547,-0.014227328,-0.0015460551,0.0019494175,0.011434973,0.03878717,0.0057536988,-0.008594336,-0.033669196,0.004289121,0.019956885,0.0090932585,-0.017542746,0.042166967,0.024833446,0.05845436,0.0283259,0.016383959,-0.049441572,0.025654254,-0.0035165963,0.006481964,-0.023626376,0.03711337,-0.0072263237,0.023996545,0.013486992,0.017285237,0.003399913,0.028374184,-0.03991377,-0.019377492,0.07583616,-0.010227904,0.014243422,0.0034280778,0.05089006,-0.030643474,-0.004993245,0.033315122,0.011869518,0.024978295,0.008875986,-0.03270354,-0.0014857015,-0.023384962,-0.007548209,-0.0005959906,-0.038465288,-0.023288397,0.061383516,0.028535126,-0.02880873,-0.032317277,0.046061777,0.009069117,-0.016818505,0.005765769,0.02269291,0.038690604,0.04509612,-0.013149012,0.02095473,-0.006047419,0.011660293,-0.01800948,0.050954435,0.06888344,-0.023835601,0.027424622,-0.0490875,-0.027215397,-0.009503662,0.04538582,0.013350191,0.008586288,0.016078169,-0.01548268,-0.0056973686,0.0020208359,-0.034988925,0.0052266116,-0.045321442,0.015474633,-0.00959218,0.133518,0.0040718485,-0.025734724,0.009455379,0.021550218,0.040300034,-0.020777693,0.048669048,0.041619763,-0.02790745,-0.016062073,0.019425774,0.019908601,-0.001333812,0.008228191,-0.029903138,0.0045788176,-0.01831527,0.019329209,-0.045675516,0.010807297,-0.011933896,-0.034506097,0.038014647,-0.028036205,-0.0052064937,0.013889348,0.009101305,0.00055977853,-0.03236556,0.001527949,0.0050978577,-0.06798216,-0.015756283,-0.0008474635,0.028502937,0.036276467,0.013124871,0.027505094,0.049248442,0.06022473,0.00037192833,0.010227904,-0.010509553,-0.05867968,-0.016609278,0.08729528,-1.0208226e-05,-0.036051147,-0.038529664,-0.08349703,-0.008755279,0.011040663,0.004325333,0.08884033,0.0011899695,0.045128312,-0.021003012,0.00031333516,-0.023143549,-0.049473763,-0.002389998,0.00079113356,-0.006992957,-0.020938635,-0.01553901,-0.010976287,0.016255205,0.00084343995,0.0070613576,0.063604526,0.036727104,-0.08819655,-0.0008605401,-0.01820261,-0.015804565,0.006148008,-0.020343147,-0.0017090094,-0.027778696,0.005480096,-0.020375336,0.014750391,0.015699953,0.043937337,-0.018363552,0.028486844,0.023433246,-0.030160647,0.004128178,0.018556684,0.032075863,0.058164664,-0.00037645485,0.027086644,0.059677523,0.0067193545,0.03315418,-0.06798216,-0.025412839,-0.010847532,-0.050503794,-0.024946107,-0.007789623,-0.024366712,-0.0023376916,-0.005528379,0.0049851974,-0.010549788,-0.03379795,0.038658418,0.03991377,-0.03514987,0.040010337,-0.015192984,-0.0035628672,-0.019602811,-0.017381802,0.027360246,-0.021083483,0.008352922,-0.0067193545,-0.0025147283,-0.01789682,0.023030888,0.0131812,-0.0037640457,0.037853703,-0.024978295,-0.023401057,0.04499956,0.0011165395,0.014589448,0.022789475,-0.030160647,-0.011040663,-0.025911761,0.036115523,-0.036051147,0.0074516432,-0.009399049,-0.025107048,0.0007936483,0.03904468,-0.0059025707,-0.016657561,-0.019039512,-0.025718631,0.004590888,-0.037403066,0.001537002,-0.013583557,0.055782713,0.045868646,3.5803445e-05,0.030450344,0.018524496,-0.023272304,-0.017623218,-0.0025066813,0.045772083,-0.014702109,-0.0032671352,0.010453223,-0.045321442,0.010316422,-0.010380799,-0.049377196,-0.008900127,-0.00089323154,0.03714556,0.002546917,0.018685438,0.04818622,0.008043108,-0.0043695923,-0.04055754,0.0007322889,0.014991805,-0.023191832,0.012706419,0.051115375,-0.03775714,0.0073751956,0.019892508,-0.008932316,0.08587898,-0.04705962,-0.006429658,-0.024640316,0.00058190816,0.009399049,-0.0370168,-0.007789623,0.044001713,-0.052016657,-0.025783008,0.018621061,0.0009369878,-0.015394161,0.020455807,-0.02507486,0.0165449,-0.006333092,0.008280498,0.027698224,-0.0010179621,-0.052081034,0.025412839,0.026410684,0.0011688458,-0.028937483,-0.01952234,-0.012746655,-0.027022267,-0.006139961,-0.016625373,0.017719783,-0.017076012,0.024221864,0.038915925,0.0023739038,0.0029573208,-0.017510558,0.029967517,0.024334524,-0.0021043248,-0.021630688,-0.047510263,0.028036205,-0.012899551,0.060289107,-0.04776777,0.0075240675,-0.035890203,-0.027215397,-0.05539645,-0.0164081,-0.02254806,-0.05513894,-0.040300034,-0.01576433,-0.028599504,0.027682131,0.023755131,-0.08014943,-0.039237812,0.025139237,-0.015885036,-0.0072102295,0.018637156,-0.04116912,-0.020777693,0.07132977,0.008360969,0.026941795,-0.021888196,-0.010944098,0.0013328061,-0.03840091,-0.05690931,0.033894517,0.031850543,-0.017912913,0.011620057,-0.022290554,0.02050409,0.05430204,2.4832943e-05,0.0771237,-0.00071820646,-0.065085195,-0.023320585,-0.020214394,0.05253167,-0.003027733,-0.012006319,-0.122509524,0.006019254,0.01865325,-0.006638883,-0.013229484,-0.024350619,0.029243274,-0.07602929,-0.028293712,0.034699228,0.0047478075,0.006908462,-0.014846956,-0.020825975,-0.0071941353,0.0025851408,-0.017253049,0.010243998,0.0035930441,0.03901249,0.0078097405,-0.0043816627,-0.057842776,0.035246436,0.050857868,0.007415431,0.029404217,0.0036614446,-0.05671618,-0.028100582,0.027070548,-0.036984615,0.02042362,-0.069398455,-0.01997298,-0.021131767,-0.08645838,0.011113088,-0.024044827,-0.035246436,-0.019152172,-0.046769924,0.042971678,0.034538288,0.0022049139,-0.024978295,-0.042360097,-0.053497326,0.012368441,-0.005765769,-0.058711868,0.032381654,0.024077017,-0.00096817047,0.049151875,0.00071418285,-0.014476789,0.0112337945,-0.014259516,-0.012014367,-0.03753182,0.037821516,-0.09289608,0.01149935,-0.018669344,-0.020777693,-0.04754245,-0.013318002,-0.004317286,0.008698949,-0.020681126,0.014484836,0.004767925,0.02348153,-0.033282936,0.0011436985,0.021324897,0.017655406,0.05089006,0.02987095,-0.048508108,-0.04084724,0.022821663,-0.0032932884,0.032333374,-0.021872101,-0.011539586,-0.029130615,0.010107197,-0.041362252,0.07873313,0.03553613,0.012207498,-0.0051541873,-0.0070895227,0.039366566,0.045031745,-0.021920385,-0.020874258,-0.01096824,-0.014154904,0.021550218,-0.014042243,-0.01702773,-0.019892508,0.03930219,0.014106621,0.033443876,-0.07815374,-0.013382379,-0.010493459,0.017768065,-0.0070895227,-0.031142397,-0.055975843,-0.0009666616,-0.017059918,0.036759295,-0.013953725,0.0053593894,0.02956516,-0.024221864,-0.015225172,0.0051823524,0.041394442,-0.05562177,0.062832,0.010815344,-0.035503943,0.0350533,-0.015434397,-0.015965508,0.019168267,0.02802011,-0.03009627,0.030498628,-0.047252752,0.0032188524,0.0017140389,-0.033958893,-0.011145277,-0.019956885,0.03991377,0.031061925,-0.022145705,-0.026829135,0.005142117,0.033057615,-0.059902843,0.025815196,0.0009857735,-0.01259376,0.035246436,0.03904468,0.022725098,0.05819685,0.025235804,0.02182382,0.009527803,-0.0771237,-0.005797958,0.018798098,0.0015359961,-0.022789475,0.03486017,0.0016909034,-0.019103888,0.02488173,-0.020600656,0.0067153308,-0.021437557,0.009849688,-0.0342164,-0.028181054,-0.033701386,-0.013696217,0.040042523,0.017076012,-0.032864485,0.0011457102,0.009213965,-0.0148630515,0.07274607,-0.038465288,0.0661796,0.012392581,0.0012483113,0.05510675,0.019039512,-0.006880297,-0.005117975,0.031770073,0.026909607,-0.021083483,-0.021872101,0.022886042,-0.0055203317,-0.019731564,-0.0071659703,0.024157487,0.011394737,0.015104465,-0.024688598,-0.04902312,0.0024765045,0.017961197,-0.043293566,0.0017643335,0.024125298,0.024447184,0.020874258,-0.039624073,0.0185084,0.030176742,0.02058456,-0.03772495,0.020858163,-0.030707853,0.01854059,-0.019715471,-0.009415143,0.0123121105,0.00029598354,-0.0063773515,0.002703836,-0.036469597,-0.014758438,-0.08568585,-0.015104465,0.05623335,-0.0035306788,0.009559992,0.04013909,0.004667336,0.018685438,-0.011620057,-0.0006140967,-0.014790627,-0.031512566,-0.00047855283,0.014935475,0.0027259656,0.011628104,0.023143549,-0.004518464,-0.021968668,-0.023159644,-0.042875115,-0.044387974,-0.061673213,-0.011282078,-0.00381434,0.028181054,0.029726103,-0.031512566,-0.05687712,0.016834598,-0.037821516,-0.032687448,0.0085058175,-0.03292886,-0.053111065,-0.0062204325,-0.006952721,0.025605971,0.01918436,0.023014795,-0.017381802,-0.025139237,-0.029516876,-0.0003734372,-0.046802115,-0.030627381,0.047703393,-0.022403212,-0.045514572,0.068625934,-0.017188672,-0.00094704673,0.013808877,-0.038079023,0.01623911,-0.008755279,0.0031061927,0.007906307,-0.039173435,-0.058357794,0.015780425,0.0027641896,-0.0061077722,0.03930219,-0.01323753,0.062542304,0.0036875978,0.020986918,0.0006030319,-0.002667624,0.05501019,0.07499926,0.0002992527,-0.0139215365,0.025670348,0.047284942,0.011491303,-0.02900186,0.03236556,-0.023159644,-0.0068843206,0.04715619,-0.01618278,0.032462128,-0.0045305346,0.06411954,-0.034345154,-0.042778548,0.014943522,-0.043744203,0.008521912,-0.013189248,-0.011595916,-0.048733424,0.028181054]');
INSERT INTO "public"."vector_store" VALUES ('9d528752-be88-41f9-bd94-07c3d45b3d8c', '我们可以使用==v-on==指令（通常缩写为==@==符号）来监听DOM事件，并在触发事件时执行一些JavaScript。用法为==v-on:click=“methodName”==或使用快捷方式==@click=“methodName”==

##### 事件处理方法

然而许多事件处理逻辑会更为复杂，所以直接把JavaScript代码写在==v-on==指令中是不可行的。因此==v-on==还可以接收一个需要调用的方法名称。

##### 内联处理器中的方法

这是官方的翻译称呼，其实我们可以直接叫他“事件传递参数”

#### 表单输入绑定

你可以用==v-model==指令在表单==<input>==、==<textarea>==及==<select>==元素上创建双向数据绑定。它会根据控件类型自动选取正确的方法来更新元素。尽管有些神奇，但==v-model==本质上不过是语法糖。它负责监听用户的输入事件来更新数据，并在某种极端场景下进行一些特殊处理。

##### ==.lazy==

在默认情况下，==v-model==在每次==input==事件触发后将输入框的值与数据进行同步。你可以添加==lazy==修饰符，从而转化在==change==事件之后进行同步

##### ==.trim==

如果要自动过滤用户输入的首尾空白字符，可以给==v-model==添加==.trim==修饰符

#### 组件基础

##### 单文件组件

Vue单文件组件（又名==*.vue==文件，缩写为**SFC**）是一种特殊的文件格式，它允许将Vue组件的模板、逻辑**与**样式封装在单个文件中

![image-20240821111337621](C:\Users\15839\AppData\Roaming\Typora\typora-user-images\image-20240821111337621.png)

##### 加载组件

##### 组件的组织

通常一个应用会以一颗嵌套的组织树的形式来组织

#### Props组件交互

组件与组件之间是需要交互的，否则完全没有关系，组件之间的意义就很小了

==Prop==是你可以在组件上注册的一些自定义attribute

##### Prop类型

Prop传递参数其实是没有限制的

> **温馨提示**
>
> 数据类型为数组或者对象的时候，默认值是需要返回工厂模式

#### 自定义事件组件交互

自定义事件可以在组件中反向传递数据，==prop==可以将数据从父组件传递到子组件，那么反向如何操作呢，就可以利用自定义事件实现==$emit$== 

#### 组件的生命周期', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "ae81d3149f7bc743cd8b24f0d7592854", "document_id": 164, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.0798979,-0.01246826,-0.017213777,-0.0038478384,-0.02917681,-0.067916825,0.010248873,0.14557731,-0.044820778,0.058714494,0.06253978,0.00932864,0.031558592,0.036719114,-0.030927058,0.041825507,0.03437342,-0.068133354,-0.03193751,0.0076280124,0.011656289,-7.605176e-05,0.093105964,-0.010609749,-0.023547146,0.023601279,-0.017746069,0.028076138,0.046156015,0.07968138,0.024377162,-0.010546596,0.022446476,0.006482232,-0.029194854,0.009869954,0.012793047,0.05611619,-0.0496926,0.0017344594,-0.02470195,0.022969745,-0.017917484,0.02066014,0.03377798,0.058570147,0.0142455725,-0.039335463,-0.019775994,0.03089097,0.024449337,-0.08285709,-0.033056226,0.052182645,-0.024918476,0.033922326,0.012296843,0.030909013,-0.010600727,-0.009094071,-0.0033426122,0.005706349,0.01708747,-0.045434266,0.031919464,-0.048718236,0.004422984,-0.020461658,-0.038216747,-0.025044782,-0.0096263625,0.024575643,0.023835847,0.0077317646,-0.008435472,0.06308109,-0.008579822,0.06084366,-0.004556057,0.014868083,0.0007764469,0.018458799,0.005683794,-0.045001216,0.04077897,0.01803477,0.055863578,-0.0787431,0.008706129,0.050703052,0.013045661,0.008024976,0.0009833866,-0.011223238,-0.05315701,0.046011668,0.044856865,0.01984817,-0.038036313,-0.011593136,-0.03251491,-0.016708551,0.015219938,-0.041392457,0.053229183,0.012982507,-0.026073277,-0.022807352,-0.011845749,-0.025513921,-0.021201454,-0.046444718,0.013135879,0.030728577,-0.01246826,0.028455058,0.010032347,0.0057334146,-0.021309717,-0.007979866,0.01684388,-0.0070235454,-0.051713504,-0.023222359,0.00285543,0.023114096,-0.021977337,0.010781165,-0.014822974,0.002765211,-0.014913193,-0.01732204,0.042511173,-0.025423702,-0.024683906,0.01894598,-0.019577513,-0.01970382,-0.049656514,-0.048573885,0.0036764224,-0.06542679,0.08754847,0.010817253,-0.0036313129,-0.03513126,-0.0142455725,0.00031773988,0.017709982,-0.023727585,0.03403059,0.028310709,-0.010113545,0.043052483,-0.061962377,-0.029267028,0.0024404228,0.008697107,0.037819784,-0.09339466,0.012901311,0.034247115,-0.033904284,-5.8184178e-05,0.018188141,-0.022121688,-0.046552982,-0.05297657,-0.004831225,-0.006468699,0.0030268459,0.04464034,-0.011548026,0.028870065,0.026831117,0.0072265384,-0.040526353,0.050270002,0.055899665,-0.054059196,0.027318299,0.011114975,0.016455937,-0.006549896,-0.0441712,-0.007068655,0.039155025,-0.0044094515,-0.0017558864,0.034716252,-0.0030358678,0.07217516,-0.01833249,0.040418092,-0.0024517002,0.0033381013,-0.040309828,0.004041809,0.03350732,0.004925955,-0.019920345,-0.01499439,-0.0055845533,0.034968868,-0.019595556,-0.016952142,0.016834857,-0.04608384,0.014669602,0.0072671366,0.040201567,-0.0027787439,-0.021544287,-0.010303005,-0.033074267,-0.001568682,-0.0656794,-0.008570801,0.012811092,0.010988669,-0.006640115,0.045037303,-0.0038320501,0.018440755,-0.013911763,-0.037495,0.05268787,-0.022590825,0.008033998,0.0491152,0.018449776,0.0033922326,0.029122679,0.040057216,0.025062826,-0.022157775,-0.029862475,-0.021778855,0.025189131,0.04611993,0.004197437,0.028581364,0.00048464496,0.0035501157,0.03184729,-0.012215646,0.022536695,-0.028310709,0.0005943174,0.002361481,-0.007682144,0.003326824,-0.027065687,-0.044243377,-0.010447355,0.029537685,0.008327209,0.02569436,0.046372544,-0.026506329,-0.017691936,0.03717021,0.009039939,0.023330621,-0.0364665,0.019270768,0.0094098365,0.0049665533,0.022193862,0.07249995,-0.0067664217,-0.016771704,-0.0025757512,-0.048718236,0.029682036,0.03513126,0.033092313,-0.0013713281,0.0036764224,0.047094293,0.01585147,-0.016221369,0.03742282,-0.0025757512,0.0061303778,-0.010591705,0.023980198,0.0153913535,-0.007921224,0.02656046,0.039985042,0.033489276,0.023059964,0.054817036,-0.01617626,0.0033403568,0.036827378,0.022428432,-0.010167676,-0.018567061,-0.00042600263,0.011250304,0.016158214,0.032045774,-0.0070957206,-0.004093685,-0.023186272,-0.087187596,0.040345915,-0.04406294,-0.032045774,0.027607,-0.010627793,-0.017168667,-0.010736056,-0.05283222,-0.02755287,-0.0025193642,-0.011836727,-0.012549456,0.021291673,0.020912753,0.020299265,0.005327429,-0.034752343,-0.011448786,0.005764991,0.028112227,0.018025747,0.0117645515,-0.021237541,0.023312578,0.008142261,-0.014380901,-0.027661132,-0.010718012,-0.02603719,0.008715151,0.05954451,0.0127569605,0.0071859397,0.021905161,0.006879195,-0.041572895,0.04117593,0.02755287,-0.00041387946,0.013153924,-0.01865728,0.007867093,0.018476842,0.0045718453,0.01284718,0.03745891,0.03911894,0.04759952,0.029627904,0.035871055,-0.013072726,0.020209046,0.0020096272,-0.017700959,-0.034247115,0.02917681,-0.014570361,0.040526353,0.035853013,0.034968868,-0.024882387,0.045722965,-0.027913744,0.004551546,0.054564424,6.5620196e-05,0.026073277,0.024882387,0.023150183,-0.007966334,-0.015310156,0.014353836,-0.009761691,0.017484434,-0.023619322,-0.037242383,0.0030110576,-0.021778855,0.052579608,0.013343384,-0.044568162,-0.020569922,0.009743647,0.0044680936,-0.014480142,-0.034734298,0.02022709,-0.0044094515,-0.0012010399,-0.042438995,0.010203764,0.013577953,0.03565453,-0.023059964,0.00671229,0.029158765,-0.042150296,0.015499616,0.033074267,0.038252838,-0.038721975,0.06896337,-0.015400375,-0.036105625,0.017809222,0.012567501,-0.01522896,-0.024774125,-0.018287381,-0.018305426,0.027823526,0.005349984,-0.020678185,0.033832107,-0.04160898,0.0117645515,-0.024665862,0.104220934,-0.009491034,-0.006179998,-0.01937903,0.016492024,0.027119817,-0.005354495,0.042908136,0.016392784,-0.018837718,-0.01613115,0.013334362,0.03879415,-0.002314116,-0.02917681,-0.05730708,-0.0020727804,-0.044784687,0.027534826,-0.01447112,-0.0034644078,0.015201894,-0.055214,0.054059196,-0.034156896,-0.00047223983,0.0180889,0.021436024,0.0043530646,-0.015824405,0.022049513,0.0028644518,-0.04160898,-0.030385744,-0.0010516146,0.06643724,0.010176698,0.011881837,0.0037147654,0.07105645,0.03246078,-0.034481686,0.023529103,-0.0146786235,-0.048898675,-0.0028261088,0.031378154,0.011818683,-0.045542527,0.002246452,-0.06448851,-0.010230829,0.012784026,-0.0048131812,0.09476599,-0.058028832,0.060951926,0.005891298,-0.018350536,-0.04525383,-0.033832107,-0.031684898,0.015066565,0.0061754873,0.011457807,-0.0032546488,0.006026626,0.011863792,0.02051579,-0.07462912,0.057270993,-0.005020685,-0.06780857,-0.009942128,-0.0023017111,-0.019505339,0.031233802,-0.0066987574,-0.0059409183,-0.04460425,-0.0021246565,-0.028707672,-0.012513369,0.024575643,0.045326002,-0.042763785,0.03164881,0.000741487,-0.05384267,0.00020693973,0.018097922,0.050703052,0.035492137,0.0092068445,-0.008151283,0.053481795,0.0029546707,0.026217628,-0.033344924,-0.028473102,-0.00647321,-0.046877768,-0.030854883,0.021147324,-0.013929807,0.0028486634,-0.002584773,-0.0002610711,-0.0058506993,-0.010573662,0.051027842,0.028003963,-0.012350975,0.0082009025,0.06679811,-0.018269338,-0.0046372544,-0.024774125,0.03269535,-0.00937375,0.027264168,0.024124548,0.0100594135,-0.015012434,0.023637366,0.0056567285,0.044820778,-0.016455937,-0.023601279,-0.05099175,-0.020425571,0.0052823196,0.045759052,0.0009918446,-0.031017277,-0.012811092,-0.030115087,-0.022211907,-0.07329388,-0.0032388605,-0.0104924645,-0.0053003635,0.0022058534,-0.019721864,0.03403059,-0.008588845,-0.019812083,-0.036610853,-0.011123997,-0.026650678,-0.006730334,0.014254595,0.032388605,0.015436463,-0.00475905,0.017159645,0.032442737,-0.06502982,-0.03356145,-0.0030448898,0.030981189,0.01946925,-0.0014435033,0.0433051,0.0018912149,0.0048267143,-0.009301574,-0.08177446,-0.008458027,0.0092068445,0.019126419,0.0074475748,0.020299265,-0.00058191223,-0.000105936786,-0.0035659042,-0.017728025,0.028906154,0.033254705,-0.04745517,-0.029682036,0.023583235,-0.022049513,0.00043953548,0.007181429,0.021219498,0.049079113,-0.018549018,-0.012576522,-0.014777864,0.030115087,0.013785456,-0.046336453,0.0024810212,-0.010817253,-0.044243377,-0.028617453,0.0073979544,0.018675324,0.0017152879,0.035672575,-0.018007703,0.017917484,-0.00785356,0.009833866,0.021490155,0.01880163,-0.008363297,-0.0066762026,0.004934977,-0.0073032244,-0.037206296,-0.05510574,-0.014759821,-0.014498186,0.026307847,0.017123558,0.042042032,-0.028346796,0.04597558,0.025965014,-0.00054638856,-0.051100016,-0.004454561,0.042511173,0.01937903,0.035095174,-0.010095501,-0.0002965948,-0.002803554,-0.017340083,0.018007703,-0.044351637,0.004136539,-0.013893719,-0.0038613712,-0.07823788,0.029573774,-0.021869075,-0.024972606,-0.0021212732,0.00932864,-0.01827836,0.008719662,0.013397515,-0.055574875,-0.061854117,0.01480493,-0.02461173,0.0064100567,0.025946971,-0.032009684,-0.05535835,0.07112862,0.018567061,0.03013313,-0.034734298,0.0190362,-0.008191881,-0.031468373,0.010736056,0.00604467,0.015977778,-0.025766533,-0.0033132911,-0.0057424363,0.015030478,0.040562443,0.025928928,0.077949174,-0.0099962605,-0.076072626,-0.010375179,0.0059409183,0.06492156,-0.0052417214,0.009545165,-0.12009947,-0.0055845533,0.04803257,-0.030584225,-0.009887997,-0.03083684,0.011575092,-0.073835194,-0.020172957,0.027065687,0.0074701295,0.011999121,-0.027191993,0.027246125,0.030764664,0.022554738,-0.010131588,-0.015156784,-0.00038850537,0.033922326,0.0008136622,0.004253824,-0.040237654,0.028112227,0.018097922,-7.8941586e-05,0.010871384,0.03421103,-0.052326992,-0.026001103,0.028418971,-0.03911894,0.0153913535,-0.027480694,-0.04045418,-0.03237056,-0.021526242,-0.025026739,-0.015932668,-0.025171088,-0.024918476,-0.061998464,0.03603345,0.0023524591,-0.029393336,-0.030566182,-0.055755313,-0.0148951495,0.016762681,0.0014051602,-0.06773639,0.015274069,0.010627793,-0.019541426,0.06802509,0.0006743867,-0.00048154366,0.018855762,0.015364288,-0.024774125,-0.02094884,0.029050503,-0.07347432,0.016654419,-0.030313568,-0.02751678,-0.021814942,-0.026109366,0.009978216,-0.003013313,0.017114535,0.036520634,0.052471343,-0.011502917,-0.03042183,0.03132402,-0.03013313,-0.020299265,-0.00082212023,0.013072726,-0.13114227,-0.018603148,0.023114096,0.012432172,0.032857742,0.0082009025,-0.0032862255,-0.00061969145,0.0060942904,-0.022717133,0.041825507,0.015129719,-0.031396195,0.007158874,-0.03498691,-0.005340962,0.01909033,-0.01660931,-0.0026050722,0.019812083,-0.062287167,0.019613601,0.01865728,-0.04608384,-0.02598306,0.0051109036,-0.037098035,0.039299376,-0.040670704,-0.025838709,-0.0005435692,0.043016396,0.04027374,-0.023763673,-0.055214,-0.010411267,0.01375839,-0.011015735,-0.017574653,-0.036953684,0.0303677,-0.014786887,0.009815822,0.0057424363,0.015129719,-0.030782707,0.01775509,-0.049620423,0.026867205,0.03365167,-0.016654419,-0.017935527,0.014795909,0.058281444,-0.04117593,0.024575643,-0.02423281,-0.019721864,-0.004632743,0.01717769,0.0033629115,-0.008403895,-0.015472551,-0.01137661,-0.0604467,-0.019595556,-0.047382995,0.010465398,-0.056657504,-0.032821655,-0.038144574,-0.012432172,-0.0049034003,0.03083684,0.023529103,0.04640863,-0.021237541,-0.0069062607,0.0057379254,-0.061060186,0.010862362,0.016203323,-0.010393224,-0.03455386,0.02713786,-0.020624053,0.013099792,0.03760326,-0.05308483,0.05835362,-0.036249977,0.0168529,-0.009743647,-0.03606954,-0.04669733,0.0017773134,0.008904611,-0.0045199697,-0.021778855,0.013938828,-0.00016873764,-0.01894598,0.059183635,-0.017691936,0.045109477,0.003913247,0.0013352406,0.03136011,0.03597932,0.010086479,-0.022139732,-0.010736056,0.013586975,-0.013776435,0.010420289,0.010546596,-0.018007703,0.039660253,-0.014146332,-0.014750799,0.043052483,-0.0027787439,0.02499065,-0.03940764,0.0012811092,-0.0035771816,-0.027390474,0.012206624,-0.022482563,-0.00012694088,0.014218507,-0.045867316,0.0006958137,0.032857742,-0.0029930137,-0.015409397,-0.01575223,-0.027805481,-0.01541842,-0.0674116,-0.00861591,-0.0018269338,0.015192872,-0.0026975467,-0.0020006052,0.017926507,-0.04135637,-0.08993025,-0.0004291039,0.034102764,-0.029447466,0.033308838,0.042186383,0.0035568823,0.009797778,-0.04240291,0.0033944882,0.008381341,-0.026831117,-0.0021370614,-0.0014389923,-0.038216747,0.027011555,0.07924833,-0.0010843191,-0.008006932,0.037639346,-0.072752565,0.0005303183,-0.01775509,0.014480142,-0.013478712,0.04027374,0.040237654,-0.04074288,-0.002936627,0.03469821,-0.022175819,0.012080318,0.0043778745,-0.013523822,-0.031720985,0.03958808,-0.003322313,-0.000510301,0.003356145,0.016825834,-0.00054977176,0.002108868,-0.016077017,-0.013677194,-0.036953684,-0.03742282,0.054889213,-0.015625922,-0.0389385,0.073402144,-0.001401777,0.002679503,0.0076189907,0.0187475,0.010817253,-0.03460799,-0.056080103,0.011539004,-0.030024868,-0.02569436,-0.023402797,0.0072806696,-0.03789196,0.045037303,0.040309828,0.0072942027,0.016528113,-0.0075558373,-0.03294796,0.04583123,0.020678185,0.07246386,-0.0328397,-0.031089451,0.02894224,0.04373815,-0.008512158,-0.014173398,0.013776435,-0.016663441,-0.052471343,0.013117836,-0.022103643,0.033399057,0.037711523,0.0020445872,-0.06647333,-0.03745891,0.011818683,0.0023028387,0.029230941,-0.02850919,-0.06318936,-0.09404424,0.00054300536]');
INSERT INTO "public"."vector_store" VALUES ('cfbf13ff-a428-4fda-ac12-0c26ebc8e9fb', '每个组件在被创建时都要经过一系列的初始化——例如，需要设置数据监听、编译模板、将实例挂载到DOM并在数据变化时更新DOM等。同时在这个过程中也会运行一些叫做 **生命周期钩子**的函数，这给了用户在不同阶段添加自己的代码的机会

八个生命周期函数

创建时：==beforeCreate==、==created==

渲染时：==beforeMount==、==mounted==

更新时：==beforeUpdate==、==updated==

卸载时：==beforeUnmount==、==unmounted==', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "ae81d3149f7bc743cd8b24f0d7592854", "document_id": 164, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.08570087,-0.007687466,-0.020489685,-0.06637677,-0.030105729,-0.06539522,-0.031102607,0.11109827,-0.0221307,0.02825,0.028679425,-0.0116864825,0.06717427,0.0080057,-0.039445713,0.046929967,-0.00023508118,-0.079443544,-0.02685437,-0.018189197,-0.004669992,-0.014477742,0.06766504,0.0024212643,-0.06674484,0.008128393,-0.0145007465,0.04781949,0.03732926,0.022069354,0.0055633485,-0.044138707,-0.019492807,-0.0042328993,0.030918567,0.022253394,-0.0125606675,0.047788817,-0.014914835,-0.006824783,-0.058064334,0.0122692725,-0.0011876272,0.0484943,0.04211428,0.05002796,0.01844992,-0.0043939333,-0.032636266,0.0116864825,-0.002413596,-0.015152552,-0.0006561185,-0.013097448,-0.037543975,0.0301364,0.02294354,0.034630023,-0.011663477,-0.030596498,-0.009485682,0.017606406,0.026639659,-0.049138438,0.03828013,-0.031961456,0.014370386,0.068033114,-0.009976452,-0.02226873,0.05533442,0.017851792,0.00773731,-0.0039683427,0.0011598297,0.045058902,-0.038586862,0.017192319,-0.019768866,-0.026240908,0.018434582,-0.022468105,0.0139179565,-0.03055049,0.018066503,-0.009677389,0.027912596,-0.013595887,0.053463355,0.13398045,-0.0079826955,-0.013396512,-0.037145223,-0.023464983,-0.04008985,0.0189867,0.007906012,-0.009930443,-0.07177524,0.014876493,-0.0056400313,0.012476317,-0.003268611,-0.018541938,0.048555646,0.024599891,-0.023020223,0.0026608985,-0.018403908,-0.012974756,0.013549878,-0.04781949,0.0040335236,0.0065333876,-0.024139794,0.037145223,0.0109579945,0.0054981676,-0.036654454,0.009002578,0.023265608,-0.009838423,-0.0288788,-0.0036750305,0.05613192,0.028280674,-0.011180375,-0.0320228,-0.0022889862,-0.0065870658,0.007794822,-0.0015202395,0.018296553,-0.038433496,-0.04358659,-0.00026575435,-0.0023541667,0.0047160015,-0.054874323,-0.043310534,-0.02524403,-0.053739414,0.013005429,0.005686041,0.01875665,-0.01034453,-0.032145493,-0.018925354,0.031117942,-0.019063383,0.031900108,0.07686699,-0.0145007465,0.034353964,0.008764862,-0.010896647,0.016502172,-0.036378395,0.010160492,-0.0422063,-0.030167075,0.007522598,-0.008297096,-0.0047926847,0.008297096,-0.0400285,-0.030489143,-0.03874023,-0.014677118,0.00514926,-0.0033318743,0.047267374,-0.03153203,-0.02775923,0.02357234,-0.029522937,-0.02371037,0.07637622,0.025949512,-0.04466015,0.009961116,0.014999186,-0.016226113,-0.0071008415,-0.043218512,-0.042727742,0.0035772598,0.008166735,0.023434311,0.028004615,0.016118757,0.11453366,-0.0076376223,0.0042175623,-0.06637677,-0.014914835,-0.025274701,0.03634772,0.05870847,-0.0033395425,-0.022468105,-0.042236973,-0.02766721,0.018879343,0.023142915,-0.01912473,-0.011042345,-0.03441531,0.0073845685,-0.007296383,0.023188926,0.009247964,-0.014385723,-0.020842427,0.005839407,-0.024569219,-0.05137758,0.0059237583,0.003142084,-0.026041532,-0.0028372693,0.03778936,-0.014784474,0.03162405,-0.028541395,-0.041347448,0.0177291,0.034691367,0.018480591,0.055641152,-0.018541938,-0.005118587,0.014876493,0.035550218,0.008197408,-0.009339984,-0.041408796,0.016640201,-0.00078839663,0.045703042,0.026915716,0.018005157,-0.018956026,-0.0048732017,-0.009800081,-0.01866463,-0.02059704,0.026440283,0.0059045875,0.0031037426,-0.029124185,-0.030090392,-0.00598127,-0.017253665,0.038801573,0.029538274,0.000965726,0.02496797,0.04947584,0.012131243,-0.045580346,0.049721226,0.004650821,-0.0045588017,-0.010835301,0.005942929,-0.0017761689,-0.001958291,-0.048954397,0.032053474,-0.0057128803,0.021394543,-0.0074459147,-0.026654994,0.02959962,-0.01912473,0.009462677,-0.016946932,-0.023096906,0.05091748,0.027774567,0.00015144884,0.020566368,0.029522937,0.004516626,0.010152823,0.016793568,0.014761468,0.017345684,0.013020766,-0.007583944,0.032574918,-0.011487107,0.033679154,-0.010804628,-0.03935369,0.032513574,0.01740703,0.006203651,-0.00043230015,0.0045549674,0.0013544126,-0.003115245,0.011356746,-0.028894138,-0.024078447,-0.021823969,-0.08705049,0.035979643,-0.017713763,0.019830212,0.015106542,0.017192319,-0.035703585,0.012599009,-0.023234935,-0.04058062,-0.029630294,-0.004562636,-0.03239088,0.051254887,-0.04281976,-0.012338287,-0.0050419043,-5.1850857e-05,0.0074689197,0.018388573,0.00043038308,0.0022985716,0.0029522937,-0.03410858,0.018281216,0.0058355727,-0.014861156,-0.014232356,-0.018189197,-0.011149702,0.015175557,0.08367644,0.042298317,0.008044042,0.06171444,-0.024492536,-0.009339984,-0.0021413716,0.03874023,-0.02443119,0.041286103,-0.025290038,0.0031746742,-0.011563789,0.01682424,0.020121608,0.045273617,0.014263029,0.010927321,0.014968513,0.01794381,0.008082383,0.02897082,-0.0030826547,-0.018434582,-0.06300271,0.014286035,0.014424063,0.04143947,-0.0062688314,0.025428068,-0.027636537,0.055150382,-0.0024442691,-0.026470955,0.007342393,0.013289156,0.015697,0.06349348,0.022498779,-0.02864875,-0.041960914,0.018388573,-0.014654113,0.057236157,-0.006679085,-0.06131569,-0.011586795,-0.031654723,-0.019983578,0.01214658,0.014470073,-0.02168594,0.060027417,0.0035523379,-0.014661781,-0.017667752,0.0054789972,0.005789563,-0.02982967,-0.016747557,0.057328176,0.0047811824,-0.01174016,-0.0072273687,-0.0047121677,-0.0014493079,-0.02901683,0.014562093,0.027835913,0.0131818,-0.013220142,0.048831705,-0.01933944,-0.04674593,0.060456842,0.00072561245,-0.013151127,-0.016640201,-0.04981325,-0.017023616,-0.0045818067,-0.005402314,-0.021471227,0.045426983,-0.014155674,0.031301983,0.0017627494,0.091958195,-0.0035005768,-0.02524403,0.0039875135,0.0031094938,0.010275516,-0.027835913,0.047482084,0.022836184,-0.019891558,-0.018741313,-0.0029542109,0.029415581,-0.004673826,-0.00726571,-0.055855863,0.019370114,-0.024001764,-0.004539631,-0.011586795,-0.04763545,-0.033188384,-0.056776058,-0.017069625,-0.00052336114,-0.024277823,0.022836184,-0.0060847923,0.0015614567,0.026593648,0.017161645,-0.019109393,-0.028234664,-0.010451887,-0.011533116,0.056315962,0.036685124,-0.014868825,0.008810871,0.03159338,0.045488328,0.015075869,0.033863194,0.013258482,0.010934989,0.029323561,0.03410858,0.023357628,-0.019063383,-0.013373507,-0.03818811,-0.00949335,0.020443676,0.00649888,0.029660966,-0.058739144,0.0288788,-0.009700393,0.0021490399,-0.042758416,-0.074351795,-0.018741313,0.021532573,0.015405606,-0.019216748,0.009577701,0.04533496,0.027789902,0.0033395425,-0.039568406,0.06545657,0.048647664,-0.057512216,0.030167075,-0.03337242,-0.04530429,0.011724824,-0.05475163,-0.012944083,-0.05349403,-0.0010112565,-0.04656189,-0.016732221,0.026915716,0.0045664697,-0.02059704,0.04674593,0.0018317641,-0.010352199,0.021440554,0.011019341,0.039691098,0.04588708,-0.021440554,-0.012069897,0.03242155,0.02001425,0.027452497,-0.049015746,-0.04104072,0.022115365,-0.03837215,-0.028848127,-0.023863735,-0.058187027,-0.0060349484,0.0076452903,-0.012499321,0.042083606,0.021793295,0.009010247,0.028019952,-0.022406759,0.0013707078,0.0053984798,-0.017161645,-0.01619544,0.009025584,0.017161645,-0.0027356644,0.01912473,0.035120793,0.034875408,-0.009079262,0.018618621,0.0039261673,0.01749905,0.026087541,0.022652145,0.023725705,0.009554696,0.02096512,0.07189794,0.008488803,-0.028127307,-0.014914835,-0.047942184,0.010037798,-0.03478339,0.013641898,0.0081437295,0.03032044,0.028541395,0.022882193,-0.001931452,-0.06846254,-0.029262215,-0.026654994,-0.03174674,-0.019370114,0.026087541,0.0131741315,0.017207654,0.10128284,0.0032839475,0.009408998,0.046868622,0.012737039,0.040427253,-0.0019745862,0.013733917,-0.013894951,-0.014608103,0.052911237,0.0031267474,0.011226385,-0.009485682,-0.0547823,-0.0027797571,0.0054291533,0.03800407,0.0085808225,-0.0146464445,0.0010035882,0.06772639,-0.0354582,-0.018725978,0.0019784202,0.0018883178,-0.017897801,0.019784203,0.028587405,0.00035873245,0.004470616,0.023096906,0.012836726,0.058585778,-0.05456759,0.01291341,-0.009508686,0.008826208,-0.0014828566,-0.038525518,-0.046224486,-0.025765473,0.024185805,-0.026532302,0.044292074,0.041500814,-0.008925896,-0.013956298,-0.00044715748,-0.03874023,0.02317359,-0.0046163136,-0.03355646,-0.020397665,-0.026240908,-0.019385451,0.014930171,0.024109121,0.0013131956,-0.03760532,0.020167617,-0.013166463,0.03846417,-0.01889468,0.0093093105,-0.01070494,-0.013718581,0.031179288,-0.006778773,0.026179561,-0.028894138,0.04953719,0.028694762,0.023204261,-0.034538,-0.011042345,0.011640472,0.020489685,-0.005199104,-0.027697884,0.008373778,-0.028541395,-0.04714468,-0.06766504,-0.0031516694,-0.009662053,-0.098767646,-0.06459772,-0.0027950937,-0.0010975248,0.03159338,0.021241179,-0.050396036,-0.0422063,0.045058902,-0.014493078,0.0048310263,0.017867127,-0.01299776,-0.04107139,0.06913735,0.012031555,-0.015965391,0.012944083,-0.06539522,0.026931053,-0.04840228,-0.021041803,0.016026737,-0.008044042,-0.027943268,0.01106535,-0.004988226,0.00077641493,0.052849893,0.0037497964,0.06833985,-0.0005420526,-0.08858415,-0.023004886,-0.02140988,0.049015746,-0.0030749864,-0.01174016,-0.04398534,-0.031869438,0.0447215,0.0082740905,-0.0139179565,-0.013657235,-0.00035609645,-0.00575889,0.011755497,0.022560125,0.025796145,-0.009247964,0.0072043636,0.03094924,0.020627715,-0.00985376,-0.0044054356,-0.0069398074,0.03441531,0.029369572,-0.0085808225,0.029338898,-0.032114822,0.03324973,0.033740498,-0.008174403,-0.046807274,0.014907166,-0.039599076,-0.04880103,-0.0061423047,0.014462405,-0.020459013,0.007503427,0.00841212,-0.053770088,-0.07496525,-0.05410749,-0.027222449,-0.029906353,0.012253936,-0.024584556,0.025336048,0.010283184,-0.021149158,-0.033280402,-0.014416396,-0.0497519,-0.0011272394,0.00036640075,-0.060702227,0.009010247,-0.0035370013,0.0025976351,0.06649946,0.039200325,-0.022146037,-0.016287459,0.017560396,-0.031117942,0.013718581,-0.010781623,-0.055303745,0.042236973,-0.039169654,0.027437162,-0.0064298655,-0.029568948,-0.004125543,0.01111136,0.030780537,0.03174674,0.020443676,-0.0016822323,0.020673724,0.005413817,0.005210607,0.022560125,0.03478339,0.035427526,-0.17839523,-0.014301371,0.016471498,0.035734255,0.024952633,-0.023280945,-0.0061116316,-0.013411849,-0.033985887,-0.021609256,0.07189794,0.012691029,0.0023733375,-0.022115365,-0.0026072206,-0.0049153776,0.06625407,-0.023234935,-0.026593648,0.0046316506,-0.0106512625,-0.0035523379,-0.015574308,-0.032145493,-0.01880266,0.018419245,-0.043402553,0.0088875545,-0.07245006,-0.024185805,0.043801304,-0.014891829,0.0009470345,-0.013281488,-0.043310534,-0.002047435,0.034353964,-0.017683089,0.00037838245,-0.0018911933,0.019293431,-0.021839306,0.0067634364,-0.005421485,-0.009370657,0.033341747,0.018864006,0.0079980325,-0.07962758,0.029860342,-0.041592833,-0.02029031,0.023802388,0.020044925,-0.034660697,0.017575733,-0.014293702,0.013442522,-0.034200598,-0.039384365,-0.0138106,-0.03505945,-0.06956678,-0.04785016,0.002624474,-0.010336862,-0.0015509127,0.024446527,-0.057420198,0.0007467003,0.0107969595,0.013289156,0.03275896,0.016042074,0.023541667,0.029369572,0.0033778842,-0.013043771,0.0077411444,-0.028771445,0.01970752,-0.00038892636,-0.04058062,-0.067051575,0.04462948,-0.010773955,0.00013946713,0.023679696,-0.0046393187,-0.0003170361,-0.031179288,0.040856678,-0.00057895633,-0.03432329,-0.05395413,0.007629954,0.006046451,0.025658116,-0.011080687,-0.013097448,6.8235844e-05,-0.045273617,0.07085505,0.024523208,0.013933293,0.016272122,0.0079826955,0.0052834554,0.0042022257,0.014385723,-0.0036136843,0.000965726,0.0547823,0.0025497081,-0.07564007,0.008925896,0.03297367,-0.01943146,0.023771716,-0.006667583,0.013442522,0.0059851045,0.018956026,-0.016609527,-0.005057241,-0.010536238,-0.015904045,0.021747286,-0.030351114,0.0033913036,0.02825,-0.054414224,0.039967157,0.028142644,0.035826277,-0.009094599,0.029476928,-0.041807547,-0.03874023,-0.054536916,0.013005429,-0.035642236,0.018127851,-0.0050840797,-0.024369843,-0.02348032,-0.048739687,-0.077173725,-0.0108122965,0.011195711,-0.003011723,0.036991857,0.03099525,0.010352199,0.021333197,-0.074351795,-0.0003330916,-0.012783049,-0.033311076,-0.0023292447,0.023112243,-0.0015930884,0.024891287,0.012721702,-0.0017493299,-0.046101794,-0.01012215,-0.038096093,0.005057241,-0.05330999,-0.02371037,-0.018250544,-0.016946932,0.021609256,0.011801506,-0.057696253,0.010850638,-0.03729859,0.0020589372,0.00809772,0.026026195,-0.026762351,0.00845813,-0.07042562,0.045242943,0.021394543,-0.0065218853,-0.00068727095,-0.018127851,0.0189867,-0.010451887,-0.051807005,0.012491654,0.035366178,-0.010014794,-0.03518214,0.066192724,-0.018480591,0.024891287,0.0051952703,0.0027720889,0.03662378,0.0053869775,-0.015382601,0.0043555917,0.0054598264,-0.062143866,-0.048064876,0.05186835,0.0009331357,0.06131569,0.021026466,0.09398263,-0.0056745387,0.04512025,-0.0227595,0.004186889,0.0138106,0.05926059,-0.0035600062,-0.012246268,-0.021563247,0.033985887,-0.008396784,-0.00025377265,0.006207485,-0.029952362,-0.027345141,0.06833985,-0.025719462,0.020459013,0.013795263,0.05987405,-0.046255156,-0.042789087,-0.0017052372,-0.058371063,0.036102336,-0.058616452,0.029047502,-0.037083875,0.015106542]');
INSERT INTO "public"."vector_store" VALUES ('97ceffee-a843-4118-a52f-b50311a05929', '# Vue模板语法_01

**操作**: 更新  
**分类**: study  
**时间**: 2026-05-09 20:44:22  
**标签**: Vue3  

## 简介

介绍Vue模板语法中的文本插值（双大括号）和原始HTML渲染（v-html指令），并展示如何在data中定义数据实现动态绑定。

## 内容

### 模板语法

#### 文本

数据绑定最常见的形式就是使用“Mustache”（双大括号）语法的文本插值。

```html
<span>Message: {{ msg }}</span>
```

一般配合==js==中的==data()==设置数据

```vue
export default {
	name: ''Hello World'',
	data(){
		return{
			msg:"消息提示"
		}
	}
}
```

#### 原始HTML

双大括号会将数据解释为普通文本，而非HTML代码。为了输出真正的HTML，你需要使用==v-html==指令

```html
<p>
    Usingmustaches: {{ rawHtml }}
</p>
<P>
    Using v-html directive: <span v-html="rawHtml"></span>
</P>
```

```html
data(){
	return{
		rawHtml:"<a href=''https://www.itbaizhan.com''>百战</a>"
	}
}
```

#### 属性Attribute

Mustache语法不能在HTML属性中使用，然而，可以使用==v-bind==指令

```html
<div v-bind:id=”dynamicId“> </div>
```

```html
data(){
	return{
		dynamicId:1001
	}
}
```

#### 使用JavaScript表达式

在我们模板中，我们一直都只绑定简单的property键值，Vue.js都提供了完全的JavaScript表达式支持

```html
{{ number + 1 }}

{{ ok ? ''YES'' : ''NO'' }}

{{ message.split('''').reverse().join('''') }}
```

这些表达式在当前活动实例的数据作用域下作为JavaScript被解析。有个限制就是，每个绑定都只能包含*单个表达式*，所以下面的例子都*不会*生效。

```html
<!-- 这是语句，不是表达式 -->
{{ var a = 1 }}

<!-- 流程控制也不会生效，请使用三元表达式-->
{{ if(ok) { return message } }}
```', '{"source": "Invalid source URI: Byte array resource [resource loaded from byte array] cannot be resolved to URL", "content_id": "2ec9d61b9ac293456d06d2d32fc0a230", "document_id": 165, "content_type": "article", "knowledge_base_id": "79a0baee5adbf82a7b29fb79f32ac551"}', '[-0.069744,-0.015919827,-0.011481859,-0.040841937,-0.036704045,-0.015074875,-0.0072176196,0.13595027,-0.074987434,0.06923861,0.031207914,0.016598945,0.0050697066,0.01116599,-0.034935176,0.00085482205,-0.0050697066,-0.09040187,-0.019173283,-0.010234174,0.03641976,0.00088394125,0.044442847,0.0015438126,-0.070817955,-0.01802036,0.008417924,0.042294934,0.04918089,0.032945197,0.0026848915,0.013242831,0.041694783,-0.016006691,0.033513762,0.031950206,-0.011023848,0.036672458,-0.048643913,-0.024369337,-0.006945182,0.023453316,-0.015872447,-0.012003044,0.0072571035,0.040968284,0.017815044,-0.009254978,-0.018967967,0.035345804,0.011505549,-0.047696304,-0.02424299,0.02124223,0.010139413,0.02007351,0.02797025,0.012745338,-0.009720886,-0.023090066,0.0020827649,-0.0047893724,0.020405175,-0.01997875,0.04232652,-0.03136585,-0.013179658,0.006475326,-0.01629887,-0.035535328,0.010210484,0.001987017,0.022868957,-0.033671696,-0.043653175,0.07277635,-0.060046807,0.027401686,-0.014759006,-0.00728869,-0.018762652,0.053855762,0.0069056987,-0.00075907406,0.00503812,-0.0013009878,0.028049218,-0.04298985,0.04485348,0.03433502,-0.005097345,-0.01416675,0.044379674,-0.006033109,-0.047412023,0.033387415,-0.025917098,0.025585435,-0.012382087,-0.02515901,-0.03664087,0.043210957,0.011047538,-0.056856524,0.027654381,0.038441326,-0.024922108,0.024622032,-0.038283393,-0.012453157,-0.0074584703,-0.027054228,-0.002147913,0.037241023,-0.008789071,0.056193195,0.019504946,0.002124223,0.009657712,0.0060094185,0.001409568,0.03945211,-0.022963718,-0.017862424,-0.0040214146,-0.004765682,-0.036009133,-0.007975707,0.062226307,-0.023437522,-0.009310256,-0.01707275,0.041126218,-0.08174705,0.014877457,0.034177087,-0.0013286264,-0.019031141,-0.04362159,-0.009926201,0.0070636333,-0.03455613,0.07397665,0.045200936,0.010139413,-0.017830838,-0.02310586,-0.033576936,0.02628035,-0.02787549,-0.0015280191,0.044348087,-0.029675946,0.04545363,-0.046148546,-0.009460294,0.020721044,-0.052813392,0.0020748682,-0.059730936,-0.031523783,0.024843141,-0.05047596,-0.018873207,-0.015793478,-0.0074347802,-0.025174804,-0.018715272,0.026138207,0.019410186,-0.02523798,0.03433502,-0.011079125,-0.054234806,0.033987567,-0.021795,0.034303434,0.03604072,0.05022326,-0.042705566,0.041600022,0.014182543,0.024448305,-0.0015566447,0.012903272,-0.0011173886,0.04962311,0.019410186,-0.004070769,0.033892807,0.0057527744,0.08193657,-0.005286867,0.049654696,-0.016677914,-0.00082520925,-0.032376632,0.042105414,0.063616134,0.023358556,-0.023374349,-0.04908613,-0.040526066,0.020041924,0.019031141,-0.0025763111,-0.004295826,-0.03499835,-0.02433775,-0.0051723644,0.051391978,-0.0045011416,-0.014332582,-0.025774958,-0.036356587,-0.010636908,-0.031887032,-0.0069807176,0.0029652256,0.009223391,-0.038283393,0.03913624,-0.011947767,0.028112391,-0.006155508,-0.025980271,0.015177533,-0.015753996,0.0031113152,0.018667892,0.0054605952,0.050886586,0.018857414,0.02646987,0.036704045,-0.017467588,-0.04030496,0.0013750198,0.038030695,-0.02792287,0.024669414,0.03964163,-0.039420523,0.0021281713,-0.0075611277,0.014901147,0.00037929026,-0.038694024,0.013590288,-0.009626125,-0.027954457,-0.021258023,-0.03215552,-0.03446137,-0.009657712,0.02174762,0.016014587,0.013021723,0.06453215,-0.0083784405,-0.021400163,0.029565392,0.016038278,0.010242071,-0.05502448,-0.016804261,0.017104337,0.049370416,-0.0077506495,0.10177317,-0.017420206,0.0036167067,0.011126505,-0.01779925,0.04172637,-0.015359158,-0.0035081264,0.020689458,0.013653462,0.017830838,0.02729113,0.0021202746,0.03935735,0.0074071414,0.04804376,0.0054408535,0.03206076,0.047791068,-0.024669414,0.007837513,0.017957184,0.046527587,0.04412698,0.066458955,0.013542908,0.0013592263,0.044885065,0.00087653805,0.0079836035,0.019441772,-0.04463237,-0.004911772,-0.027986044,-0.0009406991,0.009357636,-0.0061594564,-0.037525304,-0.08458987,0.03891513,-0.013535012,-0.03613548,0.0045445734,-0.028349293,-0.010613218,0.0065385,-0.04349524,-0.037146263,-0.0018083534,-0.0085521685,-0.0019189076,0.054424327,-0.0068859565,-0.01126075,0.0011312079,-0.01375612,-0.01639363,0.029296903,-0.007644044,-0.019489152,0.008220506,-0.029518012,0.04813852,-0.011150196,-0.018241467,0.018967967,-0.027796522,-0.050254848,0.008003346,0.034113914,-0.0061357664,0.04049448,0.002436144,0.03954687,0.029091587,0.030813077,0.044569198,-0.047222503,0.032755673,-0.01053425,0.006664848,0.030355066,0.02201611,0.028491436,0.019268043,0.029596979,0.03683039,0.050949764,0.011331821,0.00086814776,0.023358556,-0.046780284,0.0082047125,-0.0210685,0.059415065,-0.0015675027,-0.023532283,0.005381628,0.032882024,-0.032850437,0.021258023,-0.02002613,-0.019552326,0.08370543,0.021463336,0.017451793,0.034840412,0.018178293,-0.020768424,-0.051107697,0.02201611,-0.0038180735,0.034745652,-0.0005572137,-0.020278826,0.021984521,0.003950344,0.034524545,0.025553849,-0.0074742637,-0.03119212,0.053761,0.05249752,0.002850723,-0.029044207,0.0028053166,-0.018051947,-0.00578831,-0.008883832,0.03727261,0.009483984,-0.0074821603,-0.012003044,0.013787706,-0.020578902,0.0049709976,-0.021368576,0.036988325,0.046559174,0.029691739,0.03799911,-0.02515901,-0.016551565,0.014419446,0.030860458,-0.05856222,-0.016488392,-0.018746858,-0.013171761,-0.026801534,0.060141567,-0.04621172,-0.0019208818,-0.019410186,0.010297348,-0.050823413,0.10133096,-0.014545794,0.017451793,0.008109951,0.027638588,0.014664245,-0.027338512,0.013108587,0.010739566,0.011955664,-0.0049512554,0.015359158,0.008386337,-0.050160088,0.000987586,-0.03345059,0.018225674,-0.033419,0.020831598,0.011300234,0.024179816,0.026311936,-0.03213973,0.03591437,0.010463179,0.0062107854,0.035061523,0.03683039,0.014048299,-0.0022801834,0.038946718,0.009333946,-0.08932792,-0.03291361,-0.01929963,0.030449826,0.00054931693,0.025032664,0.029897055,0.020705251,0.049402002,0.012366294,0.015801376,0.00455247,-0.04908613,-0.0126979565,0.053824175,0.001603038,-0.030749902,-0.0065937773,-0.014988011,-0.021605479,0.0018675788,0.0015112385,0.07012305,-0.012468952,0.030434033,-0.003417314,-0.006396359,-0.06746974,-0.088696174,-0.011900386,0.039483696,0.011916179,-0.017530762,-0.03591437,-0.009570848,0.015374951,0.021368576,-0.0074584703,0.03550374,0.007837513,-0.05117087,0.009539261,-0.01053425,-0.023453316,0.00862324,-0.016014587,-0.002925742,-0.03037086,0.0019189076,-0.03569326,-0.003589068,0.020184066,0.017736077,-0.029028414,0.05344513,0.014932734,-0.04586426,-0.00023788927,-0.024274576,0.047980588,0.04134733,0.00903387,-0.0055711498,0.055371936,-0.004572212,0.05793048,-0.04144209,-0.025838131,-0.016535772,-0.030212924,-0.040715586,0.023595456,-0.042958263,-0.007122859,0.022789989,0.027006848,-0.0058159484,-0.0044340193,0.055972088,0.037841175,-0.010565837,0.021005327,0.051960543,-0.005318454,0.00065493584,-0.00039755146,0.035788022,0.010865914,0.036451347,0.00067961315,-0.038883545,-0.00656219,0.005353989,0.037588477,0.016472599,0.0075571793,-0.00059867156,-0.055908915,-0.009412914,0.0054526986,0.025948685,-0.013977229,-0.045516804,0.017436,-0.020942153,-0.024179816,-0.042737152,-0.02533274,-0.01581717,0.026975261,0.045390457,0.057488263,0.015011702,0.00903387,-0.0036858032,-0.04681187,-0.012484745,-0.009547158,-0.012784821,-0.012484745,0.029802294,0.060046807,0.0029356128,0.010802739,-0.011039642,-0.05151833,0.01825726,-0.000523159,0.04463237,0.017562348,-0.050002154,0.04450602,-0.028917858,0.016804261,0.0010946855,-0.06228948,-0.0074308314,-0.012366294,0.055687804,0.052276414,0.010565837,0.028159773,0.017562348,-0.021652859,-0.030339273,0.022221424,0.0030303737,0.0019129851,-0.04232652,0.03768324,0.00047183016,0.008710103,0.0008454446,-0.0082047125,0.041979067,-0.068354174,0.006953079,-0.028886272,0.017972978,0.0043432065,-0.029249523,0.06336343,-0.011481859,-0.021463336,-0.02242674,0.03455613,-0.0009964698,0.00031710343,0.030307686,-0.016330456,-0.034872,-0.043021437,0.019915577,0.027496446,0.03528263,-0.018004566,0.030560382,0.021905554,0.0024381182,-0.02523798,0.012066218,0.0057290844,-0.02242674,0.008362647,0.0079915,0.00027046332,-0.033482175,0.01779925,0.024464099,-0.021889761,-0.04349524,-0.049654696,0.038630847,0.016851641,0.0030935477,-0.041378915,-0.080167696,0.053950522,-0.03537739,0.007908585,-0.04848598,0.013258625,-0.03613548,-0.012705853,-0.06633261,-0.068543695,0.013511321,-0.047159325,-0.029044207,-0.0064911195,-0.015153843,0.03082887,0.014300995,-0.04109463,-0.047159325,0.014995907,0.014198338,0.0025980272,0.012516332,-0.038788784,-0.033987567,0.06481644,0.03032348,0.02646987,-0.0015092643,0.0046985596,-0.024937904,-0.031334262,-0.02012089,-0.0138587775,-0.031065773,-0.083958134,0.007679579,-0.020784218,0.016883228,0.010107826,-0.021179054,0.06469009,-0.023326967,-0.07801978,-0.01554868,0.0018892948,0.035029937,0.013574495,-0.016014587,-0.11004896,-0.01518543,0.05603526,-0.004185272,-0.032013383,-0.02138437,0.037493717,-0.05265546,-0.01595931,0.04017861,-0.009539261,-0.01048687,0.011655587,0.03215552,0.02515901,0.0056422204,-0.03686198,-0.0037509513,0.00011129467,0.011560827,0,-0.02860199,-0.09949891,0.020215653,0.049496762,-0.005776465,0.00083606725,0.006194992,-0.038472913,-0.01271375,0.03550374,-0.026722565,-0.03458772,0.0045959023,-0.03913624,-0.037304197,-0.05802524,-0.020342,-0.024985284,-0.019757641,-0.0011312079,-0.058277935,0.102215394,0.01847837,-0.014135163,-0.019678675,-0.0530345,0.024006087,0.05249752,-0.041126218,-0.03654611,0.0063687204,0.009863027,-0.024100848,0.03572485,-0.012192565,-0.020041924,-0.023990294,-0.034903586,-0.025443293,-0.046116956,0.01586455,-0.029944435,0.029675946,0.008196815,-0.0057093427,-0.04024178,0.0061239214,-0.015485506,0.017767664,0.03569326,0.008512685,0.005630375,0.030813077,0.0015645415,0.015359158,-0.018904794,-0.018036153,-0.003046167,0.027227957,-0.059288718,-0.037588477,0.016835848,0.031002598,-0.00022431675,0.040431306,-0.03232925,-0.004220807,-0.0037233126,-0.028791511,0.01201094,0.03528263,0.018857414,-0.0015783608,-0.02225301,-0.025774958,0.07126018,-0.02220563,-0.008433717,0.0119319735,-0.01300593,-0.01620411,-0.005969935,-0.05613002,-0.018178293,-0.031160533,-0.01838361,0.013637668,-0.05998363,-0.048517566,0.003150799,0.022537295,0.034398198,-0.01925225,-0.03755689,0.0028467744,-0.020105097,0.005519821,-0.016677914,0.032660913,0.033861216,-0.02329538,0.005685652,0.034177087,0.019268043,-0.0011381175,0.050412785,0.04763313,-0.02741748,0.007873049,-0.013566598,0.004860443,-0.019046934,0.031934414,-0.03499835,0.010786946,0.009199701,0.016788468,-0.015430229,-0.030686729,-0.008781174,0.0030895993,0.006471378,0.0317291,-0.041378915,0.0032119986,0.0043432065,0.0052947635,-0.061468218,0.009452397,-0.03673563,-0.004323465,0.034366608,0.0109211905,0.034745652,0.051928956,0.008283679,-0.0040865624,0.0049512554,-0.04621172,-0.006964924,-0.017404413,0.0050894483,-0.044095393,0.020784218,-0.010550044,0.018494163,0.0167095,-0.027733348,0.013448147,0.0041023563,0.04134733,-0.009318152,-0.013471837,-0.050728653,0.0056145815,0.035219457,0.02406926,-0.006384514,0.018178293,-0.013392869,-0.0047025084,0.04630648,-0.0037154157,0.040462893,0.0070280978,-0.0057962066,-0.0051842094,0.015722407,0.06980717,-0.04039972,0.020468349,-0.016962197,-0.02116326,-0.016330456,0.026043447,-0.015951414,-0.008796968,0.0115134455,0.020594696,0.023942914,0.017657109,-0.010407902,-0.008765381,-0.0025091888,-0.00027959392,-0.040652413,0.015303881,-0.026122414,0.005429008,0.012097805,-0.052181654,0.02419561,0.024527272,0.012705853,0.000539446,-0.026454076,0.008054674,0.02538012,-0.045390457,0.06576405,0.015193326,0.040210195,-0.03882037,0.0022782092,0.01820988,-0.04381111,-0.088633,0.0101315165,-0.0103526255,-0.01825726,0.07549283,0.047949,0.016504185,0.0070675816,-0.021368576,-0.028949447,-0.017672902,-0.03736737,0.013637668,0.039483696,-0.020531522,0.04030496,0.05875174,0.0029711481,-0.002487473,0.015351261,-0.05935189,-0.03695674,-0.0038615055,0.026311936,0.024685208,0.039610043,0.0073123807,0.0029869417,-0.008109951,-0.024053467,-0.051960543,-0.0058080517,0.0025388016,-0.008228403,-0.039167825,-0.023026891,0.0001412776,0.0023808668,0.033861216,-0.012634783,-0.0118845925,-0.04889661,-0.011466065,0.0074229348,-0.024511479,-0.014435239,0.090275526,-0.033671696,-0.0059462446,0.028838892,-0.039989088,0.016583152,0.02174762,0.027575413,0.036198653,-0.033608522,-0.009215495,0.00352392,-0.026975261,-0.06671166,0.0042879293,0.0077782883,0.0034489008,0.033798043,0.0385045,0.062636934,0.006676693,-0.01520912,-0.00095747964,0.010092033,0.05306609,0.059952043,0.018320436,0.020326206,-0.03695674,0.061562978,0.03528263,0.0058593806,0.000891838,-0.003117238,-0.028159773,0.029249523,0.01409568,-0.0027599104,-0.018415196,0.034808826,-0.033387415,-0.052181654,0.017625522,-0.031997588,0.0067477636,-0.034177087,-0.0024539118,-0.08421083,0.018194087]');

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
ALTER SEQUENCE "public"."content_tag_id_seq"
OWNED BY "public"."content_tag"."id";
SELECT setval('"public"."content_tag_id_seq"', 9, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."content_tag_relation_id_seq"
OWNED BY "public"."content_tag_relation"."id";
SELECT setval('"public"."content_tag_relation_id_seq"', 34, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."document_entity_id_seq"
OWNED BY "public"."document_entity"."id";
SELECT setval('"public"."document_entity_id_seq"', 165, true);

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
SELECT setval('"public"."system_user_role_id_seq"', 1, true);

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
-- Indexes structure for table comment
-- ----------------------------
CREATE INDEX "idx_comment_content" ON "public"."comment" USING btree (
  "content_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "content_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_comment_parent" ON "public"."comment" USING btree (
  "parent_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table comment
-- ----------------------------
CREATE TRIGGER "update_comment_updated_at" BEFORE UPDATE ON "public"."comment"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table comment
-- ----------------------------
ALTER TABLE "public"."comment" ADD CONSTRAINT "comment_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table content
-- ----------------------------
CREATE INDEX "idx_content_category" ON "public"."content" USING btree (
  "category" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_content_is_recommend" ON "public"."content" USING btree (
  "is_recommend" "pg_catalog"."bool_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table content
-- ----------------------------
CREATE TRIGGER "update_content_updated_at" BEFORE UPDATE ON "public"."content"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table content
-- ----------------------------
ALTER TABLE "public"."content" ADD CONSTRAINT "content_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table content_tag
-- ----------------------------
CREATE INDEX "idx_content_tag_name" ON "public"."content_tag" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_content_tag_usage_count" ON "public"."content_tag" USING btree (
  "usage_count" "pg_catalog"."int8_ops" DESC NULLS FIRST
);

-- ----------------------------
-- Uniques structure for table content_tag
-- ----------------------------
ALTER TABLE "public"."content_tag" ADD CONSTRAINT "content_tag_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table content_tag
-- ----------------------------
ALTER TABLE "public"."content_tag" ADD CONSTRAINT "content_tag_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table content_tag_relation
-- ----------------------------
CREATE INDEX "idx_content_tag_relation_content_id" ON "public"."content_tag_relation" USING btree (
  "content_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_content_tag_relation_tag_id" ON "public"."content_tag_relation" USING btree (
  "tag_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table content_tag_relation
-- ----------------------------
ALTER TABLE "public"."content_tag_relation" ADD CONSTRAINT "uk_content_tag" UNIQUE ("content_id", "tag_id");

-- ----------------------------
-- Primary Key structure for table content_tag_relation
-- ----------------------------
ALTER TABLE "public"."content_tag_relation" ADD CONSTRAINT "content_tag_relation_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table diary
-- ----------------------------
ALTER TABLE "public"."diary" ADD CONSTRAINT "diary_pkey" PRIMARY KEY ("id");

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
-- Indexes structure for table murmur
-- ----------------------------
CREATE INDEX "idx_murmur_create_time" ON "public"."murmur" USING btree (
  "create_time" "pg_catalog"."timestamp_ops" DESC NULLS FIRST
);

-- ----------------------------
-- Triggers structure for table murmur
-- ----------------------------
CREATE TRIGGER "update_murmur_updated_at" BEFORE UPDATE ON "public"."murmur"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table murmur
-- ----------------------------
ALTER TABLE "public"."murmur" ADD CONSTRAINT "murmur_pkey" PRIMARY KEY ("id");

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
-- Indexes structure for table photo
-- ----------------------------
CREATE INDEX "idx_photo_create_time" ON "public"."photo" USING btree (
  "create_time" "pg_catalog"."timestamp_ops" DESC NULLS FIRST
);

-- ----------------------------
-- Triggers structure for table photo
-- ----------------------------
CREATE TRIGGER "update_photo_updated_at" BEFORE UPDATE ON "public"."photo"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table photo
-- ----------------------------
ALTER TABLE "public"."photo" ADD CONSTRAINT "photo_pkey" PRIMARY KEY ("id");

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
-- Primary Key structure for table user_profile
-- ----------------------------
ALTER TABLE "public"."user_profile" ADD CONSTRAINT "user_profile_pkey" PRIMARY KEY ("id");

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
-- Foreign Keys structure for table content_tag_relation
-- ----------------------------
ALTER TABLE "public"."content_tag_relation" ADD CONSTRAINT "fk_content" FOREIGN KEY ("content_id") REFERENCES "public"."content" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."content_tag_relation" ADD CONSTRAINT "fk_tag" FOREIGN KEY ("tag_id") REFERENCES "public"."content_tag" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

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
