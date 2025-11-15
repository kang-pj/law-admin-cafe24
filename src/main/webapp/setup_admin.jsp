<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%
    Connection conn = null;
    Statement stmt = null;
    
    try {
        conn = DBConnection.getConnection();
        stmt = conn.createStatement();
        
        // admins 테이블 삭제 후 재생성
        try {
            stmt.execute("DROP TABLE IF EXISTS admins");
        } catch(Exception e) {}
        
        // admins 테이블 생성
        stmt.execute(
            "CREATE TABLE admins (" +
            "id INT PRIMARY KEY AUTO_INCREMENT, " +
            "username VARCHAR(50) UNIQUE NOT NULL, " +
            "password VARCHAR(255) NOT NULL, " +
            "name VARCHAR(50) NOT NULL, " +
            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
        );
        
        // 관리자 계정 추가 (비밀번호: admin1234)
        stmt.execute(
            "INSERT INTO admins (username, password, name) " +
            "VALUES ('admin', 'admin1234', '최고관리자')"
        );
        
        out.println("✓ admins 테이블 생성 완료<br>");
        out.println("✓ 관리자 계정 생성 완료<br>");
        out.println("<br>계정: admin / admin1234");
        
    } catch(Exception e) {
        out.println("오류: " + e.getMessage());
        e.printStackTrace();
    } finally {
        DBConnection.close(stmt, conn);
    }
%>
