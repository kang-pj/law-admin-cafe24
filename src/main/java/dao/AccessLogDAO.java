package dao;

import model.AccessLog;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AccessLogDAO {
    private Connection conn;
    
    public AccessLogDAO(Connection conn) {
        this.conn = conn;
    }
    
    // 접속 로그 추가
    public void insert(AccessLog log) throws SQLException {
        String sql = "INSERT INTO access_logs (company_id, ip_address, user_agent, page_url, referrer, session_id, country) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, log.getCompanyId());
            pstmt.setString(2, log.getIpAddress());
            pstmt.setString(3, log.getUserAgent());
            pstmt.setString(4, log.getPageUrl());
            pstmt.setString(5, log.getReferrer());
            pstmt.setString(6, log.getSessionId());
            pstmt.setString(7, log.getCountry());
            pstmt.executeUpdate();
        }
    }
    
    // 날짜별 접속 통계 (그래프용)
    public List<Map<String, Object>> getDailyStats(String companyId, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DATE(created_at) as date, COUNT(*) as count ");
        sql.append("FROM access_logs ");
        sql.append("WHERE DATE(created_at) BETWEEN ? AND ? ");
        
        if (companyId != null && !companyId.isEmpty()) {
            sql.append("AND company_id = ? ");
        }
        
        sql.append("GROUP BY DATE(created_at) ORDER BY date");
        
        List<Map<String, Object>> result = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(3, companyId);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("date", rs.getString("date"));
                row.put("count", rs.getInt("count"));
                result.add(row);
            }
        }
        return result;
    }
    
    // 시간별 접속 통계
    public List<Map<String, Object>> getHourlyStats(String companyId, String date) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT HOUR(created_at) as hour, COUNT(*) as count ");
        sql.append("FROM access_logs ");
        sql.append("WHERE DATE(created_at) = ? ");
        
        if (companyId != null && !companyId.isEmpty()) {
            sql.append("AND company_id = ? ");
        }
        
        sql.append("GROUP BY HOUR(created_at) ORDER BY hour");
        
        List<Map<String, Object>> result = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            pstmt.setString(1, date);
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(2, companyId);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("hour", rs.getInt("hour"));
                row.put("count", rs.getInt("count"));
                result.add(row);
            }
        }
        return result;
    }
    
    // 상세 로그 목록 (페이징)
    public List<AccessLog> getList(String companyId, String startDate, String endDate, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM access_logs ");
        sql.append("WHERE DATE(created_at) BETWEEN ? AND ? ");
        
        if (companyId != null && !companyId.isEmpty()) {
            sql.append("AND company_id = ? ");
        }
        
        sql.append("ORDER BY created_at DESC LIMIT ? OFFSET ?");
        
        List<AccessLog> list = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            pstmt.setString(paramIndex++, startDate);
            pstmt.setString(paramIndex++, endDate);
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(paramIndex++, companyId);
            }
            pstmt.setInt(paramIndex++, pageSize);
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                AccessLog log = new AccessLog();
                log.setId(rs.getInt("id"));
                log.setCompanyId(rs.getString("company_id"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setUserAgent(rs.getString("user_agent"));
                log.setPageUrl(rs.getString("page_url"));
                log.setReferrer(rs.getString("referrer"));
                log.setSessionId(rs.getString("session_id"));
                log.setCountry(rs.getString("country"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(log);
            }
        }
        return list;
    }
    
    // 총 개수
    public int getCount(String companyId, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM access_logs ");
        sql.append("WHERE DATE(created_at) BETWEEN ? AND ? ");
        
        if (companyId != null && !companyId.isEmpty()) {
            sql.append("AND company_id = ? ");
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            pstmt.setString(paramIndex++, startDate);
            pstmt.setString(paramIndex++, endDate);
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(paramIndex++, companyId);
            }
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // 업체별 통계
    public List<Map<String, Object>> getStatsByCompany(String startDate, String endDate) throws SQLException {
        String sql = "SELECT c.id, c.name, COUNT(a.id) as count " +
                    "FROM companies c " +
                    "LEFT JOIN access_logs a ON c.id = a.company_id AND DATE(a.created_at) BETWEEN ? AND ? " +
                    "WHERE c.id != 'SYSTEM' " +
                    "GROUP BY c.id, c.name " +
                    "ORDER BY count DESC";
        
        List<Map<String, Object>> result = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("companyId", rs.getString("id"));
                row.put("companyName", rs.getString("name"));
                row.put("count", rs.getInt("count"));
                result.add(row);
            }
        }
        return result;
    }
}
