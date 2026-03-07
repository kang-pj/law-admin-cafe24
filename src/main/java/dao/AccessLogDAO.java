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
        String sql = "INSERT INTO traffic_logs (company_id, ip_address, user_agent, landing_page, referrer_url, session_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, log.getCompanyId());
            pstmt.setString(2, log.getIpAddress());
            pstmt.setString(3, log.getUserAgent());
            pstmt.setString(4, log.getPageUrl());
            pstmt.setString(5, log.getReferrer());
            pstmt.setString(6, log.getSessionId());
            pstmt.executeUpdate();
        }
    }
    
    // 날짜별 접속 통계 (그래프용)
    public List<Map<String, Object>> getDailyStats(String companyId, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DATE(created_at) as date, COUNT(*) as count ");
        sql.append("FROM traffic_logs ");
        sql.append("WHERE DATE(created_at) BETWEEN ? AND ? ");
        sql.append("AND ip_address != '0:0:0:0:0:0:0:1' ");
        sql.append("AND (landing_page IS NULL OR landing_page NOT LIKE '%localhost:8081%') ");
        
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
        sql.append("FROM traffic_logs ");
        sql.append("WHERE DATE(created_at) = ? ");
        sql.append("AND ip_address != '0:0:0:0:0:0:0:1' ");
        sql.append("AND (landing_page IS NULL OR landing_page NOT LIKE '%localhost:8081%') ");
        
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
        sql.append("SELECT * FROM traffic_logs ");
        sql.append("WHERE DATE(created_at) BETWEEN ? AND ? ");
        sql.append("AND ip_address != '0:0:0:0:0:0:0:1' ");
        sql.append("AND (landing_page IS NULL OR landing_page NOT LIKE '%localhost:8081%') ");
        
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
                log.setPageUrl(rs.getString("landing_page"));
                log.setReferrer(rs.getString("referrer_url"));
                log.setSessionId(rs.getString("session_id"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(log);
            }
        }
        return list;
    }
    
    // 총 개수
    public int getTotalCount(String companyId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM traffic_logs";
        if (companyId != null && !companyId.isEmpty()) {
            sql += " WHERE company_id = ?";
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
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
    
    // 오늘 접속 수
    public int getTodayCount(String companyId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM traffic_logs WHERE DATE(created_at) = CURDATE()";
        if (companyId != null && !companyId.isEmpty()) {
            sql += " AND company_id = ?";
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
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
    
    // 고유 방문자 수 (세션 기준)
    public int getUniqueVisitorCount(String companyId) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT session_id) FROM traffic_logs";
        if (companyId != null && !companyId.isEmpty()) {
            sql += " WHERE company_id = ?";
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
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
    
    // 일별 통계 (최근 N일)
    public Map<String, Integer> getDailyStats(int days, String companyId) throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        
        String sql = "SELECT DATE(created_at) as date, COUNT(*) as count " +
                    "FROM traffic_logs " +
                    "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";
        
        if (companyId != null && !companyId.isEmpty()) {
            sql += " AND company_id = ?";
        }
        
        sql += " GROUP BY DATE(created_at) ORDER BY date";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, days);
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(2, companyId);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString("date"), rs.getInt("count"));
            }
        }
        return stats;
    }
    
    // 시간대별 통계 (최근 7일)
    public Map<Integer, Integer> getHourlyStats(String companyId) throws SQLException {
        Map<Integer, Integer> stats = new HashMap<>();
        
        String sql = "SELECT HOUR(created_at) as hour, COUNT(*) as count " +
                    "FROM traffic_logs " +
                    "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        
        if (companyId != null && !companyId.isEmpty()) {
            sql += " AND company_id = ?";
        }
        
        sql += " GROUP BY HOUR(created_at) ORDER BY hour";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(1, companyId);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                stats.put(rs.getInt("hour"), rs.getInt("count"));
            }
        }
        return stats;
    }
    
    // 총 개수 (날짜 범위)
    public int getCount(String companyId, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM traffic_logs ");
        sql.append("WHERE DATE(created_at) BETWEEN ? AND ? ");
        sql.append("AND ip_address != '0:0:0:0:0:0:0:1' ");
        sql.append("AND (landing_page IS NULL OR landing_page NOT LIKE '%localhost:8081%') ");
        
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
                    "LEFT JOIN traffic_logs a ON c.id = a.company_id " +
                    "AND DATE(a.created_at) BETWEEN ? AND ? " +
                    "AND a.ip_address != '0:0:0:0:0:0:0:1' " +
                    "AND (a.landing_page IS NULL OR a.landing_page NOT LIKE '%localhost:8081%') " +
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
