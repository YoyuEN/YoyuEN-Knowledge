-- PostgreSQL 版本：为 photo 表添加 thumbnail_name 字段
ALTER TABLE photo ADD COLUMN thumbnail_name VARCHAR(255);
COMMENT ON COLUMN photo.thumbnail_name IS '缩略图对象名称';

-- 对于已存在的照片，将 thumbnail_name 设置为 object_name（使用原图）
UPDATE photo SET thumbnail_name = object_name WHERE thumbnail_name IS NULL;
