<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Admin" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        admin = new Admin();
        admin.setEmail((String) session.getAttribute("adminId"));
        admin.setName((String) session.getAttribute("adminName"));
        admin.setRole((String) session.getAttribute("adminRole"));
        admin.setCompanyId((String) session.getAttribute("companyId"));
    }
    
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 변경</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css">
    <style>
        .password-form {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 500px;
            margin: 0 auto;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5568d3;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .alert {
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .password-requirements {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        .password-requirements ul {
            margin: 5px 0;
            padding-left: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    
    <div class="container">
        <%@ include file="/include/sidebar.jsp" %>
        
        <main class="main-content">
            <div class="content-header">
                <h1>비밀번호 변경</h1>
            </div>
            
            <div class="password-form">
                <% if (message != null) { %>
                <div class="alert alert-success">
                    <%= message %>
                </div>
                <% } %>
                
                <% if (error != null) { %>
                <div class="alert alert-danger">
                    <%= error %>
                </div>
                <% } %>
                
                <form method="post" action="<%= request.getContextPath() %>/admin/change-password">
                    <div class="form-group">
                        <label for="currentPassword">현재 비밀번호</label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="newPassword">새 비밀번호</label>
                        <input type="password" id="newPassword" name="newPassword" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">새 비밀번호 확인</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    
                    <div class="btn-group">
                        <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-secondary">취소</a>
                        <button type="submit" class="btn btn-primary">변경</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <script>
        document.querySelector('form').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.');
                return;
            }
        });
    </script>
</body>
</html>