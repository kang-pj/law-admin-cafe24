package dao;

import model.Inquiry;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InquiryDAO {
    private Connection conn;
    
    public InquiryDAO(Connection conn) {
        this.conn = conn;
    }
    
    // 목록 조회 (타입별, 업체별)
    public List<Inquiry> getList(String type, String companyId, int page, int pageSize) throws SQLException {
        List<Inquiry> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT i.*, " +
            "(SELECT COUNT(*) FROM inquiry_memos WHERE inquiry_id = i.id) as memo_count " +
            "FROM inquiries i WHERE 1=1"
        );
        
        if (type != null && !type.isEmpty()) {
            sql.append(" AND i.type = ?");
        }
        if (companyId != null && !companyId.isEmpty()) {
            sql.append(" AND i.company_id = ?");
        }
        
        sql.append(" ORDER BY i.created_at DESC LIMIT ? OFFSET ?");
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (type != null && !type.isEmpty()) {
                pstmt.setString(idx++, type);
            }
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(idx++, companyId);
            }
            pstmt.setInt(idx++, pageSize);
            pstmt.setInt(idx++, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Inquiry inquiry = mapResultSet(rs);
                inquiry.setMemoCount(rs.getInt("memo_count"));
                list.add(inquiry);
            }
        }
        return list;
    }
    
    // 전체 개수
    public int getCount(String type, String companyId) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM inquiries WHERE 1=1"
        );
        
        if (type != null && !type.isEmpty()) {
            sql.append(" AND type = ?");
        }
        if (companyId != null && !companyId.isEmpty()) {
            sql.append(" AND company_id = ?");
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (type != null && !type.isEmpty()) {
                pstmt.setString(idx++, type);
            }
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(idx++, companyId);
            }
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // 상세 조회
    public Inquiry getById(int id) throws SQLException {
        String sql = "SELECT * FROM inquiries WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        }
        return null;
    }
    
    // 읽음 처리
    public void markAsRead(int id) throws SQLException {
        String sql = "UPDATE inquiries SET is_read = true WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // 상태 변경
    public void updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE inquiries SET status = ?, updated_at = NOW() WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            pstmt.executeUpdate();
        }
    }
    
    // 여러 타입 조회
    public List<Inquiry> getListMultipleTypes(String[] types, String companyId, int page, int pageSize) throws SQLException {
        List<Inquiry> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT i.*, " +
            "(SELECT COUNT(*) FROM inquiry_memos WHERE inquiry_id = i.id) as memo_count " +
            "FROM inquiries i WHERE 1=1"
        );
        
        if (types != null && types.length > 0) {
            sql.append(" AND i.type IN (");
            for (int i = 0; i < types.length; i++) {
                sql.append("?");
                if (i < types.length - 1) sql.append(",");
            }
            sql.append(")");
        }
        
        if (companyId != null && !companyId.isEmpty()) {
            sql.append(" AND i.company_id = ?");
        }
        
        sql.append(" ORDER BY i.created_at DESC LIMIT ? OFFSET ?");
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (types != null && types.length > 0) {
                for (String type : types) {
                    pstmt.setString(idx++, type);
                }
            }
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(idx++, companyId);
            }
            pstmt.setInt(idx++, pageSize);
            pstmt.setInt(idx++, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Inquiry inquiry = mapResultSet(rs);
                inquiry.setMemoCount(rs.getInt("memo_count"));
                list.add(inquiry);
            }
        }
        return list;
    }
    
    // 상태별 개수
    public int getCountByStatus(String status, String companyId) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM inquiries WHERE status = ?"
        );
        
        if (companyId != null && !companyId.isEmpty()) {
            sql.append(" AND company_id = ?");
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            pstmt.setString(idx++, status);
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(idx++, companyId);
            }
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // 오늘 등록된 개수
    public int getTodayCount(String companyId) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM inquiries WHERE DATE(created_at) = CURDATE()"
        );
        
        if (companyId != null && !companyId.isEmpty()) {
            sql.append(" AND company_id = ?");
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(1, companyId);
            }
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    private Inquiry mapResultSet(ResultSet rs) throws SQLException {
        Inquiry inquiry = new Inquiry();
        inquiry.setId(rs.getInt("id"));
        inquiry.setType(rs.getString("type"));
        inquiry.setCompanyId(rs.getString("company_id"));
        inquiry.setName(rs.getString("name"));
        inquiry.setEmail(rs.getString("email"));
        inquiry.setPhone(rs.getString("phone"));
        inquiry.setTitle(rs.getString("title"));
        inquiry.setContent(rs.getString("content"));
        inquiry.setDebtAmount(rs.getString("debt_amount"));
        inquiry.setMonthlyIncome(rs.getString("monthly_income"));
        inquiry.setStatus(rs.getString("status"));
        inquiry.setRead(rs.getBoolean("is_read"));
        inquiry.setCreatedAt(rs.getTimestamp("created_at"));
        inquiry.setUpdatedAt(rs.getTimestamp("updated_at"));
        return inquiry;
    }
}
