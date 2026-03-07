package controller;

import dao.AccessLogDAO;
import dao.ConsultationLeadDAO;
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
import java.util.Map;

@WebServlet("/admin/stats/integrated")
public class IntegratedStatsServlet extends HttpServlet {
    
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
            admin.setRole((String) session.getAttribute("adminRole"));
            admin.setCompanyId((String) session.getAttribute("companyId"));
        }
        
        // 업체별 필터링
        String companyId = null;
        if (!"MASTER".equals(admin.getRole())) {
            companyId = admin.getCompanyId();
        }
        
        String period = request.getParameter("period");
        int days = 7; // 기본 7일
        
        if ("30".equals(period)) {
            days = 30;
        } else if ("90".equals(period)) {
            days = 90;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            AccessLogDAO accessDAO = new AccessLogDAO(conn);
            ConsultationLeadDAO leadDAO = new ConsultationLeadDAO(conn);
            
            // 접속 통계
            int totalVisits = accessDAO.getTotalCount(companyId);
            int todayVisits = accessDAO.getTodayCount(companyId);
            int uniqueVisitors = accessDAO.getUniqueVisitorCount(companyId);
            
            // 접수 통계
            int totalLeads = leadDAO.getTotalCount(companyId);
            int todayLeads = leadDAO.getTodayCount(companyId);
            int pendingLeads = leadDAO.getCountByStatus("pending", companyId);
            int completedLeads = leadDAO.getCountByStatus("completed", companyId);
            
            // 전환율 데이터
            Map<String, Object> conversionData = leadDAO.getConversionData(days, companyId);
            
            // 일별 통계
            Map<String, Integer> dailyVisits = accessDAO.getDailyStats(days, companyId);
            Map<String, Integer> dailyLeads = leadDAO.getDailyStats(days, companyId);
            
            // 유입 경로별 통계
            Map<String, Integer> sourceStats = leadDAO.getSourceStats(companyId);
            
            // 시간대별 통계
            Map<Integer, Integer> hourlyVisits = accessDAO.getHourlyStats(companyId);
            Map<Integer, Integer> hourlyLeads = leadDAO.getHourlyStats(companyId);
            
            // 속성 설정
            request.setAttribute("totalVisits", totalVisits);
            request.setAttribute("todayVisits", todayVisits);
            request.setAttribute("uniqueVisitors", uniqueVisitors);
            request.setAttribute("totalLeads", totalLeads);
            request.setAttribute("todayLeads", todayLeads);
            request.setAttribute("pendingLeads", pendingLeads);
            request.setAttribute("completedLeads", completedLeads);
            request.setAttribute("conversionData", conversionData);
            request.setAttribute("dailyVisits", dailyVisits);
            request.setAttribute("dailyLeads", dailyLeads);
            request.setAttribute("sourceStats", sourceStats);
            request.setAttribute("hourlyVisits", hourlyVisits);
            request.setAttribute("hourlyLeads", hourlyLeads);
            request.setAttribute("period", days);
            
            request.getRequestDispatcher("/integrated-stats.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "통계 조회 중 오류가 발생했습니다.");
        }
    }
}
