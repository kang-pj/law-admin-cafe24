package dao;

import model.ConsultationLead;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ConsultationLeadDAO {
    private Connection conn;
    
    public ConsultationLeadDAO(Connection conn) {
        this.conn = conn;
    }
    
    // 총 접수 수
    public int getTotalCount(String companyId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM consultation_leads";
        if (companyId != null) {
            sql += " WHERE company_id = ?";
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (companyId != null) {
                pstmt.setString(1, companyId);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        }
        return 0;
    }
    
    // 오늘 접수 수
    public int getTodayCount(String companyId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM consultation_leads WHERE DATE(created_at) = CURDATE()";
        if (companyId != null) {
            sql += " AND company_id = ?";
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (companyId != null) {
                pstmt.setString(1, companyId);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        }
        return 0;
    }
    
    // 상태별 접수 수
    public int getCountByStatus(String status, String companyId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM consultation_leads WHERE status = ?";
        if (companyId != null) {
            sql += " AND company_id = ?";
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            if (companyId != null) {
                pstmt.setString(2, companyId);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        }
        return 0;
    }
    
    // 일별 접수 통계 (최근 N일)
    public Map<String, Integer> getDailyStats(int days, String companyId) throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        
        String sql = "SELECT DATE(created_at) as date, COUNT(*) as count " +
                    "FROM consultation_leads " +
                    "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";
        
        if (companyId != null) {
            sql += " AND company_id = ?";
        }
        
        sql += " GROUP BY DATE(created_at) ORDER BY date";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, days);
            if (companyId != null) {
                pstmt.setString(2, companyId);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    stats.put(rs.getString("date"), rs.getInt("count"));
                }
            }
        }
        return stats;
    }
    
    // 유입 경로별 통계
    public Map<String, Integer> getSourceStats(String companyId) throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        
        String sql = "SELECT source, COUNT(*) as count FROM consultation_leads";
        if (companyId != null) {
            sql += " WHERE company_id = ?";
        }
        sql += " GROUP BY source ORDER BY count DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (companyId != null) {
                pstmt.setString(1, companyId);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String source = rs.getString("source");
                    if (source == null || source.isEmpty()) {
                        source = "직접 유입";
                    }
                    stats.put(source, rs.getInt("count"));
                }
            }
        }
        return stats;
    }
    
    // 시간대별 통계
    public Map<Integer, Integer> getHourlyStats(String companyId) throws SQLException {
        Map<Integer, Integer> stats = new HashMap<>();
        
        String sql = "SELECT HOUR(created_at) as hour, COUNT(*) as count " +
                    "FROM consultation_leads " +
                    "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        
        if (companyId != null) {
            sql += " AND company_id = ?";
        }
        
        sql += " GROUP BY HOUR(created_at) ORDER BY hour";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (companyId != null) {
                pstmt.setString(1, companyId);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    stats.put(rs.getInt("hour"), rs.getInt("count"));
                }
            }
        }
        return stats;
    }
    
    // 최근 접수 목록
    public List<ConsultationLead> getRecentLeads(int limit, String companyId) throws SQLException {
        List<ConsultationLead> list = new ArrayList<>();
        
        String sql = "SELECT * FROM consultation_leads";
        if (companyId != null) {
            sql += " WHERE company_id = ?";
        }
        sql += " ORDER BY created_at DESC LIMIT ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (companyId != null) {
                pstmt.setString(paramIndex++, companyId);
            }
            pstmt.setInt(paramIndex, limit);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLead(rs));
                }
            }
        }
        return list;
    }
    
    // 전환율 계산을 위한 기간별 데이터
    public Map<String, Object> getConversionData(int days, String companyId) throws SQLException {
        Map<String, Object> data = new HashMap<>();
        
        // 접수 수
        String leadSql = "SELECT COUNT(*) as count FROM consultation_leads " +
                        "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";
        if (companyId != null) {
            leadSql += " AND company_id = ?";
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(leadSql)) {
            pstmt.setInt(1, days);
            if (companyId != null) {
                pstmt.setString(2, companyId);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    data.put("leads", rs.getInt("count"));
                }
            }
        }
        
        // 접속 수 (access_logs에서)
        String accessSql = "SELECT COUNT(*) as count FROM access_logs " +
                          "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";
        if (companyId != null) {
            accessSql += " AND company_id = ?";
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(accessSql)) {
            pstmt.setInt(1, days);
            if (companyId != null) {
                pstmt.setString(2, companyId);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    data.put("visits", rs.getInt("count"));
                }
            }
        }
        
        // 전환율 계산
        int leads = (Integer) data.getOrDefault("leads", 0);
        int visits = (Integer) data.getOrDefault("visits", 0);
        double conversionRate = visits > 0 ? (double) leads / visits * 100 : 0;
        data.put("conversionRate", conversionRate);
        
        return data;
    }
    
    // ResultSet을 ConsultationLead 객체로 매핑
    private ConsultationLead mapResultSetToLead(ResultSet rs) throws SQLException {
        ConsultationLead lead = new ConsultationLead();
        lead.setId(rs.getInt("id"));
        lead.setCompanyId(rs.getString("company_id"));
        lead.setName(rs.getString("name"));
        lead.setPhone(rs.getString("phone"));
        lead.setEmail(rs.getString("email"));
        lead.setSubject(rs.getString("subject"));
        lead.setMessage(rs.getString("message"));
        lead.setSource(rs.getString("source"));
        lead.setStatus(rs.getString("status"));
        lead.setIpAddress(rs.getString("ip_address"));
        lead.setCreatedAt(rs.getTimestamp("created_at"));
        lead.setUpdatedAt(rs.getTimestamp("updated_at"));
        return lead;
    }
}
