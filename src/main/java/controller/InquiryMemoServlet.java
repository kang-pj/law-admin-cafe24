package controller;

import dao.InquiryMemoDAO;
import model.Admin;
import model.InquiryMemo;
import util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/inquiry/memo")
public class InquiryMemoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
            return;
        }
        
        String idParam = request.getParameter("inquiryId");
        if (idParam == null) {
            out.print("{\"success\": false, \"message\": \"필수 파라미터가 누락되었습니다.\"}");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            int inquiryId = Integer.parseInt(idParam);
            InquiryMemoDAO dao = new InquiryMemoDAO(conn);
            List<InquiryMemo> memos = dao.getListByInquiryId(inquiryId);
            
            StringBuilder json = new StringBuilder("{\"success\": true, \"memos\": [");
            for (int i = 0; i < memos.size(); i++) {
                InquiryMemo memo = memos.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"id\": ").append(memo.getId()).append(",")
                    .append("\"adminName\": \"").append(escapeJson(memo.getAdminName())).append("\",")
                    .append("\"content\": \"").append(escapeJson(memo.getContent())).append("\",")
                    .append("\"createdAt\": \"").append(memo.getCreatedAt()).append("\"")
                    .append("}");
            }
            json.append("]}");
            
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"메모 조회 중 오류가 발생했습니다.\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
            return;
        }
        
        String idParam = request.getParameter("inquiryId");
        String content = request.getParameter("content");
        
        if (idParam == null || content == null || content.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"필수 파라미터가 누락되었습니다.\"}");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            int inquiryId = Integer.parseInt(idParam);
            
            InquiryMemo memo = new InquiryMemo();
            memo.setInquiryId(inquiryId);
            memo.setAdminId((String) session.getAttribute("adminId"));
            memo.setAdminName((String) session.getAttribute("adminName"));
            memo.setContent(content);
            
            InquiryMemoDAO dao = new InquiryMemoDAO(conn);
            dao.insert(memo);
            
            out.print("{\"success\": true, \"message\": \"메모가 추가되었습니다.\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"메모 추가 중 오류가 발생했습니다.\"}");
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
            return;
        }
        
        String idParam = request.getParameter("id");
        String content = request.getParameter("content");
        
        if (idParam == null || content == null || content.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"필수 파라미터가 누락되었습니다.\"}");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            int id = Integer.parseInt(idParam);
            InquiryMemoDAO dao = new InquiryMemoDAO(conn);
            dao.update(id, content);
            
            out.print("{\"success\": true, \"message\": \"메모가 수정되었습니다.\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"메모 수정 중 오류가 발생했습니다.\"}");
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
            return;
        }
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            out.print("{\"success\": false, \"message\": \"필수 파라미터가 누락되었습니다.\"}");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            int id = Integer.parseInt(idParam);
            InquiryMemoDAO dao = new InquiryMemoDAO(conn);
            dao.delete(id);
            
            out.print("{\"success\": true, \"message\": \"메모가 삭제되었습니다.\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"메모 삭제 중 오류가 발생했습니다.\"}");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
