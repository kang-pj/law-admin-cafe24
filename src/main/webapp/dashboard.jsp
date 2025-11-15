<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Inquiry, java.util.List" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    String companyId = (String) session.getAttribute("companyId");
    String role = (String) session.getAttribute("adminRole");
    Boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");
    
    // 권한 체크
    boolean isMaster = "MASTER".equals(role);
    boolean isAdmin = "ADMIN".equals(role);
    boolean isUser = "USER".equals(role);
    
    // 데이터 가져오기
    @SuppressWarnings("unchecked")
    List<Inquiry> recentInquiries = (List<Inquiry>) request.getAttribute("recentInquiries");
    @SuppressWarnings("unchecked")
    List<Inquiry> recentSelfDiagnosis = (List<Inquiry>) request.getAttribute("recentSelfDiagnosis");
    @SuppressWarnings("unchecked")
    List<Inquiry> recentOthers = (List<Inquiry>) request.getAttribute("recentOthers");
    
    Integer totalInquiries = (Integer) request.getAttribute("totalInquiries");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer processingCount = (Integer) request.getAttribute("processingCount");
    Integer todayCount = (Integer) request.getAttribute("todayCount");
    
    if (totalInquiries == null) totalInquiries = 0;
    if (pendingCount == null) pendingCount = 0;
    if (processingCount == null) processingCount = 0;
    if (todayCount == null) todayCount = 0;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css">
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    <%@ include file="/include/sidebar.jsp" %>
    
    <!-- 메인 컨텐츠 -->
    <div class="main-content">
        <h2 class="page-title">대시보드</h2>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>전체 문의</h3>
                <div class="number"><%= totalInquiries %></div>
                <p>건</p>
            </div>
            
            <div class="card">
                <h3>오늘 문의</h3>
                <div class="number"><%= todayCount %></div>
                <p>건</p>
            </div>
            
            <div class="card">
                <h3>대기중</h3>
                <div class="number"><%= pendingCount %></div>
                <p>건</p>
            </div>
            
            <div class="card">
                <h3>처리중</h3>
                <div class="number"><%= processingCount %></div>
                <p>건</p>
            </div>
            
        </div>
        
        <!-- 게시판 미리보기 -->
        <div class="board-preview-section">
            <!-- 문의 게시판 -->
            <div class="board-preview">
                <div class="board-header">
                    <h3>문의 게시판</h3>
                    <a href="<%= request.getContextPath() %>/admin/inquiry/list?type=INQ" class="view-all-btn">전체보기 →</a>
                </div>
                <table class="board-table">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentInquiries != null && !recentInquiries.isEmpty()) {
                            for (Inquiry inq : recentInquiries) { %>
                        <tr>
                            <td><%= inq.getId() %></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/admin/inquiry/detail?id=<%= inq.getId() %>">
                                    <%= inq.getTitle() %>
                                </a>
                                <% if (!inq.isRead()) { %>
                                    <span class="new-badge">N</span>
                                <% } %>
                            </td>
                            <td><%= inq.getName() %></td>
                            <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(inq.getCreatedAt()) %></td>
                        </tr>
                        <% }
                        } else { %>
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 20px; color: #adb5bd;">
                                등록된 게시글이 없습니다.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- 자가 검진 게시판 -->
            <div class="board-preview">
                <div class="board-header">
                    <h3>자가진단 게시판</h3>
                    <a href="<%= request.getContextPath() %>/admin/inquiry/list?type=SELF" class="view-all-btn">전체보기 →</a>
                </div>
                <table class="board-table">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentSelfDiagnosis != null && !recentSelfDiagnosis.isEmpty()) {
                            for (Inquiry inq : recentSelfDiagnosis) { %>
                        <tr>
                            <td><%= inq.getId() %></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/admin/inquiry/detail?id=<%= inq.getId() %>">
                                    <%= inq.getTitle() %>
                                </a>
                                <% if (!inq.isRead()) { %>
                                    <span class="new-badge">N</span>
                                <% } %>
                            </td>
                            <td><%= inq.getName() %></td>
                            <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(inq.getCreatedAt()) %></td>
                        </tr>
                        <% }
                        } else { %>
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 20px; color: #adb5bd;">
                                등록된 게시글이 없습니다.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- 기타 문의 -->
            <div class="board-preview">
                <div class="board-header">
                    <h3>기타 문의</h3>
                    <a href="<%= request.getContextPath() %>/admin/inquiry/list?type=ETC" class="view-all-btn">전체보기 →</a>
                </div>
                <table class="board-table">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentOthers != null && !recentOthers.isEmpty()) {
                            for (Inquiry inq : recentOthers) { %>
                        <tr>
                            <td><%= inq.getId() %></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/admin/inquiry/detail?id=<%= inq.getId() %>">
                                    <%= inq.getTitle() %>
                                </a>
                                <% if (!inq.isRead()) { %>
                                    <span class="new-badge">N</span>
                                <% } %>
                            </td>
                            <td><%= inq.getName() %></td>
                            <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(inq.getCreatedAt()) %></td>
                        </tr>
                        <% }
                        } else { %>
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 20px; color: #adb5bd;">
                                등록된 게시글이 없습니다.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- 바로가기 -->
        <div class="dashboard-grid" style="margin-top: 24px;">
            <a href="#" class="card card-link">
                <h3>접속 통계</h3>
                <p>바로가기 →</p>
            </a>
            
            <% if (isAdmin || isMaster) { %>
            <a href="#" class="card card-link">
                <h3>관리자 설정</h3>
                <p>바로가기 →</p>
            </a>
            <% } %>
            
            <% if (isMaster) { %>
            <a href="#" class="card card-link">
                <h3>업체 관리</h3>
                <p>바로가기 →</p>
            </a>
            <% } %>
        </div>
    </div>
</body>
</html>
