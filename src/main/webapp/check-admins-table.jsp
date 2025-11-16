<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admins 테이블 구조 확인</title>
</head>
<body>
    <h2>Admins 테이블 구조</h2>
    <%
    try (Connection conn = DBConnection.getConnection()) {
        DatabaseMetaData metaData = conn.getMetaData();
        ResultSet columns = metaData.getColumns(null, null, "admins", null);
        
        out.println("<table border='1'>");
        out.println("<tr><th>컬럼명</th><th>타입</th><th>크기</th><th>NULL 허용</th></tr>");
        
        while (columns.next()) {
            String columnName = columns.getString("COLUMN_NAME");
            String columnType = columns.getString("TYPE_NAME");
            int columnSize = columns.getInt("COLUMN_SIZE");
            String isNullable = columns.getString("IS_NULLABLE");
            
            out.println("<tr>");
            out.println("<td>" + columnName + "</td>");
            out.println("<td>" + columnType + "</td>");
            out.println("<td>" + columnSize + "</td>");
            out.println("<td>" + isNullable + "</td>");
            out.println("</tr>");
        }
        
        out.println("</table>");
        
        out.println("<h3>샘플 데이터</h3>");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM admins LIMIT 3");
        ResultSetMetaData rsmd = rs.getMetaData();
        int columnCount = rsmd.getColumnCount();
        
        out.println("<table border='1'>");
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
        
    } catch (Exception e) {
        out.println("<p style='color:red'>오류: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
    %>
</body>
</html>
