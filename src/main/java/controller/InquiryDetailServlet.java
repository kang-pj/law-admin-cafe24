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

@WebServlet("/admin/inquiry/detail")
public class InquiryDetailServlet extends HttpServlet {
    
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
        String idParam = request.getParameter("id");
        
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/inquiry/list");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            int id = Integer.parseInt(idParam);
            InquiryDAO dao = new InquiryDAO(conn);
            Inquiry inquiry = dao.getById(id);
            
            if (inquiry == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "게시글을 찾을 수 없습니다.");
                return;
            }
            
            // 권한 체크 (MASTER가 아닌 경우 자신의 업체만)
            if (!"MASTER".equals(admin.getRole())) {
                if (!admin.getCompanyId().equals(inquiry.getCompanyId())) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
                    return;
                }
            }
            
            // 읽음 처리
            if (!inquiry.isRead()) {
                dao.markAsRead(id);
                inquiry.setRead(true);
            }
            
            request.setAttribute("inquiry", inquiry);
            request.getRequestDispatcher("/inquiry-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터 조회 중 오류가 발생했습니다.");
        }
    }
    

}
