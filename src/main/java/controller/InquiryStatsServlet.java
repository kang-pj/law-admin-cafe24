package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/inquiry/stats")
public class InquiryStatsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        // TODO: 실제 통계 데이터 조회 로직 구현
        // - 총 전문 수
        // - 처리 완료 수
        // - 처리 중 수
        // - 평균 처리 시간
        // - 월별 추이
        // - 유형별 통계
        // - 상태별 통계
        
        request.getRequestDispatcher("/inquiry-stats.jsp").forward(request, response);
    }
}
