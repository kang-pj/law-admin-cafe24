package controller;

import dao.InquiryDAO;
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

@WebServlet("/admin/inquiry/status")
public class InquiryStatusServlet extends HttpServlet {
    
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
        
        String idParam = request.getParameter("id");
        String status = request.getParameter("status");
        
        if (idParam == null || status == null) {
            out.print("{\"success\": false, \"message\": \"필수 파라미터가 누락되었습니다.\"}");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            int id = Integer.parseInt(idParam);
            InquiryDAO dao = new InquiryDAO(conn);
            dao.updateStatus(id, status);
            
            out.print("{\"success\": true, \"message\": \"상태가 변경되었습니다.\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"상태 변경 중 오류가 발생했습니다.\"}");
        }
    }
}
