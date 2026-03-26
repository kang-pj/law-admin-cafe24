package controller;

import dao.AdminDAO;
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

@WebServlet("/admin/change-password")
public class ChangePasswordServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        String adminId = (String) session.getAttribute("adminId");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // 입력값 검증
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "모든 필드를 입력해주세요.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }
        
        // 비밀번호 강도 검사 제거
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            AdminDAO dao = new AdminDAO(conn);
            
            // 현재 비밀번호 확인
            Admin admin = dao.getByEmail(adminId);
            if (admin == null) {
                request.setAttribute("error", "관리자 정보를 찾을 수 없습니다.");
                request.getRequestDispatcher("/change-password.jsp").forward(request, response);
                return;
            }
            
            // 현재 비밀번호 확인 (단순 문자열 비교)
            if (!currentPassword.equals(admin.getPassword())) {
                request.setAttribute("error", "현재 비밀번호가 올바르지 않습니다.");
                request.getRequestDispatcher("/change-password.jsp").forward(request, response);
                return;
            }
            
            // 새 비밀번호로 변경 (단순 저장)
            boolean success = dao.updatePassword(adminId, newPassword);
            
            if (success) {
                request.setAttribute("message", "비밀번호가 성공적으로 변경되었습니다.");
            } else {
                request.setAttribute("error", "비밀번호 변경 중 오류가 발생했습니다.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "시스템 오류가 발생했습니다.");
        }
        
        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
    }
}