package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.AdminDAO;
import model.Admin;
import java.io.IOException;

@WebServlet("/admin/login")
public class LoginServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();
    
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
        
        Admin admin = adminDAO.login(id, password);
        
        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("adminId", admin.getEmail());
            session.setAttribute("adminName", admin.getName());
            session.setAttribute("adminRole", admin.getRole());
            session.setAttribute("companyId", admin.getCompanyId());
            session.setAttribute("isSuperAdmin", admin.isSuperAdmin());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/login?error=1");
        }
    }
}
