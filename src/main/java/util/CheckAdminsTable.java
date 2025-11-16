package util;

import java.sql.*;

public class CheckAdminsTable {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("=== Admins 테이블 구조 ===");
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet columns = metaData.getColumns(null, null, "admins", null);
            
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String columnType = columns.getString("TYPE_NAME");
                int columnSize = columns.getInt("COLUMN_SIZE");
                System.out.println(columnName + " - " + columnType + "(" + columnSize + ")");
            }
            
            System.out.println("\n=== 샘플 데이터 (첫 1개) ===");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM admins LIMIT 1");
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();
            
            if (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    System.out.println(rsmd.getColumnName(i) + ": " + rs.getString(i));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
