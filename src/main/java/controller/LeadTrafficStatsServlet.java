package controller;

import dao.LeadWithTrafficDAO;
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/stats/lead-traffic")
public class LeadTrafficStatsServlet extends HttpServlet {
    
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
        
        // 날짜 파라미터
        String period = request.getParameter("period");
        if (period == null) period = "today";
        
        // 날짜 계산
        LocalDate endDate = LocalDate.now();
        LocalDate startDate;
        
        // custom 기간 처리
        if ("custom".equals(period)) {
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");
            if (startDateParam != null && endDateParam != null) {
                startDate = LocalDate.parse(startDateParam);
                endDate = LocalDate.parse(endDateParam);
            } else {
                startDate = endDate;
            }
        } else {
            switch (period) {
                case "week":
                    startDate = endDate.minusDays(6);
                    break;
                case "month":
                    startDate = endDate.withDayOfMonth(1);
                    break;
                case "30days":
                    startDate = endDate.minusDays(29);
                    break;
                case "today":
                default:
                    startDate = endDate;
                    break;
            }
        }
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String startDateStr = startDate.format(formatter);
        String endDateStr = endDate.format(formatter);
        
        // 업체 필터링
        String companyId = null;
        if (!"MASTER".equals(admin.getRole())) {
            companyId = admin.getCompanyId();
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            LeadWithTrafficDAO dao = new LeadWithTrafficDAO(conn);
            
            // 페이징
            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            int pageSize = 20;
            
            // 유입 로그와 JOIN한 상담 신청 목록
            List<Map<String, Object>> leads = dao.getLeadsWithTraffic(companyId, startDateStr, endDateStr, page, pageSize);
            int totalCount = dao.getCount(companyId, startDateStr, endDateStr);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            // 일별 통계
            List<Map<String, Object>> dailyStats = dao.getDailyStats(companyId, startDateStr, endDateStr);
            
            // 유입 경로별 통계
            List<Map<String, Object>> utmSourceStats = dao.getUtmSourceStats(companyId, startDateStr, endDateStr);
            
            // 디바이스별 통계
            List<Map<String, Object>> deviceStats = dao.getDeviceStats(companyId, startDateStr, endDateStr);
            
            // 전환율 데이터
            Map<String, Object> conversionData = dao.getConversionData(companyId, startDateStr, endDateStr);
            
            request.setAttribute("leads", leads);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("dailyStats", dailyStats);
            request.setAttribute("utmSourceStats", utmSourceStats);
            request.setAttribute("deviceStats", deviceStats);
            request.setAttribute("conversionData", conversionData);
            request.setAttribute("period", period);
            request.setAttribute("startDate", startDateStr);
            request.setAttribute("endDate", endDateStr);
            
            request.getRequestDispatcher("/lead-traffic-stats.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "통계 조회 중 오류가 발생했습니다.");
        }
    }
}
