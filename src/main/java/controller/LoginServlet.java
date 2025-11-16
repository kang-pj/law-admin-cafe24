package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.AdminDAO;
import model.Admin;
import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/admin/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        
        try (Connection conn = DBConnection.getConnection()) {
            AdminDAO adminDAO = new AdminDAO(conn);
            Admin admin = adminDAO.login(id, password);
            
            if (admin != null) {
                HttpSession session = request.getSession();
                session.setAttribute("admin", admin);  // Admin 객체 저장
                session.setAttribute("adminId", admin.getEmail());
                session.setAttribute("adminName", admin.getName());
                session.setAttribute("adminRole", admin.getRole());
                session.setAttribute("companyId", admin.getCompanyId());
                session.setAttribute("isSuperAdmin", admin.isSuperAdmin());
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/login?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/login?error=1");
        }
    }
}
