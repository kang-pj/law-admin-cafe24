-- 문의 메모 테이블 생성
CREATE TABLE IF NOT EXISTS inquiry_memos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inquiry_id INT NOT NULL,
    admin_id VARCHAR(100) NOT NULL,
    admin_name VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (inquiry_id) REFERENCES inquiries(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 인덱스 추가
CREATE INDEX idx_inquiry_id ON inquiry_memos(inquiry_id);
CREATE INDEX idx_created_at ON inquiry_memos(created_at);
