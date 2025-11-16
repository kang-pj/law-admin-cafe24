package util;

import java.sql.Connection;
import java.sql.Statement;

public class AlterCompaniesTable {
    
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("companies 테이블에 schedule_json 컬럼 추가 중...");
            
            // schedule_json 컬럼 추가
            stmt.executeUpdate(
                "ALTER TABLE companies ADD COLUMN IF NOT EXISTS schedule_json TEXT COMMENT '요일별 운영시간 JSON'"
            );
            
            System.out.println("✓ schedule_json 컬럼 추가 완료");
            
            // 기존 데이터 마이그레이션
            System.out.println("\n기존 데이터 마이그레이션 중...");
            
            stmt.executeUpdate(
                "UPDATE companies " +
                "SET schedule_json = CONCAT(" +
                "  '{', " +
                "  '\"mon\":{\"enabled\":true,\"start\":\"', TIME_FORMAT(weekday_start, '%H:%i'), '\",\"end\":\"', TIME_FORMAT(weekday_end, '%H:%i'), '\"},', " +
                "  '\"tue\":{\"enabled\":true,\"start\":\"', TIME_FORMAT(weekday_start, '%H:%i'), '\",\"end\":\"', TIME_FORMAT(weekday_end, '%H:%i'), '\"},', " +
                "  '\"wed\":{\"enabled\":true,\"start\":\"', TIME_FORMAT(weekday_start, '%H:%i'), '\",\"end\":\"', TIME_FORMAT(weekday_end, '%H:%i'), '\"},', " +
                "  '\"thu\":{\"enabled\":true,\"start\":\"', TIME_FORMAT(weekday_start, '%H:%i'), '\",\"end\":\"', TIME_FORMAT(weekday_end, '%H:%i'), '\"},', " +
                "  '\"fri\":{\"enabled\":true,\"start\":\"', TIME_FORMAT(weekday_start, '%H:%i'), '\",\"end\":\"', TIME_FORMAT(weekday_end, '%H:%i'), '\"},', " +
                "  '\"sat\":{\"enabled\":true,\"start\":\"', TIME_FORMAT(weekend_start, '%H:%i'), '\",\"end\":\"', TIME_FORMAT(weekend_end, '%H:%i'), '\"},', " +
                "  '\"sun\":{\"enabled\":true,\"start\":\"', TIME_FORMAT(weekend_start, '%H:%i'), '\",\"end\":\"', TIME_FORMAT(weekend_end, '%H:%i'), '\"}', " +
                "  '}' " +
                ") " +
                "WHERE schedule_json IS NULL"
            );
            
            System.out.println("✓ 기존 데이터 마이그레이션 완료");
            
            // 결과 확인
            System.out.println("\n현재 데이터 확인:");
            var rs = stmt.executeQuery("SELECT id, name, schedule_json FROM companies");
            while (rs.next()) {
                System.out.println("ID: " + rs.getString("id") + 
                                 ", Name: " + rs.getString("name") + 
                                 ", Schedule: " + rs.getString("schedule_json"));
            }
            
            System.out.println("\n✓ 모든 작업 완료!");
            
        } catch (Exception e) {
            System.err.println("오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
