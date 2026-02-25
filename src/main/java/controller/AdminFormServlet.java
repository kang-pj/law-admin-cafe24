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

@WebServlet({"/admin/user/add", "/admin/user/edit"})
public class AdminFormServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        Admin currentAdmin = (Admin) session.getAttribute("admin");
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "세션 정보가 없습니다.");
            return;
        }
        
        // MASTER와 ADMIN만 접근 가능
        if (!"MASTER".equals(currentAdmin.getRole()) && !"ADMIN".equals(currentAdmin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }
        
        String id = request.getParameter("id");
        
        try (Connection conn = DBConnection.getConnection()) {
            CompanyDAO companyDAO = new CompanyDAO(conn);
            List<Company> companies = companyDAO.getList();
            
            // "시스템" 업체 제외
            companies.removeIf(company -> "시스템".equals(company.getName()));
            
            request.setAttribute("companies", companies);
            request.setAttribute("currentAdmin", currentAdmin);
            
            if (id != null) {
                // 수정 모드
                AdminDAO adminDAO = new AdminDAO(conn);
                Admin admin = adminDAO.getById(id);
                
                if (admin == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "관리자를 찾을 수 없습니다.");
                    return;
                }
                
                // ADMIN은 자기 업체 관리자만 수정 가능
                if ("ADMIN".equals(currentAdmin.getRole())) {
                    if (!admin.getCompanyId().equals(currentAdmin.getCompanyId())) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "다른 업체의 관리자는 수정할 수 없습니다.");
                        return;
                    }
                }
                
                request.setAttribute("admin", admin);
                request.setAttribute("mode", "edit");
            } else {
                // 추가 모드
                request.setAttribute("mode", "add");
            }
            
            request.getRequestDispatcher("/admin-form.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터 조회 중 오류가 발생했습니다.");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        Admin currentAdmin = (Admin) session.getAttribute("admin");
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "세션 정보가 없습니다.");
            return;
        }
        
        // MASTER와 ADMIN만 접근 가능
        if (!"MASTER".equals(currentAdmin.getRole()) && !"ADMIN".equals(currentAdmin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }
        
        String mode = request.getParameter("mode");
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String role = request.getParameter("role");
        String companyId = request.getParameter("company_id");
        String isActive = request.getParameter("is_active");
        
        try (Connection conn = DBConnection.getConnection()) {
            AdminDAO dao = new AdminDAO(conn);
            
            if ("add".equals(mode)) {
                // 추가 모드
                // ADMIN은 자기 업체에만 추가 가능
                if ("ADMIN".equals(currentAdmin.getRole())) {
                    companyId = currentAdmin.getCompanyId();
                    // ADMIN은 관리자 권한을 생성할 수 없음
                    if ("ADMIN".equals(role) || "MASTER".equals(role)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "관리자 권한을 생성할 수 없습니다.");
                        return;
                    }
                }
                
                Admin admin = new Admin();
                admin.setEmail(id);
                admin.setPassword(password);
                admin.setName(name);
                admin.setRole(role);
                admin.setCompanyId(companyId);
                admin.setIsActive(isActive != null ? isActive : "Y");
                
                dao.insert(admin);
                response.sendRedirect(request.getContextPath() + "/admin/user/list?success=1");
                
            } else {
                // 수정 모드
                Admin existingAdmin = dao.getById(id);
                
                if (existingAdmin == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "관리자를 찾을 수 없습니다.");
                    return;
                }
                
                // ADMIN은 자기 업체 관리자만 수정 가능
                if ("ADMIN".equals(currentAdmin.getRole())) {
                    if (!existingAdmin.getCompanyId().equals(currentAdmin.getCompanyId())) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "다른 업체의 관리자는 수정할 수 없습니다.");
                        return;
                    }
                    companyId = currentAdmin.getCompanyId();
                    // ADMIN은 관리자 권한으로 변경할 수 없음
                    if ("ADMIN".equals(role) || "MASTER".equals(role)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "관리자 권한으로 변경할 수 없습니다.");
                        return;
                    }
                }
                
                Admin admin = new Admin();
                admin.setEmail(id);
                admin.setName(name);
                admin.setRole(role);
                admin.setCompanyId(companyId);
                admin.setIsActive(isActive != null ? isActive : "Y");
                
                dao.update(admin);
                
                // 비밀번호가 입력된 경우에만 변경
                if (password != null && !password.trim().isEmpty()) {
                    dao.updatePassword(id, password);
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/user/edit?id=" + id + "&success=1");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if ("add".equals(mode)) {
                response.sendRedirect(request.getContextPath() + "/admin/user/add?error=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/user/edit?id=" + id + "&error=1");
            }
        }
    }
}
