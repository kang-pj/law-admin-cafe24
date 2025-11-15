<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin" %>
<%
    Admin headerAdmin = (Admin) session.getAttribute("admin");
    if (headerAdmin == null) {
        // 세션에 admin 객체가 없으면 개별 속성으로 생성
        headerAdmin = new Admin();
        headerAdmin.setEmail((String) session.getAttribute("adminId"));
        headerAdmin.setName((String) session.getAttribute("adminName"));
        headerAdmin.setRole((String) session.getAttribute("adminRole"));
        headerAdmin.setCompanyId((String) session.getAttribute("companyId"));
    }
    
    String headerAdminName = headerAdmin.getName();
    String headerRole = headerAdmin.getRole();
    boolean headerIsMaster = "MASTER".equals(headerRole);
    boolean headerIsAdmin = "ADMIN".equals(headerRole);
%>
<!-- 헤더 -->
<div class="header">
    <div class="header-left">
        <h1>관리자 시스템</h1>
    </div>
    <div class="user-info">
        <span><%= headerAdminName %></span>
        <% if (headerIsMaster) { %>
            <span class="role-badge">최고관리자</span>
        <% } else if (headerIsAdmin) { %>
            <span class="role-badge">운영관리자</span>
        <% } else { %>
            <span class="role-badge">일반사용자</span>
        <% } %>
        <a href="<%= request.getContextPath() %>/admin/logout" class="logout-btn">로그아웃</a>
    </div>
</div>
