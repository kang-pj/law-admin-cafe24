<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Admin, model.Company, java.util.List" %>
<%
    Admin currentAdmin = (Admin) request.getAttribute("currentAdmin");
    Admin admin = (Admin) request.getAttribute("admin");
    String mode = (String) request.getAttribute("mode");
    @SuppressWarnings("unchecked")
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    boolean isEdit = "edit".equals(mode);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "관리자 수정" : "관리자 추가" %></title>
    <style>
        <%@ include file="/css/common.css" %>
    </style>
    <style>
        .form-container {
            max-width: 700px;
            background: white;
            padding: 30px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #495057;
            font-size: 14px;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #0d6efd;
        }
        
        .form-group input[readonly] {
            background: #e9ecef;
            cursor: not-allowed;
        }
        
        .form-group small {
            display: block;
            margin-top: 4px;
            color: #6c757d;
            font-size: 12px;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: #0d6efd;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0b5ed7;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5c636a;
        }
        
        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-success {
            background: #d1e7dd;
            color: #0f5132;
            border: 1px solid #badbcc;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #842029;
            border: 1px solid #f5c2c7;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 12px;
        }
        
        .success-message {
            color: #198754;
            font-size: 12px;
        }
        
        .form-group input.error {
            border-color: #dc3545;
        }
        
        .form-group input.success {
            border-color: #198754;
        }
    </style>
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    <%@ include file="/include/sidebar.jsp" %>
    
    <div class="main-content">
        <h2 class="page-title"><%= isEdit ? "관리자 수정" : "관리자 추가" %></h2>
        
        <div class="form-container">
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">저장되었습니다.</div>
            <% } %>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">저장 중 오류가 발생했습니다.</div>
            <% } %>
            
            <form method="post" id="adminForm">
                <input type="hidden" name="mode" value="<%= mode %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= admin.getEmail() %>">
                <% } %>
                
                <div class="form-group">
                    <label for="id">이메일 (ID) *</label>
                    <input type="email" id="id" name="id" 
                           value="<%= isEdit ? admin.getEmail() : "" %>" 
                           <%= isEdit ? "readonly" : "required" %>>
                    <% if (isEdit) { %>
                        <small>이메일은 수정할 수 없습니다.</small>
                    <% } else { %>
                        <small id="email_message"></small>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호 <%= isEdit ? "" : "*" %></label>
                    <input type="password" id="password" name="password" 
                           <%= isEdit ? "" : "required" %>>
                    <% if (isEdit) { %>
                        <small>변경하지 않으려면 비워두세요.</small>
                    <% } %>
                </div>
                
                <% if (!isEdit) { %>
                <div class="form-group">
                    <label for="password_confirm">비밀번호 확인 *</label>
                    <input type="password" id="password_confirm" name="password_confirm" required>
                    <small id="password_match_message" style="display: none;"></small>
                </div>
                <% } %>
                
                <div class="form-group">
                    <label for="name">이름 *</label>
                    <input type="text" id="name" name="name" 
                           value="<%= isEdit ? admin.getName() : "" %>" required>
                </div>
                
                <div class="form-group">
                    <label for="role">권한 *</label>
                    <% if ("MASTER".equals(currentAdmin.getRole())) { %>
                        <select id="role" name="role" required>
                            <option value="">선택하세요</option>
                            <option value="MASTER" <%= isEdit && "MASTER".equals(admin.getRole()) ? "selected" : "" %>>최고 관리자</option>
                            <option value="ADMIN" <%= isEdit && "ADMIN".equals(admin.getRole()) ? "selected" : "" %>>관리자</option>
                            <option value="USER" <%= isEdit && "USER".equals(admin.getRole()) ? "selected" : "" %>>일반</option>
                        </select>
                    <% } else { %>
                        <input type="text" value="일반" readonly>
                        <input type="hidden" name="role" value="USER">
                        <small>관리자는 일반 사용자만 생성할 수 있습니다.</small>
                    <% } %>
                </div>
                
                <% if ("MASTER".equals(currentAdmin.getRole())) { %>
                <div class="form-group">
                    <label for="company_id">소속 업체 *</label>
                    <select id="company_id" name="company_id" required>
                        <option value="">선택하세요</option>
                        <% for (Company company : companies) { %>
                            <option value="<%= company.getId() %>" 
                                    <%= isEdit && company.getId().equals(admin.getCompanyId()) ? "selected" : "" %>>
                                <%= company.getName() %>
                            </option>
                        <% } %>
                    </select>
                </div>
                <% } %>
                
                <div class="form-group">
                    <label for="is_active">활성 상태 *</label>
                    <select id="is_active" name="is_active" required>
                        <option value="Y" <%= isEdit && "Y".equals(admin.getIsActive()) ? "selected" : "selected" %>>활성</option>
                        <option value="N" <%= isEdit && "N".equals(admin.getIsActive()) ? "selected" : "" %>>비활성</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">저장</button>
                    <a href="<%= request.getContextPath() %>/admin/user/list" class="btn btn-secondary">취소</a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // 이메일 형식 검증
        const emailInput = document.getElementById('id');
        const emailMessage = document.getElementById('email_message');
        
        if (emailInput && !emailInput.readOnly) {
            emailInput.addEventListener('input', function() {
                const email = this.value.trim();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                
                if (email === '') {
                    emailMessage.textContent = '';
                    emailMessage.className = '';
                    this.classList.remove('error', 'success');
                } else if (emailRegex.test(email)) {
                    emailMessage.textContent = '✓ 올바른 이메일 형식입니다.';
                    emailMessage.className = 'success-message';
                    this.classList.remove('error');
                    this.classList.add('success');
                } else {
                    emailMessage.textContent = '✗ 올바른 이메일 형식이 아닙니다.';
                    emailMessage.className = 'error-message';
                    this.classList.remove('success');
                    this.classList.add('error');
                }
            });
        }
        
        // 비밀번호 확인 검증
        const passwordInput = document.getElementById('password');
        const passwordConfirmInput = document.getElementById('password_confirm');
        const passwordMatchMessage = document.getElementById('password_match_message');
        
        if (passwordConfirmInput) {
            function checkPasswordMatch() {
                const password = passwordInput.value;
                const passwordConfirm = passwordConfirmInput.value;
                
                if (passwordConfirm === '') {
                    passwordMatchMessage.style.display = 'none';
                    passwordConfirmInput.classList.remove('error', 'success');
                } else if (password === passwordConfirm) {
                    passwordMatchMessage.textContent = '✓ 비밀번호가 일치합니다.';
                    passwordMatchMessage.className = 'success-message';
                    passwordMatchMessage.style.display = 'block';
                    passwordConfirmInput.classList.remove('error');
                    passwordConfirmInput.classList.add('success');
                } else {
                    passwordMatchMessage.textContent = '✗ 비밀번호가 일치하지 않습니다.';
                    passwordMatchMessage.className = 'error-message';
                    passwordMatchMessage.style.display = 'block';
                    passwordConfirmInput.classList.remove('success');
                    passwordConfirmInput.classList.add('error');
                }
            }
            
            passwordInput.addEventListener('input', checkPasswordMatch);
            passwordConfirmInput.addEventListener('input', checkPasswordMatch);
        }
        
        // 폼 제출 검증
        document.getElementById('adminForm').addEventListener('submit', function(e) {
            const emailInput = document.getElementById('id');
            
            // 이메일 검증 (추가 모드일 때만)
            if (emailInput && !emailInput.readOnly) {
                const email = emailInput.value.trim();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                
                if (!emailRegex.test(email)) {
                    e.preventDefault();
                    alert('올바른 이메일 형식을 입력해주세요.');
                    emailInput.focus();
                    return false;
                }
            }
            
            // 비밀번호 확인 검증 (추가 모드일 때만)
            if (passwordConfirmInput) {
                const password = passwordInput.value;
                const passwordConfirm = passwordConfirmInput.value;
                
                if (password !== passwordConfirm) {
                    e.preventDefault();
                    alert('비밀번호가 일치하지 않습니다.');
                    passwordConfirmInput.focus();
                    return false;
                }
                
                if (password.length < 4) {
                    e.preventDefault();
                    alert('비밀번호는 최소 4자 이상이어야 합니다.');
                    passwordInput.focus();
                    return false;
                }
            }
            
            return true;
        });
    </script>
</body>
</html>
