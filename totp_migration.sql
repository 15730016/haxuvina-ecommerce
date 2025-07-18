-- SQL để thêm các trường TOTP vào bảng users
-- Chạy câu lệnh này trong phpMyAdmin

ALTER TABLE `users` 
ADD COLUMN `totp_secret` VARCHAR(255) NULL AFTER `verification_code`,
ADD COLUMN `totp_enabled` TINYINT(1) NOT NULL DEFAULT 0 AFTER `totp_secret`,
ADD COLUMN `totp_verified_at` TIMESTAMP NULL AFTER `totp_enabled`;

-- Kiểm tra kết quả
DESCRIBE `users`;
