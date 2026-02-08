package controller;

import dao.AccessLogDAO;
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/stats/access")
public class AccessStatsServlet extends HttpServlet {
    
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
        
        String companyFilter = request.getParameter("company");
        
        // MASTER가 아니면 자기 업체만
        String companyId = null;
        if ("MASTER".equals(admin.getRole())) {
            companyId = companyFilter;
        } else {
            companyId = admin.getCompanyId();
        }
        
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
        
        try (Connection conn = DBConnection.getConnection()) {
            AccessLogDAO dao = new AccessLogDAO(conn);
            
            // 일별 통계 (그래프용)
            List<Map<String, Object>> dailyStats = dao.getDailyStats(companyId, startDateStr, endDateStr);
            
            // 시간별 통계 (오늘만)
            List<Map<String, Object>> hourlyStats = null;
            if ("today".equals(period)) {
                hourlyStats = dao.getHourlyStats(companyId, endDateStr);
            }
            
            // 상세 로그 목록
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
            List<model.AccessLog> logs = dao.getList(companyId, startDateStr, endDateStr, page, pageSize);
            int totalCount = dao.getCount(companyId, startDateStr, endDateStr);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            // 업체별 통계 (MASTER만)
            List<Map<String, Object>> companyStats = null;
            if ("MASTER".equals(admin.getRole())) {
                companyStats = dao.getStatsByCompany(startDateStr, endDateStr);
            }
            
            // 업체 목록 (MASTER만)
            List<Company> companies = null;
            if ("MASTER".equals(admin.getRole())) {
                CompanyDAO companyDAO = new CompanyDAO(conn);
                companies = companyDAO.getList();
                companies.removeIf(c -> "SYSTEM".equals(c.getId()));
            }
            
            request.setAttribute("dailyStats", dailyStats);
            request.setAttribute("hourlyStats", hourlyStats);
            request.setAttribute("logs", logs);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("companyStats", companyStats);
            request.setAttribute("companies", companies);
            request.setAttribute("period", period);
            request.setAttribute("companyFilter", companyFilter);
            request.setAttribute("startDate", startDateStr);
            request.setAttribute("endDate", endDateStr);
            
            request.getRequestDispatcher("/access-stats.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "통계 조회 중 오류가 발생했습니다.");
        }
    }
}
