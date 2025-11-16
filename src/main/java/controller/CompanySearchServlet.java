package controller;

import dao.CompanyDAO;
import model.Admin;
import model.Company;
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

@WebServlet("/admin/company/search")
public class CompanySearchServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null || !"MASTER".equals(admin.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            CompanyDAO dao = new CompanyDAO(conn);
            List<Company> list = dao.search(keyword);
            
            // "시스템" 업체 제외
            list.removeIf(company -> "시스템".equals(company.getName()));
            
            // 각 업체의 관리자 수 조회
            for (Company company : list) {
                int adminCount = dao.getAdminCount(company.getId());
                company.setDescription(String.valueOf(adminCount));
            }
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // JSON 수동 생성
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                Company c = list.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"id\":\"").append(escapeJson(c.getId())).append("\",");
                json.append("\"name\":\"").append(escapeJson(c.getName())).append("\",");
                json.append("\"description\":\"").append(escapeJson(c.getDescription())).append("\",");
                json.append("\"createdAt\":\"").append(c.getCreatedAt().getTime()).append("\"");
                json.append("}");
            }
            json.append("]");
            
            PrintWriter out = response.getWriter();
            out.print(json.toString());
            out.flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
