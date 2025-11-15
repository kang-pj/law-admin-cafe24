package dao;

import model.Admin;
import util.DBConnection;
import java.sql.*;

public class AdminDAO {
    
    public Admin login(String id, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, name, role, company_id FROM admins WHERE id = ? AND password = ? AND is_active = 'Y'";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setEmail(rs.getString("id"));
                admin.setName(rs.getString("name"));
                admin.setRole(rs.getString("role"));
                admin.setCompanyId(rs.getString("company_id"));
                
                // last_login 업데이트
                updateLastLogin(conn, id);
                
                return admin;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, pstmt, conn);
        }
        
        return null;
    }
    
    private void updateLastLogin(Connection conn, String id) {
        PreparedStatement pstmt = null;
        try {
            String sql = "UPDATE admins SET last_login = NOW() WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt);
        }
    }
}
