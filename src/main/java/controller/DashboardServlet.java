package controller;

import dao.InquiryDAO;
import model.Admin;
import model.Inquiry;
import util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            admin = new Admin();
            admin.setEmail((String) session.getAttribute("adminId"));
            admin.setName((String) session.getAttribute("adminName"));
            admin.setRole((String) session.getAttribute("adminRole"));
            admin.setCompanyId((String) session.getAttribute("companyId"));
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            InquiryDAO dao = new InquiryDAO(conn);
            
            // 업체별 필터링
            String companyId = null;
            if (!"MASTER".equals(admin.getRole())) {
                companyId = admin.getCompanyId();
            }
            
            // 최근 문의 게시판 (INQ) 5개
            List<Inquiry> recentInquiries = dao.getList("INQ", companyId, 1, 5);
            
            // 최근 자가진단 게시판 (SELF) 5개
            List<Inquiry> recentSelfDiagnosis = dao.getList("SELF", companyId, 1, 5);
            
            // 최근 기타 문의 (ETC, KAKAO, EMAIL) 5개
            List<Inquiry> recentOthers = dao.getListMultipleTypes(
                new String[]{"ETC", "KAKAO", "EMAIL"}, companyId, 1, 5
            );
            
            // 통계 데이터
            int totalInquiries = dao.getCount(null, companyId);
            int pendingCount = dao.getCountByStatus("pending", companyId);
            int processingCount = dao.getCountByStatus("processing", companyId);
            int todayCount = dao.getTodayCount(companyId);
            
            request.setAttribute("recentInquiries", recentInquiries);
            request.setAttribute("recentSelfDiagnosis", recentSelfDiagnosis);
            request.setAttribute("recentOthers", recentOthers);
            request.setAttribute("totalInquiries", totalInquiries);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("processingCount", processingCount);
            request.setAttribute("todayCount", todayCount);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
