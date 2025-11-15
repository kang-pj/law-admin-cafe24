<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminName = (String) session.getAttribute("adminName");
    String companyId = (String) session.getAttribute("companyId");
    String role = (String) session.getAttribute("adminRole");
    Boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");
    
    // 권한 체크
    boolean isMaster = "MASTER".equals(role);
    boolean isAdmin = "ADMIN".equals(role);
    boolean isUser = "USER".equals(role);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css">
    </style>
</head>
<body>
    <!-- 헤더 -->
    <div class="header">
        <div class="header-left">
            <h1>관리자 시스템</h1>
        </div>
        <div class="user-info">
            <span><%= adminName %></span>
            <% if (isMaster) { %>
                <span class="role-badge">최고관리자</span>
            <% } else if (isAdmin) { %>
                <span class="role-badge">운영관리자</span>
            <% } else { %>
                <span class="role-badge">사용자</span>
            <% } %>
            <a href="<%= request.getContextPath() %>/admin/logout" class="logout-btn">로그아웃</a>
        </div>
    </div>
    
    <!-- 사이드바 -->
    <div class="sidebar">
        <ul class="sidebar-menu">
            <!-- 대시보드 -->
            <li>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="active">
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
            
            <!-- 게시판 -->
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
                    <li><a href="#">문의 게시판</a></li>
                    <li><a href="#">자가 검진 게시판</a></li>
                    <li><a href="#">기타 게시판</a></li>
                </ul>
            </li>
            
            <!-- 통계 -->
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
            
            <!-- 설정 (일반 사용자는 숨김) -->
            <% if (!isUser) { %>
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
                    <% if (isMaster) { %>
                        <li><a href="#">업체 관리</a></li>
                    <% } %>
                    <% if (isAdmin || isMaster) { %>
                        <li><a href="#">관리자 설정</a></li>
                    <% } %>
                </ul>
            </li>
            <% } %>
        </ul>
    </div>
    
    <!-- 메인 컨텐츠 -->
    <div class="main-content">
        <h2 class="page-title">대시보드</h2>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>전체 회원</h3>
                <div class="number">0</div>
                <p>명</p>
            </div>
            
            <div class="card">
                <h3>오늘 방문자</h3>
                <div class="number">0</div>
                <p>명</p>
            </div>
            
            <div class="card">
                <h3>게시글</h3>
                <div class="number">0</div>
                <p>명</p>
            </div>
            
            <div class="card">
                <h3>문의사항</h3>
                <div class="number">0</div>
                <p>건</p>
            </div>
            
        </div>
        
        <!-- 게시판 미리보기 -->
        <div class="board-preview-section">
            <!-- 문의 게시판 -->
            <div class="board-preview">
                <div class="board-header">
                    <h3>문의 게시판</h3>
                    <a href="#" class="view-all-btn">전체보기 →</a>
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
                        <tr>
                            <td>5</td>
                            <td><a href="#">문의드립니다</a><span class="new-badge">N</span></td>
                            <td>홍길동</td>
                            <td>2024-01-15</td>
                        </tr>
                        <tr>
                            <td>4</td>
                            <td><a href="#">상담 요청합니다</a><span class="new-badge">N</span></td>
                            <td>김철수</td>
                            <td>2024-01-14</td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td><a href="#">예약 문의</a></td>
                            <td>이영희</td>
                            <td>2024-01-13</td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><a href="#">서비스 이용 문의</a></td>
                            <td>박민수</td>
                            <td>2024-01-12</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td><a href="#">기타 문의사항</a></td>
                            <td>최지훈</td>
                            <td>2024-01-11</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- 자가 검진 게시판 -->
            <div class="board-preview">
                <div class="board-header">
                    <h3>자가 검진 게시판</h3>
                    <a href="#" class="view-all-btn">전체보기 →</a>
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
                        <tr>
                            <td>5</td>
                            <td><a href="#">검진 결과 확인</a><span class="new-badge">N</span></td>
                            <td>홍길동</td>
                            <td>2024-01-15</td>
                        </tr>
                        <tr>
                            <td>4</td>
                            <td><a href="#">자가 진단 문의</a><span class="new-badge">N</span></td>
                            <td>김철수</td>
                            <td>2024-01-14</td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td><a href="#">검진 예약</a></td>
                            <td>이영희</td>
                            <td>2024-01-13</td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><a href="#">검진 항목 문의</a></td>
                            <td>박민수</td>
                            <td>2024-01-12</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td><a href="#">검진 후기</a></td>
                            <td>최지훈</td>
                            <td>2024-01-11</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- 기타 게시판 -->
            <div class="board-preview">
                <div class="board-header">
                    <h3>기타 게시판</h3>
                    <a href="#" class="view-all-btn">전체보기 →</a>
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
                        <tr>
                            <td>5</td>
                            <td><a href="#">공지사항</a><span class="new-badge">N</span></td>
                            <td>관리자</td>
                            <td>2024-01-15</td>
                        </tr>
                        <tr>
                            <td>4</td>
                            <td><a href="#">이벤트 안내</a><span class="new-badge">N</span></td>
                            <td>관리자</td>
                            <td>2024-01-14</td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td><a href="#">시스템 점검 안내</a></td>
                            <td>관리자</td>
                            <td>2024-01-13</td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><a href="#">서비스 개선 안내</a></td>
                            <td>관리자</td>
                            <td>2024-01-12</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td><a href="#">FAQ 업데이트</a></td>
                            <td>관리자</td>
                            <td>2024-01-11</td>
                        </tr>
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
