-- 为 system_user 表添加头像字段
ALTER TABLE system_user ADD COLUMN IF NOT EXISTS avatar VARCHAR(500);

-- 为现有用户添加默认头像（MinIO 中的头像 URL）
-- 假设你已经将 YoyuEN.png 上传到 MinIO 的 default bucket
UPDATE system_user
SET avatar = 'http://118.89.135.164:9000/default/avatars/YoyuEN.png'
WHERE username = 'YoyuEN';

-- 为 admin 用户设置默认头像
UPDATE system_user
SET avatar = 'http://118.89.135.164:9000/default/avatars/default-avatar.png'
WHERE username = 'admin';

-- 查看更新结果
SELECT id, username, avatar FROM system_user;
