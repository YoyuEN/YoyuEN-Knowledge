-- 初始化用户认证数据
-- 密码使用明文存储，密码为 123123

-- 1. 创建管理员用户（如果不存在）
INSERT INTO system_user (username, password, create_time, update_time, deleted)
VALUES ('admin', '123123', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false)
ON CONFLICT (username) DO NOTHING;

-- 2. 创建角色（如果表存在）
INSERT INTO system_role (name, description, create_time, update_time, deleted)
VALUES ('ADMIN', '管理员角色', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false)
ON CONFLICT DO NOTHING;

-- 3. 创建权限（如果表存在）
INSERT INTO system_permission (name, description, create_time, update_time, deleted)
VALUES
    ('ADMIN_ACCESS', '后台访问权限', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false),
    ('CONTENT_MANAGE', '内容管理权限', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false)
ON CONFLICT DO NOTHING;

-- 4. 关联用户和角色（如果表存在）
INSERT INTO system_user_role (user_id, role_id)
SELECT u.id, r.id
FROM system_user u, system_role r
WHERE u.username = 'admin' AND r.name = 'ADMIN'
ON CONFLICT DO NOTHING;

-- 5. 关联角色和权限（如果表存在）
INSERT INTO system_role_permission (role_id, permission_id)
SELECT r.id, p.id
FROM system_role r, system_permission p
WHERE r.name = 'ADMIN' AND p.name IN ('ADMIN_ACCESS', 'CONTENT_MANAGE')
ON CONFLICT DO NOTHING;

-- 查询验证
SELECT * FROM system_user WHERE username = 'admin';
