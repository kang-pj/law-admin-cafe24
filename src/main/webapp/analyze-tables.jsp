<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>테이블 구조 분석</title>
    <style>
        body { font-family: monospace; padding: 20px; background: #f5f5f5; }
        .table-info { background: white; padding: 20px; margin: 20px 0; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #0d6efd; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #0d6efd; color: white; }
        .sample-data { background: #f8f9fa; padding: 10px; margin: 10px 0; border-left: 4px solid #0d6efd; }
    </style>
</head>
<body>
    <h1>📊 테이블 구조 분석</h1>
    
    <%
    try (Connection conn = DBConnection.getConnection()) {
        DatabaseMetaData metaData = conn.getMetaData();
        
        // 1. access_logs 테이블 분석
        out.println("<div class='table-info'>");
        out.println("<h2>1. access_logs (접속 통계)</h2>");
        
        ResultSet columns = metaData.getColumns(null, null, "access_logs", null);
        out.println("<table>");
        out.println("<tr><th>컬럼명</th><th>타입</th><th>NULL 허용</th><th>기본값</th><th>설명</th></tr>");
        while (columns.next()) {
            String columnName = columns.getString("COLUMN_NAME");
            String columnType = columns.getString("TYPE_NAME");
            int columnSize = columns.getInt("COLUMN_SIZE");
            String isNullable = columns.getString("IS_NULLABLE");
            String columnDef = columns.getString("COLUMN_DEF");
            
            out.println("<tr>");
            out.println("<td><strong>" + columnName + "</strong></td>");
            out.println("<td>" + columnType + "(" + columnSize + ")</td>");
            out.println("<td>" + isNullable + "</td>");
            out.println("<td>" + (columnDef != null ? columnDef : "-") + "</td>");
            out.println("<td>-</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        
        // 샘플 데이터
        out.println("<div class='sample-data'>");
        out.println("<strong>샘플 데이터 (최근 5건):</strong><br>");
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM access_logs ORDER BY created_at DESC LIMIT 5")) {
            
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();
            
            out.println("<table>");
            out.println("<tr>");
            for (int i = 1; i <= columnCount; i++) {
                out.println("<th>" + rsmd.getColumnName(i) + "</th>");
            }
            out.println("</tr>");
            
            while (rs.next()) {
                out.println("<tr>");
                for (int i = 1; i <= columnCount; i++) {
                    out.println("<td>" + rs.getString(i) + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
        }
        out.println("</div>");
        
        // 통계
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM access_logs")) {
            if (rs.next()) {
                out.println("<p>총 레코드 수: <strong>" + rs.getInt("total") + "</strong></p>");
            }
        }
        out.println("</div>");
        
        // 2. consultation_leads 테이블 분석
        out.println("<div class='table-info'>");
        out.println("<h2>2. consultation_leads (접수 통계)</h2>");
        
        columns = metaData.getColumns(null, null, "consultation_leads", null);
        out.println("<table>");
        out.println("<tr><th>컬럼명</th><th>타입</th><th>NULL 허용</th><th>기본값</th><th>설명</th></tr>");
        while (columns.next()) {
            String columnName = columns.getString("COLUMN_NAME");
            String columnType = columns.getString("TYPE_NAME");
            int columnSize = columns.getInt("COLUMN_SIZE");
            String isNullable = columns.getString("IS_NULLABLE");
            String columnDef = columns.getString("COLUMN_DEF");
            
            out.println("<tr>");
            out.println("<td><strong>" + columnName + "</strong></td>");
            out.println("<td>" + columnType + "(" + columnSize + ")</td>");
            out.println("<td>" + isNullable + "</td>");
            out.println("<td>" + (columnDef != null ? columnDef : "-") + "</td>");
            out.println("<td>-</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        
        // 샘플 데이터
        out.println("<div class='sample-data'>");
        out.println("<strong>샘플 데이터 (최근 5건):</strong><br>");
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM consultation_leads ORDER BY created_at DESC LIMIT 5")) {
            
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();
            
            out.println("<table>");
            out.println("<tr>");
            for (int i = 1; i <= columnCount; i++) {
                out.println("<th>" + rsmd.getColumnName(i) + "</th>");
            }
            out.println("</tr>");
            
            while (rs.next()) {
                out.println("<tr>");
                for (int i = 1; i <= columnCount; i++) {
                    out.println("<td>" + rs.getString(i) + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
        }
        out.println("</div>");
        
        // 통계
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM consultation_leads")) {
            if (rs.next()) {
                out.println("<p>총 레코드 수: <strong>" + rs.getInt("total") + "</strong></p>");
            }
        }
        out.println("</div>");
        
        // 3. 연관 분석
        out.println("<div class='table-info'>");
        out.println("<h2>3. 연관 분석 가능성</h2>");
        out.println("<ul>");
        out.println("<li><strong>company_id</strong>: 두 테이블 모두 업체별 필터링 가능</li>");
        out.println("<li><strong>created_at</strong>: 시간대별 분석 가능</li>");
        out.println("<li><strong>전환율 계산</strong>: 접속 수 대비 접수 수 비율</li>");
        out.println("<li><strong>유입 경로 분석</strong>: access_logs의 referrer와 consultation_leads의 source 연관</li>");
        out.println("</ul>");
        out.println("</div>");
        
    } catch (Exception e) {
        out.println("<div style='color: red;'>");
        out.println("<h3>오류 발생:</h3>");
        out.println("<pre>" + e.getMessage() + "</pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</div>");
    }
    %>
</body>
</html>
