package controller;

import dao.InquiryDAO;
import model.Admin;
import model.Inquiry;
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

@WebServlet("/admin/inquiry/list")
public class InquiryListServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            // 세션에 admin 객체가 없으면 개별 속성으로 생성
            admin = new Admin();
            admin.setEmail((String) session.getAttribute("adminId"));
            admin.setName((String) session.getAttribute("adminName"));
            admin.setRole((String) session.getAttribute("adminRole"));
            admin.setCompanyId((String) session.getAttribute("companyId"));
        }
        String type = request.getParameter("type");
        String companyFilter = request.getParameter("company");
        int page = 1;
        int pageSize = 10;
        
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            InquiryDAO dao = new InquiryDAO(conn);
            
            // 업체별 필터링
            String companyId = null;
            if ("MASTER".equals(admin.getRole())) {
                // MASTER는 업체 필터 파라미터 사용
                companyId = companyFilter;
            } else {
                // 일반 관리자는 자신의 업체만
                companyId = admin.getCompanyId();
            }
            
            List<Inquiry> list = dao.getList(type, companyId, page, pageSize);
            int totalCount = dao.getCount(type, companyId);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            request.setAttribute("inquiryList", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("type", type);
            
            request.getRequestDispatcher("/inquiry-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터 조회 중 오류가 발생했습니다.");
        }
    }
}
