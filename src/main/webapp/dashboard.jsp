<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminName = (String) session.getAttribute("adminName");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background: #f5f7fa;
        }
        
        .header {
            background: white;
            padding: 20px 40px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            color: #333;
            font-size: 24px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info span {
            color: #666;
        }
        
        .logout-btn {
            padding: 8px 20px;
            background: #dc3545;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .logout-btn:hover {
            background: #c82333;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card h3 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .card .number {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
            margin: 10px 0;
        }
        
        .menu-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .menu-section h2 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .menu-item {
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            text-align: center;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
        }
        
        .menu-item:hover {
            background: #667eea;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>관리자 대시보드</h1>
        <div class="user-info">
            <span><%= adminName %>님 환영합니다</span>
            <a href="<%= request.getContextPath() %>/admin/logout" class="logout-btn">로그아웃</a>
        </div>
    </div>
    
    <div class="container">
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
                <p>개</p>
            </div>
            
            <div class="card">
                <h3>문의사항</h3>
                <div class="number">0</div>
                <p>건</p>
            </div>
        </div>
        
        <div class="menu-section">
            <h2>관리 메뉴</h2>
            <div class="menu-grid">
                <a href="#" class="menu-item">회원 관리</a>
                <a href="#" class="menu-item">게시판 관리</a>
                <a href="#" class="menu-item">콘텐츠 관리</a>
                <a href="#" class="menu-item">통계</a>
                <a href="#" class="menu-item">설정</a>
                <a href="#" class="menu-item">시스템 관리</a>
            </div>
        </div>
    </div>
</body>
</html>
