<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin" %>
<%
    Admin sidebarAdmin = (Admin) session.getAttribute("admin");
    if (sidebarAdmin == null) {
        // 세션에 admin 객체가 없으면 개별 속성으로 생성
        sidebarAdmin = new Admin();
        sidebarAdmin.setEmail((String) session.getAttribute("adminId"));
        sidebarAdmin.setName((String) session.getAttribute("adminName"));
        sidebarAdmin.setRole((String) session.getAttribute("adminRole"));
        sidebarAdmin.setCompanyId((String) session.getAttribute("companyId"));
    }
    
    String sidebarRole = sidebarAdmin.getRole();
    boolean sidebarIsMaster = "MASTER".equals(sidebarRole);
    boolean sidebarIsAdmin = "ADMIN".equals(sidebarRole);
    boolean sidebarIsUser = "USER".equals(sidebarRole);
    
    // 현재 페이지 경로 확인
    String currentPath = request.getRequestURI();
    String contextPath = request.getContextPath();
%>
<!-- 사이드바 -->
<div class="sidebar">
    <ul class="sidebar-menu">
        <li>
            <a href="<%= contextPath %>/admin/dashboard" 
               class="<%= currentPath.contains("/dashboard") ? "active" : "" %>">
                <span class="icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <rect x="3" y="3" width="7" height="7"></rect>
                        <rect x="14" y="3" width="7" height="7"></rect>
                        <rect x="14" y="14" width="7" height="7"></rect>
                        <rect x="3" y="14" width="7" height="7"></rect>
                    </svg>
                </span>
                <span>대시보드</span>
            </a>
        </li>
        
        <li class="menu-group">
            <a class="menu-parent">
                <span class="icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <path d="M3 7h18M3 12h18M3 17h18"></path>
                    </svg>
                </span>
                <span>게시판</span>
            </a>
            <ul class="submenu">
                <li><a href="<%= contextPath %>/admin/inquiry/list?type=INQ" 
                       class="<%= currentPath.contains("/inquiry/") && "INQ".equals(request.getParameter("type")) ? "active" : "" %>">문의 게시판</a></li>
                <li><a href="<%= contextPath %>/admin/inquiry/list?type=SELF"
                       class="<%= currentPath.contains("/inquiry/") && "SELF".equals(request.getParameter("type")) ? "active" : "" %>">자가진단 게시판</a></li>
                <li><a href="<%= contextPath %>/admin/inquiry/list?type=KAKAO"
                       class="<%= currentPath.contains("/inquiry/") && "KAKAO".equals(request.getParameter("type")) ? "active" : "" %>">카카오 문의</a></li>
                <li><a href="<%= contextPath %>/admin/inquiry/list?type=EMAIL"
                       class="<%= currentPath.contains("/inquiry/") && "EMAIL".equals(request.getParameter("type")) ? "active" : "" %>">이메일 문의</a></li>
                <li><a href="<%= contextPath %>/admin/inquiry/list?type=ETC"
                       class="<%= currentPath.contains("/inquiry/") && "ETC".equals(request.getParameter("type")) ? "active" : "" %>">기타 문의</a></li>
            </ul>
        </li>
        
        <% if (!sidebarIsUser) { %>
        <li class="menu-group">
            <a class="menu-parent">
                <span class="icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <path d="M3 3v18h18"></path>
                        <path d="M18 17V9l-5 5-5-5v8"></path>
                    </svg>
                </span>
                <span>통계</span>
            </a>
            <ul class="submenu">
                <li><a href="#">접속 통계</a></li>
            </ul>
        </li>
        <% } %>
        
        <% if (sidebarIsMaster) { %>
        <li class="menu-group">
            <a class="menu-parent">
                <span class="icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M12 2v3M12 19v3M2 12h3M19 12h3"></path>
                    </svg>
                </span>
                <span>설정</span>
            </a>
            <ul class="submenu">
                <li><a href="#">업체 관리</a></li>
                <li><a href="#">관리자 설정</a></li>
            </ul>
        </li>
        <% } else if (sidebarIsAdmin) { %>
        <li class="menu-group">
            <a class="menu-parent">
                <span class="icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M12 2v3M12 19v3M2 12h3M19 12h3"></path>
                    </svg>
                </span>
                <span>설정</span>
            </a>
            <ul class="submenu">
                <li><a href="#">관리자 설정</a></li>
            </ul>
        </li>
        <% } %>
    </ul>
</div>
