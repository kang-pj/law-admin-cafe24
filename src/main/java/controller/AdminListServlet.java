package controller;

import dao.AdminDAO;
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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/user/list")
public class AdminListServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        Admin currentAdmin = (Admin) session.getAttribute("admin");
        
        // 디버깅: admin 객체 확인
        if (currentAdmin == null) {
            System.out.println("[AdminListServlet] currentAdmin is null");
            // admin 객체가 없으면 세션 속성으로 생성 시도
            String adminRole = (String) session.getAttribute("adminRole");
            if (adminRole != null) {
                currentAdmin = new Admin();
                currentAdmin.setEmail((String) session.getAttribute("adminId"));
                currentAdmin.setName((String) session.getAttribute("adminName"));
                currentAdmin.setRole(adminRole);
                currentAdmin.setCompanyId((String) session.getAttribute("companyId"));
            }
        }
        
        if (currentAdmin == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "세션 정보가 없습니다.");
            return;
        }
        
        System.out.println("[AdminListServlet] currentAdmin role: " + currentAdmin.getRole());
        
        // MASTER와 ADMIN 모두 접근 가능
        if (!"MASTER".equals(currentAdmin.getRole()) && !"ADMIN".equals(currentAdmin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다. (권한: " + currentAdmin.getRole() + ")");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            AdminDAO adminDAO = new AdminDAO(conn);
            CompanyDAO companyDAO = new CompanyDAO(conn);
            
            List<Admin> adminList;
            
            // MASTER는 전체 관리자, ADMIN은 자기 업체 관리자만
            if ("MASTER".equals(currentAdmin.getRole())) {
                adminList = adminDAO.getList();
            } else {
                adminList = adminDAO.getListByCompany(currentAdmin.getCompanyId());
            }
            
            // 업체 정보 맵 생성
            Map<String, String> companyMap = new HashMap<>();
            List<Company> companies = companyDAO.getList();
            for (Company company : companies) {
                companyMap.put(company.getId(), company.getName());
            }
            
            request.setAttribute("adminList", adminList);
            request.setAttribute("companyMap", companyMap);
            request.setAttribute("currentAdmin", currentAdmin);
            request.getRequestDispatcher("/admin-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터 조회 중 오류가 발생했습니다.");
        }
    }
}
