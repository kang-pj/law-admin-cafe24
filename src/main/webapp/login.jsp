<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>관리자 로그인</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Malgun Gothic', sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .login-container {
                background: white;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 400px;
            }

            h1 {
                text-align: center;
                color: #333;
                margin-bottom: 30px;
                font-size: 28px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                color: #555;
                font-weight: 500;
            }

            input[type="text"],
            input[type="password"] {
                width: 100%;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 5px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            input[type="text"]:focus,
            input[type="password"]:focus {
                outline: none;
                border-color: #667eea;
            }

            button {
                width: 100%;
                padding: 14px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.2s;
            }

            button:hover {
                transform: translateY(-2px);
            }

            button:active {
                transform: translateY(0);
            }

            .error-message {
                background: #fee;
                color: #c33;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 20px;
                text-align: center;
            }
            
            .remember-me {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .remember-me input[type="checkbox"] {
                width: auto;
                margin-right: 8px;
                cursor: pointer;
            }
            
            .remember-me label {
                margin: 0;
                font-weight: normal;
                cursor: pointer;
                user-select: none;
            }
        </style>
    </head>

    <body>
        <div class="login-container">
            <h1>관리자 로그인</h1>

            <% if (request.getParameter("error") !=null) { %>
                <div class="error-message">
                    아이디 또는 비밀번호가 올바르지 않습니다.
                </div>
                <% } %>

                    <form action="<%= request.getContextPath() %>/admin/login" method="post" id="loginForm">
                        <div class="form-group">
                            <label for="id">이메일</label>
                            <input type="text" id="id" name="id" required autofocus placeholder="admin@admin.com">
                        </div>

                        <div class="form-group">
                            <label for="password">비밀번호</label>
                            <input type="password" id="password" name="password" required>
                        </div>
                        
                        <div class="remember-me">
                            <input type="checkbox" id="rememberMe" name="rememberMe">
                            <label for="rememberMe">아이디 저장</label>
                        </div>

                        <button type="submit">로그인</button>
                    </form>
        </div>
        
        <script>
            // 페이지 로드 시 저장된 아이디 불러오기
            window.addEventListener('DOMContentLoaded', function() {
                const savedId = localStorage.getItem('savedAdminId');
                const rememberMe = localStorage.getItem('rememberMe') === 'true';
                
                if (savedId && rememberMe) {
                    document.getElementById('id').value = savedId;
                    document.getElementById('rememberMe').checked = true;
                }
            });
            
            // 폼 제출 시 아이디 저장 처리
            document.getElementById('loginForm').addEventListener('submit', function() {
                const idInput = document.getElementById('id');
                const rememberMeCheckbox = document.getElementById('rememberMe');
                
                if (rememberMeCheckbox.checked) {
                    localStorage.setItem('savedAdminId', idInput.value);
                    localStorage.setItem('rememberMe', 'true');
                } else {
                    localStorage.removeItem('savedAdminId');
                    localStorage.removeItem('rememberMe');
                }
            });
        </script>
    </body>

    </html>