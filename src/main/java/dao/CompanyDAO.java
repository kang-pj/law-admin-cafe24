package dao;

import model.Company;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {
    private Connection conn;
    
    public CompanyDAO(Connection conn) {
        this.conn = conn;
    }
    
    // 전체 업체 목록 조회
    public List<Company> getList() throws SQLException {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT id, name, created_at, " +
                    "(SELECT COUNT(*) FROM admins WHERE company_id = companies.id) as admin_count " +
                    "FROM companies ORDER BY created_at DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Company company = new Company();
                company.setId(rs.getString("id"));
                company.setName(rs.getString("name"));
                company.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(company);
            }
        }
        return list;
    }
    
    // 업체 상세 조회
    public Company getById(String id) throws SQLException {
        String sql = "SELECT * FROM companies WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Company company = new Company();
                    company.setId(rs.getString("id"));
                    company.setName(rs.getString("name"));
                    company.setDescription(rs.getString("description"));
                    company.setIsActive(rs.getString("is_active"));
                    company.setCreatedAt(rs.getTimestamp("created_at"));
                    company.setUpdatedAt(rs.getTimestamp("updated_at"));
                    company.setCompanyName(rs.getString("company_name"));
                    company.setRepresentative(rs.getString("representative"));
                    company.setBusinessNumber(rs.getString("business_number"));
                    company.setPhone(rs.getString("phone"));
                    company.setFax(rs.getString("fax"));
                    company.setAddress(rs.getString("address"));
                    company.setPostalCode(rs.getString("postal_code"));
                    company.setEmail(rs.getString("email"));
                    company.setWeekdayStart(rs.getString("weekday_start"));
                    company.setWeekdayEnd(rs.getString("weekday_end"));
                    company.setWeekendStart(rs.getString("weekend_start"));
                    company.setWeekendEnd(rs.getString("weekend_end"));
                    company.setSiteTitle(rs.getString("site_title"));
                    company.setSiteSubtitle(rs.getString("site_subtitle"));
                    company.setSiteDescription(rs.getString("site_description"));
                    company.setSiteKeywords(rs.getString("site_keywords"));
                    company.setLogoUrl(rs.getString("logo_url"));
                    company.setFaviconUrl(rs.getString("favicon_url"));
                    company.setScheduleJson(rs.getString("schedule_json"));
                    return company;
                }
            }
        }
        return null;
    }
    
    // 업체 추가
    public void insert(Company company) throws SQLException {
        String sql = "INSERT INTO companies (id, name, description, is_active, company_name, " +
                    "representative, business_number, phone, fax, address, postal_code, email, " +
                    "weekday_start, weekday_end, weekend_start, weekend_end, " +
                    "site_title, site_subtitle, site_description, site_keywords, " +
                    "logo_url, favicon_url, schedule_json) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, company.getId());
            pstmt.setString(2, company.getName());
            pstmt.setString(3, company.getDescription());
            pstmt.setString(4, company.getIsActive());
            pstmt.setString(5, company.getCompanyName());
            pstmt.setString(6, company.getRepresentative());
            pstmt.setString(7, company.getBusinessNumber());
            pstmt.setString(8, company.getPhone());
            pstmt.setString(9, company.getFax());
            pstmt.setString(10, company.getAddress());
            pstmt.setString(11, company.getPostalCode());
            pstmt.setString(12, company.getEmail());
            pstmt.setString(13, company.getWeekdayStart());
            pstmt.setString(14, company.getWeekdayEnd());
            pstmt.setString(15, company.getWeekendStart());
            pstmt.setString(16, company.getWeekendEnd());
            pstmt.setString(17, company.getSiteTitle());
            pstmt.setString(18, company.getSiteSubtitle());
            pstmt.setString(19, company.getSiteDescription());
            pstmt.setString(20, company.getSiteKeywords());
            pstmt.setString(21, company.getLogoUrl());
            pstmt.setString(22, company.getFaviconUrl());
            pstmt.setString(23, company.getScheduleJson());
            pstmt.executeUpdate();
        }
    }
    
    // 업체 수정
    public void update(Company company) throws SQLException {
        String sql = "UPDATE companies SET name = ?, description = ?, is_active = ?, " +
                    "company_name = ?, representative = ?, business_number = ?, " +
                    "phone = ?, fax = ?, address = ?, postal_code = ?, email = ?, " +
                    "weekday_start = ?, weekday_end = ?, weekend_start = ?, weekend_end = ?, " +
                    "site_title = ?, site_subtitle = ?, site_description = ?, site_keywords = ?, " +
                    "logo_url = ?, favicon_url = ?, schedule_json = ? " +
                    "WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, company.getName());
            pstmt.setString(2, company.getDescription());
            pstmt.setString(3, company.getIsActive());
            pstmt.setString(4, company.getCompanyName());
            pstmt.setString(5, company.getRepresentative());
            pstmt.setString(6, company.getBusinessNumber());
            pstmt.setString(7, company.getPhone());
            pstmt.setString(8, company.getFax());
            pstmt.setString(9, company.getAddress());
            pstmt.setString(10, company.getPostalCode());
            pstmt.setString(11, company.getEmail());
            pstmt.setString(12, company.getWeekdayStart());
            pstmt.setString(13, company.getWeekdayEnd());
            pstmt.setString(14, company.getWeekendStart());
            pstmt.setString(15, company.getWeekendEnd());
            pstmt.setString(16, company.getSiteTitle());
            pstmt.setString(17, company.getSiteSubtitle());
            pstmt.setString(18, company.getSiteDescription());
            pstmt.setString(19, company.getSiteKeywords());
            pstmt.setString(20, company.getLogoUrl());
            pstmt.setString(21, company.getFaviconUrl());
            pstmt.setString(22, company.getScheduleJson());
            pstmt.setString(23, company.getId());
            pstmt.executeUpdate();
        }
    }
    
    // 업체 삭제
    public void delete(String id) throws SQLException {
        String sql = "DELETE FROM companies WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // 관리자 수 조회
    public int getAdminCount(String companyId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM admins WHERE company_id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // 업체 검색 (ID 또는 이름으로)
    public List<Company> search(String keyword) throws SQLException {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT id, name, created_at FROM companies " +
                    "WHERE id LIKE ? OR name LIKE ? " +
                    "ORDER BY created_at DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Company company = new Company();
                    company.setId(rs.getString("id"));
                    company.setName(rs.getString("name"));
                    company.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(company);
                }
            }
        }
        return list;
    }
}
