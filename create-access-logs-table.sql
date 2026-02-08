-- 접속 로그 테이블 생성
CREATE TABLE IF NOT EXISTS access_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id VARCHAR(50) NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    request_uri VARCHAR(500),
    referer VARCHAR(500),
    session_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_company_id (company_id),
    INDEX idx_created_at (created_at),
    INDEX idx_company_created (company_id, created_at),
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
