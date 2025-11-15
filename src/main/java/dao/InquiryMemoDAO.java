package dao;

import model.InquiryMemo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InquiryMemoDAO {
    private Connection conn;
    
    public InquiryMemoDAO(Connection conn) {
        this.conn = conn;
    }
    
    // 메모 목록 조회
    public List<InquiryMemo> getListByInquiryId(int inquiryId) throws SQLException {
        List<InquiryMemo> list = new ArrayList<>();
        String sql = "SELECT * FROM inquiry_memos WHERE inquiry_id = ? ORDER BY created_at DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, inquiryId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                InquiryMemo memo = new InquiryMemo();
                memo.setId(rs.getInt("id"));
                memo.setInquiryId(rs.getInt("inquiry_id"));
                memo.setAdminId(rs.getString("admin_id"));
                memo.setAdminName(rs.getString("admin_name"));
                memo.setContent(rs.getString("content"));
                memo.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(memo);
            }
        }
        return list;
    }
    
    // 메모 추가
    public void insert(InquiryMemo memo) throws SQLException {
        String sql = "INSERT INTO inquiry_memos (inquiry_id, admin_id, admin_name, content, created_at) " +
                     "VALUES (?, ?, ?, ?, NOW())";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memo.getInquiryId());
            pstmt.setString(2, memo.getAdminId());
            pstmt.setString(3, memo.getAdminName());
            pstmt.setString(4, memo.getContent());
            pstmt.executeUpdate();
        }
    }
    
    // 메모 수정
    public void update(int id, String content) throws SQLException {
        String sql = "UPDATE inquiry_memos SET content = ? WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, content);
            pstmt.setInt(2, id);
            pstmt.executeUpdate();
        }
    }
    
    // 메모 삭제
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM inquiry_memos WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // 메모 개수 조회
    public int getCountByInquiryId(int inquiryId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM inquiry_memos WHERE inquiry_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, inquiryId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
