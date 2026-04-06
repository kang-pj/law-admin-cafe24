package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LeadWithTrafficDAO {
    private Connection conn;
    
    public LeadWithTrafficDAO(Connection conn) {
        this.conn = conn;
    }
    
    // 유입 로그와 JOIN한 상담 신청 목록 (페이징)
    public List<Map<String, Object>> getLeadsWithTraffic(String companyId, String startDate, String endDate, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append("c.id, c.session_id, c.consultation_source, c.name, c.phone, c.email, ");
        sql.append("c.debt_amount, c.monthly_income, c.message, c.status, c.created_at, ");
        sql.append("t.company_id, t.landing_page, t.referrer_url, t.utm_source, t.utm_medium, t.utm_campaign, ");
        sql.append("t.device_type, t.os, t.browser, t.ip_address ");
        sql.append("FROM consultation_leads c ");
        sql.append("LEFT JOIN (");
        sql.append("  SELECT session_id, company_id, landing_page, referrer_url, utm_source, utm_medium, utm_campaign, ");
        sql.append("         device_type, os, browser, ip_address ");
        sql.append("  FROM traffic_logs ");
        sql.append("  WHERE (session_id, id) IN (SELECT session_id, MIN(id) FROM traffic_logs GROUP BY session_id) ");
        sql.append(") t ON c.session_id = t.session_id ");
        sql.append("WHERE DATE(c.created_at) BETWEEN ? AND ? ");
        sql.append("ORDER BY c.created_at DESC LIMIT ? OFFSET ?");
        
        List<Map<String, Object>> list = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            pstmt.setString(paramIndex++, startDate);
            pstmt.setString(paramIndex++, endDate);
            pstmt.setInt(paramIndex++, pageSize);
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getLong("id"));
                row.put("sessionId", rs.getString("session_id"));
                row.put("consultationSource", rs.getString("consultation_source"));
                row.put("name", rs.getString("name"));
                row.put("phone", rs.getString("phone"));
                row.put("email", rs.getString("email"));
                row.put("debtAmount", rs.getString("debt_amount"));
                row.put("monthlyIncome", rs.getString("monthly_income"));
                row.put("message", rs.getString("message"));
                row.put("status", rs.getString("status"));
                row.put("createdAt", rs.getTimestamp("created_at"));
                
                // 트래픽 정보
                row.put("companyId", rs.getString("company_id"));
                row.put("landingPage", rs.getString("landing_page"));
                row.put("referrerUrl", rs.getString("referrer_url"));
                row.put("utmSource", rs.getString("utm_source"));
                row.put("utmMedium", rs.getString("utm_medium"));
                row.put("utmCampaign", rs.getString("utm_campaign"));
                row.put("deviceType", rs.getString("device_type"));
                row.put("os", rs.getString("os"));
                row.put("browser", rs.getString("browser"));
                row.put("ipAddress", rs.getString("ip_address"));
                
                list.add(row);
            }
        }
        return list;
    }
    
    // 총 개수
    public int getCount(String companyId, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT c.id) FROM consultation_leads c ");
        sql.append("LEFT JOIN (");
        sql.append("  SELECT session_id, company_id FROM traffic_logs ");
        sql.append("  WHERE (session_id, id) IN (SELECT session_id, MIN(id) FROM traffic_logs GROUP BY session_id) ");
        sql.append(") t ON c.session_id = t.session_id ");
        sql.append("WHERE DATE(c.created_at) BETWEEN ? AND ? ");
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            pstmt.setString(paramIndex++, startDate);
            pstmt.setString(paramIndex++, endDate);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // 일별 통계 (상담 신청 + 접속)
    public List<Map<String, Object>> getDailyStats(String companyId, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append("DATE(c.created_at) as date, ");
        sql.append("COUNT(DISTINCT c.id) as lead_count, ");
        sql.append("COUNT(DISTINCT t.session_id) as visit_count ");
        sql.append("FROM consultation_leads c ");
        sql.append("LEFT JOIN traffic_logs t ON c.session_id = t.session_id ");
        sql.append("AND t.ip_address != '0:0:0:0:0:0:0:1' ");
        sql.append("AND (t.landing_page IS NULL OR t.landing_page NOT LIKE '%localhost:8081%') ");
        if (companyId != null && !companyId.isEmpty()) {
            sql.append("AND t.company_id = ? ");
        }
        sql.append("WHERE DATE(c.created_at) BETWEEN ? AND ? ");
        sql.append("GROUP BY DATE(c.created_at) ORDER BY date");
        
        List<Map<String, Object>> result = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(paramIndex++, companyId);
            }
            pstmt.setString(paramIndex++, startDate);
            pstmt.setString(paramIndex++, endDate);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("date", rs.getString("date"));
                row.put("leadCount", rs.getInt("lead_count"));
                row.put("visitCount", rs.getInt("visit_count"));
                result.add(row);
            }
        }
        return result;
    }
    
    // 유입 경로별 통계 (UTM 기준)
    public List<Map<String, Object>> getUtmSourceStats(String companyId, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append("COALESCE(t.utm_source, '직접 유입') as source, ");
        sql.append("COUNT(DISTINCT c.id) as count ");
        sql.append("FROM consultation_leads c ");
        sql.append("LEFT JOIN traffic_logs t ON c.session_id = t.session_id ");
        if (companyId != null && !companyId.isEmpty()) {
            sql.append("AND t.company_id = ? ");
        }
        sql.append("WHERE DATE(c.created_at) BETWEEN ? AND ? ");
        sql.append("GROUP BY COALESCE(t.utm_source, '직접 유입') ORDER BY count DESC");
        
        List<Map<String, Object>> result = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(paramIndex++, companyId);
            }
            pstmt.setString(paramIndex++, startDate);
            pstmt.setString(paramIndex++, endDate);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("source", rs.getString("source"));
                row.put("count", rs.getInt("count"));
                result.add(row);
            }
        }
        return result;
    }
    
    // 디바이스별 통계
    public List<Map<String, Object>> getDeviceStats(String companyId, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append("COALESCE(t.device_type, '알 수 없음') as device, ");
        sql.append("COUNT(DISTINCT c.id) as count ");
        sql.append("FROM consultation_leads c ");
        sql.append("LEFT JOIN traffic_logs t ON c.session_id = t.session_id ");
        if (companyId != null && !companyId.isEmpty()) {
            sql.append("AND t.company_id = ? ");
        }
        sql.append("WHERE DATE(c.created_at) BETWEEN ? AND ? ");
        sql.append("GROUP BY COALESCE(t.device_type, '알 수 없음') ORDER BY count DESC");
        
        List<Map<String, Object>> result = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(paramIndex++, companyId);
            }
            pstmt.setString(paramIndex++, startDate);
            pstmt.setString(paramIndex++, endDate);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("device", rs.getString("device"));
                row.put("count", rs.getInt("count"));
                result.add(row);
            }
        }
        return result;
    }
    
    // 전환율 데이터
    public Map<String, Object> getConversionData(String companyId, String startDate, String endDate) throws SQLException {
        Map<String, Object> data = new HashMap<>();
        
        // 상담 신청 수 (company_id 무관하게 전체)
        String leadSql = "SELECT COUNT(*) as count FROM consultation_leads " +
                        "WHERE DATE(created_at) BETWEEN ? AND ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(leadSql)) {
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                data.put("leads", rs.getInt("count"));
            }
        }
        
        // 순 방문자 수 (세션 기준)
        StringBuilder visitSql = new StringBuilder();
        visitSql.append("SELECT COUNT(DISTINCT session_id) as count FROM traffic_logs ");
        visitSql.append("WHERE DATE(created_at) BETWEEN ? AND ? ");
        visitSql.append("AND ip_address != '0:0:0:0:0:0:0:1' ");
        visitSql.append("AND (landing_page IS NULL OR landing_page NOT LIKE '%localhost:8081%') ");
        if (companyId != null && !companyId.isEmpty()) {
            visitSql.append("AND company_id = ? ");
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(visitSql.toString())) {
            int paramIndex = 1;
            pstmt.setString(paramIndex++, startDate);
            pstmt.setString(paramIndex++, endDate);
            if (companyId != null && !companyId.isEmpty()) {
                pstmt.setString(paramIndex++, companyId);
            }
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                data.put("visits", rs.getInt("count"));
            }
        }
        
        int leads = (Integer) data.getOrDefault("leads", 0);
        int visits = (Integer) data.getOrDefault("visits", 0);
        double conversionRate = visits > 0 ? (double) leads / visits * 100 : 0;
        data.put("conversionRate", String.format("%.2f", conversionRate));
        
        return data;
    }
}
