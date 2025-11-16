package controller;

import dao.AdminDAO;
import model.Admin;
import util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/admin/user/delete")
public class AdminDeleteServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        Admin currentAdmin = (Admin) session.getAttribute("admin");
        
        // admin 객체가 없으면 세션 속성으로 생성
        if (currentAdmin == null) {
            String adminRole = (String) session.getAttribute("adminRole");
            if (adminRole != null) {
                currentAdmin = new Admin();
                currentAdmin.setEmail((String) session.getAttribute("adminId"));
                currentAdmin.setRole(adminRole);
                currentAdmin.setCompanyId((String) session.getAttribute("companyId"));
            }
        }
        
        if (currentAdmin == null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // MASTER와 ADMIN만 접근 가능
        if (!"MASTER".equals(currentAdmin.getRole()) && !"ADMIN".equals(currentAdmin.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String id = request.getParameter("id");
        if (id == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            AdminDAO dao = new AdminDAO(conn);
            
            // 자기 자신은 삭제 불가
            if (id.equals(currentAdmin.getEmail())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("자기 자신은 삭제할 수 없습니다.");
                return;
            }
            
            // ADMIN은 자기 업체 관리자만 삭제 가능
            if ("ADMIN".equals(currentAdmin.getRole())) {
                Admin targetAdmin = dao.getById(id);
                if (targetAdmin == null || !targetAdmin.getCompanyId().equals(currentAdmin.getCompanyId())) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("다른 업체의 관리자는 삭제할 수 없습니다.");
                    return;
                }
            }
            
            dao.delete(id);
            
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("success");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
