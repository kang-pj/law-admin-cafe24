<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin, model.Inquiry, java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Inquiry> inquiryList = (List<Inquiry>) request.getAttribute("inquiryList");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    String type = (String) request.getAttribute("type");
    
    String pageTitle = "전체 게시판";
    if ("INQ".equals(type)) pageTitle = "문의 게시판";
    else if ("SELF".equals(type)) pageTitle = "자가진단 게시판";
    else if ("KAKAO".equals(type)) pageTitle = "카카오 문의";
    else if ("EMAIL".equals(type)) pageTitle = "이메일 문의";
    else if ("ETC".equals(type)) pageTitle = "기타 문의";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .filter-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
        }
        
        .filter-tabs a {
            padding: 8px 16px;
            background: white;
            color: #495057;
            text-decoration: none;
            border-radius: 6px;
            border: 1px solid #dee2e6;
            font-size: 14px;
            transition: all 0.2s;
        }
        
        .filter-tabs a:hover {
            background: #f8f9fa;
        }
        
        .filter-tabs a.active {
            background: #1971c2;
            color: white;
            border-color: #1971c2;
        }
        
        .search-box {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
        }
        
        .search-box select,
        .search-box input {
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .search-box input {
            width: 300px;
        }
        
        .search-box button {
            padding: 8px 16px;
            background: #495057;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        
        .search-box button:hover {
            background: #343a40;
        }
        
        .board-container {
            background: white;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            overflow: hidden;
        }
        
        .board-stats {
            padding: 12px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            font-size: 13px;
            color: #6c757d;
        }
        
        .list-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .list-table thead {
            background: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
        }
        
        .list-table th {
            padding: 14px 12px;
            font-size: 13px;
            font-weight: 600;
            color: #495057;
            text-align: center;
        }
        
        .list-table th:nth-child(1) { width: 80px; }
        .list-table th:nth-child(2) { width: 100px; }
        .list-table th:nth-child(3) { text-align: left; }
        .list-table th:nth-child(4) { width: 120px; text-align: left; }
        .list-table th:nth-child(5) { width: 100px; }
        .list-table th:nth-child(6) { width: 100px; }
        .list-table th:nth-child(7) { width: 120px; }
        
        .list-table td {
            padding: 14px 12px;
            font-size: 14px;
            color: #495057;
            border-bottom: 1px solid #f1f3f5;
            text-align: center;
        }
        
        .list-table td:nth-child(3) {
            text-align: left;
        }
        
        .list-table td:nth-child(4) {
            text-align: left;
        }
        
        .list-table td a {
            color: #212529;
            text-decoration: none;
            transition: color 0.2s;
        }
        
        .list-table td a:hover {
            color: #1971c2;
        }
        
        .list-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .type-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 500;
        }
        
        .type-inq { background: #e7f5ff; color: #1971c2; }
        .type-self { background: #fff3cd; color: #856404; }
        .type-kakao { background: #fff3bf; color: #856404; }
        .type-email { background: #d1e7dd; color: #0f5132; }
        .type-etc { background: #e2e3e5; color: #383d41; }
        
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            border: 1.5px solid;
        }
        
        .status-pending { 
            background: #fff9e6; 
            color: #d97706; 
            border-color: #fbbf24;
        }
        .status-processing { 
            background: #e0f2fe; 
            color: #0369a1; 
            border-color: #38bdf8;
        }
        .status-completed { 
            background: #dcfce7; 
            color: #15803d; 
            border-color: #4ade80;
        }
        
        .read-badge {
            font-size: 12px;
            color: #6c757d;
        }
        
        .read-badge.unread {
            color: #dc3545;
            font-weight: 600;
        }
        
        .memo-count {
            display: inline-block;
            margin-left: 6px;
            color: #1971c2;
            font-size: 12px;
            font-weight: 600;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 4px;
            padding: 20px;
        }
        
        .pagination a,
        .pagination span {
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            color: #495057;
            text-decoration: none;
            font-size: 14px;
        }
        
        .pagination a:hover {
            background: #f8f9fa;
        }
        
        .pagination .active {
            background: #1971c2;
            color: white;
            border-color: #1971c2;
        }
    </style>
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    <%@ include file="/include/sidebar.jsp" %>
    
    <!-- 메인 컨텐츠 -->
    <div class="main-content">
        <div class="content-header">
            <h2 class="page-title"><%= pageTitle %></h2>
        </div>
        
        <!-- 필터 탭 -->
        <div class="filter-tabs">
            <a href="<%= request.getContextPath() %>/admin/inquiry/list" 
               class="<%= type == null ? "active" : "" %>">전체</a>
            <a href="<%= request.getContextPath() %>/admin/inquiry/list?type=INQ" 
               class="<%= "INQ".equals(type) ? "active" : "" %>">문의</a>
            <a href="<%= request.getContextPath() %>/admin/inquiry/list?type=SELF" 
               class="<%= "SELF".equals(type) ? "active" : "" %>">자가진단</a>
            <a href="<%= request.getContextPath() %>/admin/inquiry/list?type=KAKAO" 
               class="<%= "KAKAO".equals(type) ? "active" : "" %>">카카오</a>
            <a href="<%= request.getContextPath() %>/admin/inquiry/list?type=EMAIL" 
               class="<%= "EMAIL".equals(type) ? "active" : "" %>">이메일</a>
            <a href="<%= request.getContextPath() %>/admin/inquiry/list?type=ETC" 
               class="<%= "ETC".equals(type) ? "active" : "" %>">기타</a>
        </div>
        
        <!-- MASTER 전용 업체 필터 -->
        <% if ("MASTER".equals(admin.getRole())) { 
            String companyFilter = request.getParameter("company");
        %>
        <div class="filter-tabs" style="margin-bottom: 16px;">
            <a href="<%= request.getContextPath() %>/admin/inquiry/list<%= type != null ? "?type=" + type : "" %>" 
               class="<%= companyFilter == null ? "active" : "" %>">전체 업체</a>
            <a href="<%= request.getContextPath() %>/admin/inquiry/list?<%= type != null ? "type=" + type + "&" : "" %>company=COMP001" 
               class="<%= "COMP001".equals(companyFilter) ? "active" : "" %>">법무법인 A</a>
            <a href="<%= request.getContextPath() %>/admin/inquiry/list?<%= type != null ? "type=" + type + "&" : "" %>company=COMP002" 
               class="<%= "COMP002".equals(companyFilter) ? "active" : "" %>">법무법인 B</a>
        </div>
        <% } %>
        
        <!-- 검색 -->
        <div class="search-box">
            <select>
                <option value="all">전체</option>
                <option value="title">제목</option>
                <option value="name">작성자</option>
                <option value="email">이메일</option>
            </select>
            <input type="text" placeholder="검색어를 입력하세요">
            <button>검색</button>
        </div>
        
        <!-- 게시판 -->
        <div class="board-container">
            <div class="board-stats">
                전체 <strong><%= totalCount %></strong>건
            </div>
            
            <table class="list-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>타입</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>상태</th>
                        <th>읽음</th>
                        <th>작성일</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (inquiryList != null && !inquiryList.isEmpty()) {
                        for (Inquiry inq : inquiryList) { %>
                    <tr>
                        <td><%= inq.getId() %></td>
                        <td>
                            <span class="type-badge type-<%= inq.getType().toLowerCase() %>">
                                <%= inq.getTypeLabel() %>
                            </span>
                        </td>
                        <td>
                            <a href="<%= request.getContextPath() %>/admin/inquiry/detail?id=<%= inq.getId() %>">
                                <%= inq.getTitle() %>
                                <% if (inq.getMemoCount() > 0) { %>
                                    <span class="memo-count">[<%= inq.getMemoCount() %>]</span>
                                <% } %>
                            </a>
                        </td>
                        <td><%= inq.getName() %></td>
                        <td>
                            <span class="status-badge status-<%= inq.getStatus() %>">
                                <%= inq.getStatusLabel() %>
                            </span>
                        </td>
                        <td>
                            <span class="read-badge <%= !inq.isRead() ? "unread" : "" %>">
                                <%= inq.isRead() ? "읽음" : "미읽음" %>
                            </span>
                        </td>
                        <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(inq.getCreatedAt()) %></td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 40px; color: #adb5bd;">
                            등록된 게시글이 없습니다.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            
            <!-- 페이징 -->
            <% if (totalPages > 0) { 
                String companyFilter = request.getParameter("company");
                String pageParams = "";
                if (type != null) pageParams += "type=" + type;
                if (companyFilter != null) {
                    if (!pageParams.isEmpty()) pageParams += "&";
                    pageParams += "company=" + companyFilter;
                }
                if (!pageParams.isEmpty()) pageParams += "&";
            %>
            <div class="pagination">
                <% if (currentPage > 1) { %>
                    <a href="?<%= pageParams %>page=<%= currentPage - 1 %>">&laquo;</a>
                <% } %>
                
                <% for (int i = 1; i <= totalPages; i++) { 
                    if (i == currentPage) { %>
                        <span class="active"><%= i %></span>
                    <% } else { %>
                        <a href="?<%= pageParams %>page=<%= i %>"><%= i %></a>
                    <% }
                } %>
                
                <% if (currentPage < totalPages) { %>
                    <a href="?<%= pageParams %>page=<%= currentPage + 1 %>">&raquo;</a>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>
