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
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/company/list")
public class CompanyListServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null || !"MASTER".equals(admin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            CompanyDAO dao = new CompanyDAO(conn);
            List<Company> list = dao.getList();
            
            // "시스템" 업체 제외 및 각 업체의 관리자 수 조회
            list.removeIf(company -> "시스템".equals(company.getName()));
            
            for (Company company : list) {
                int adminCount = dao.getAdminCount(company.getId());
                company.setDescription(String.valueOf(adminCount)); // 임시로 description에 저장
            }
            
            request.setAttribute("companyList", list);
            request.getRequestDispatcher("/company-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터 조회 중 오류가 발생했습니다.");
        }
    }
}
