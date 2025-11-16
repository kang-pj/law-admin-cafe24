package dao;

import model.Admin;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    private Connection conn;
    
    public AdminDAO(Connection conn) {
        this.conn = conn;
    }
    
    // 전체 관리자 목록 조회
    public List<Admin> getList() throws SQLException {
        List<Admin> list = new ArrayList<>();
        String sql = "SELECT * FROM admins ORDER BY created_at DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToAdmin(rs));
            }
        }
        return list;
    }
    
    // 업체별 관리자 목록 조회
    public List<Admin> getListByCompany(String companyId) throws SQLException {
        List<Admin> list = new ArrayList<>();
        String sql = "SELECT * FROM admins WHERE company_id = ? ORDER BY created_at DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAdmin(rs));
                }
            }
        }
        return list;
    }
    
    // 관리자 상세 조회 (id는 email 주소)
    public Admin getById(String id) throws SQLException {
        String sql = "SELECT * FROM admins WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAdmin(rs);
                }
            }
        }
        return null;
    }
    
    // 이메일로 관리자 조회 (id가 email 역할)
    public Admin getByEmail(String email) throws SQLException {
        return getById(email);
    }
    
    // 관리자 추가
    public void insert(Admin admin) throws SQLException {
        String sql = "INSERT INTO admins (id, password, name, role, is_active, company_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, admin.getEmail()); // id에 email 저장
            pstmt.setString(2, admin.getPassword());
            pstmt.setString(3, admin.getName());
            pstmt.setString(4, admin.getRole());
            pstmt.setString(5, admin.getIsActive());
            pstmt.setString(6, admin.getCompanyId());
            pstmt.executeUpdate();
        }
    }
    
    // 관리자 수정
    public void update(Admin admin) throws SQLException {
        String sql = "UPDATE admins SET name = ?, role = ?, " +
                    "is_active = ?, company_id = ? WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, admin.getName());
            pstmt.setString(2, admin.getRole());
            pstmt.setString(3, admin.getIsActive());
            pstmt.setString(4, admin.getCompanyId());
            pstmt.setString(5, admin.getEmail()); // id는 email
            pstmt.executeUpdate();
        }
    }
    
    // 비밀번호 변경
    public void updatePassword(String id, String newPassword) throws SQLException {
        String sql = "UPDATE admins SET password = ? WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newPassword);
            pstmt.setString(2, id);
            pstmt.executeUpdate();
        }
    }
    
    // 활성/비활성 토글
    public void toggleActive(String id) throws SQLException {
        String sql = "UPDATE admins SET is_active = IF(is_active = 'Y', 'N', 'Y') WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // 관리자 삭제
    public void delete(String id) throws SQLException {
        String sql = "DELETE FROM admins WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // 로그인 (이메일과 비밀번호로 인증)
    public Admin login(String loginId, String password) throws SQLException {
        // id 컬럼이 email 역할을 함
        String sql = "SELECT * FROM admins WHERE id = ? AND password = ? AND is_active = 'Y'";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, loginId);
            pstmt.setString(2, password);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAdmin(rs);
                }
            }
        }
        return null;
    }
    
    // ResultSet을 Admin 객체로 매핑
    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        String emailId = rs.getString("id"); // id 컬럼이 email 주소
        admin.setEmail(emailId);
        admin.setPassword(rs.getString("password"));
        admin.setName(rs.getString("name"));
        admin.setRole(rs.getString("role"));
        admin.setIsActive(rs.getString("is_active"));
        admin.setCompanyId(rs.getString("company_id"));
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        admin.setUpdatedAt(rs.getTimestamp("updated_at"));
        admin.setLastLogin(rs.getTimestamp("last_login"));
        return admin;
    }
}
