-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Add third-party authentication support (Sign in with Apple / Google)

-- Add provider columns to users table
ALTER TABLE users
    ADD COLUMN apple_id VARCHAR(255) NULL UNIQUE AFTER id,
    ADD COLUMN google_id VARCHAR(255) NULL UNIQUE AFTER apple_id,
    ADD COLUMN auth_provider ENUM('apple', 'google') NOT NULL DEFAULT 'apple' AFTER google_id;

-- Make password_hash nullable (third-party auth users have no password)
ALTER TABLE users
    MODIFY COLUMN password_hash VARCHAR(255) NULL;

-- Make email nullable (Apple users may hide their email)
ALTER TABLE users
    MODIFY COLUMN email VARCHAR(255) NULL,
    DROP INDEX email,
    ADD UNIQUE INDEX idx_email (email);

-- Add indexes for provider lookups
ALTER TABLE users
    ADD INDEX idx_apple_id (apple_id),
    ADD INDEX idx_google_id (google_id);
