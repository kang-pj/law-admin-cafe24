package util;

import java.sql.Connection;
import java.sql.Statement;

public class CreateMemoTable {
    
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("메모 테이블 생성 시작...");
            
            String sql = "CREATE TABLE IF NOT EXISTS inquiry_memos (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "inquiry_id INT NOT NULL, " +
                        "admin_id VARCHAR(100) NOT NULL, " +
                        "admin_name VARCHAR(100) NOT NULL, " +
                        "content TEXT NOT NULL, " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "FOREIGN KEY (inquiry_id) REFERENCES inquiries(id) ON DELETE CASCADE" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
            
            stmt.executeUpdate(sql);
            System.out.println("inquiry_memos 테이블 생성 완료");
            
            // 인덱스 추가
            try {
                stmt.executeUpdate("CREATE INDEX idx_inquiry_id ON inquiry_memos(inquiry_id)");
                System.out.println("idx_inquiry_id 인덱스 생성 완료");
            } catch (Exception e) {
                System.out.println("idx_inquiry_id 인덱스는 이미 존재합니다.");
            }
            
            try {
                stmt.executeUpdate("CREATE INDEX idx_created_at ON inquiry_memos(created_at)");
                System.out.println("idx_created_at 인덱스 생성 완료");
            } catch (Exception e) {
                System.out.println("idx_created_at 인덱스는 이미 존재합니다.");
            }
            
            System.out.println("메모 테이블 생성 완료!");
            
        } catch (Exception e) {
            System.err.println("오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
