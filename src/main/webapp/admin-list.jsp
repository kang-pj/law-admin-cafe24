<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin, java.util.List, java.util.Map" %>
<%
    @SuppressWarnings("unchecked")
    List<Admin> adminList = (List<Admin>) request.getAttribute("adminList");
    @SuppressWarnings("unchecked")
    Map<String, String> companyMap = (Map<String, String>) request.getAttribute("companyMap");
    Admin currentAdmin = (Admin) session.getAttribute("admin");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 관리</title>
    <style>
        <%@ include file="/css/common.css" %>
    </style>
    <style>
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .search-box {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
        }
        
        .search-box input {
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            width: 300px;
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
        
        .list-table th:nth-child(1) { width: 5%; }
        .list-table th:nth-child(2) { width: 30%; text-align: left; }
        .list-table th:nth-child(3) { width: 15%; text-align: left; }
        .list-table th:nth-child(4) { width: 25%; text-align: left; }
        .list-table th:nth-child(5) { width: 8%; }
        .list-table th:nth-child(6) { width: 7%; }
        .list-table th:nth-child(7) { width: 10%; }
        
        .list-table td {
            padding: 14px 12px;
            font-size: 14px;
            color: #495057;
            border-bottom: 1px solid #f1f3f5;
            text-align: center;
        }
        
        .list-table td:nth-child(2),
        .list-table td:nth-child(3),
        .list-table td:nth-child(4) {
            text-align: left;
        }
        
        .list-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .role-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .role-master {
            background: #e7f5ff;
            color: #1971c2;
        }
        
        .role-admin {
            background: #fff3bf;
            color: #856404;
        }
        
        .role-user {
            background: #e2e3e5;
            color: #495057;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .status-active {
            background: #dcfce7;
            color: #15803d;
        }
        
        .status-inactive {
            background: #fee;
            color: #c33;
        }
        
        .action-buttons {
            display: flex;
            gap: 6px;
            justify-content: center;
        }
        
        .btn-toggle,
        .btn-delete {
            padding: 4px 10px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .btn-toggle {
            background: #fff3bf;
            color: #856404;
        }
        
        .btn-toggle:hover {
            background: #ffe69c;
        }
        
        .btn-delete {
            background: #ffe0e0;
            color: #c92a2a;
        }
        
        .btn-delete:hover {
            background: #ffc9c9;
        }
        
        .btn-add {
            padding: 10px 20px;
            background: #1971c2;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
        }
        
        .btn-add:hover {
            background: #1864ab;
        }
        
        /* 삭제 확인 모달 */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }
        
        .modal-overlay.active {
            display: flex;
        }
        
        .modal-content {
            background: white;
            border-radius: 12px;
            padding: 30px;
            width: 90%;
            max-width: 450px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease-out;
        }
        
        @keyframes modalSlideIn {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .modal-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }
        
        .modal-icon {
            width: 48px;
            height: 48px;
            background: #ffe0e0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        
        .modal-title {
            font-size: 20px;
            font-weight: 600;
            color: #212529;
        }
        
        .modal-body {
            margin-bottom: 24px;
        }
        
        .modal-warning {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 12px 16px;
            margin-bottom: 16px;
            border-radius: 4px;
            font-size: 14px;
            color: #856404;
        }
        
        .modal-admin-info {
            background: #f8f9fa;
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
        }
        
        .modal-input-label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #495057;
        }
        
        .modal-input {
            width: 100%;
            padding: 12px;
            border: 2px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s;
        }
        
        .modal-input:focus {
            outline: none;
            border-color: #c92a2a;
        }
        
        .modal-input.error {
            border-color: #c92a2a;
            background: #fff5f5;
        }
        
        .modal-error-message {
            color: #c92a2a;
            font-size: 13px;
            margin-top: 6px;
            display: none;
        }
        
        .modal-error-message.show {
            display: block;
        }
        
        .modal-footer {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        
        .modal-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .modal-btn-cancel {
            background: #e9ecef;
            color: #495057;
        }
        
        .modal-btn-cancel:hover {
            background: #dee2e6;
        }
        
        .modal-btn-delete {
            background: #c92a2a;
            color: white;
        }
        
        .modal-btn-delete:hover {
            background: #a61e1e;
        }
        
        .modal-btn-delete:disabled {
            background: #e9ecef;
            color: #adb5bd;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    <%@ include file="/include/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="content-header">
            <h2 class="page-title">관리자 관리</h2>
            <button class="btn-add" onclick="location.href='<%= request.getContextPath() %>/admin/user/add'">+ 관리자 추가</button>
        </div>
        
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="이메일, 이름, 업체명으로 검색..." autocomplete="off">
        </div>
        
        <div class="board-container">
            <div class="board-stats">
                전체 <strong id="totalCount"><%= adminList != null ? adminList.size() : 0 %></strong>명
            </div>
            
            <table class="list-table">
                <thead>
                    <tr>
                        <th>No</th>
                        <th>ID (이메일)</th>
                        <th>이름</th>
                        <th>소속 업체</th>
                        <th>권한</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="adminTableBody">
                    <% if (adminList != null && !adminList.isEmpty()) {
                        int no = 1;
                        for (Admin admin : adminList) { 
                            String companyName = companyMap.get(admin.getCompanyId());
                            if (companyName == null) companyName = "알 수 없음";
                    %>
                    <tr>
                        <td><%= no++ %></td>
                        <td><%= admin.getEmail() %></td>
                        <td><%= admin.getName() %></td>
                        <td><%= companyName %></td>
                        <td>
                            <span class="role-badge role-<%= admin.getRole().toLowerCase() %>">
                                <%= "MASTER".equals(admin.getRole()) ? "최고관리자" : 
                                    "ADMIN".equals(admin.getRole()) ? "관리자" : "일반" %>
                            </span>
                        </td>
                        <td>
                            <span class="status-badge status-<%= "Y".equals(admin.getIsActive()) ? "active" : "inactive" %>">
                                <%= "Y".equals(admin.getIsActive()) ? "활성" : "비활성" %>
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <% if (!admin.getEmail().equals(currentAdmin.getEmail())) { %>
                                <button class="btn-toggle" onclick="toggleAdmin('<%= admin.getEmail() %>')">
                                    <%= "Y".equals(admin.getIsActive()) ? "비활성" : "활성" %>
                                </button>
                                <button class="btn-delete" onclick="deleteAdmin('<%= admin.getEmail() %>', '<%= admin.getEmail() %>')">삭제</button>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 40px; color: #adb5bd;">
                            등록된 관리자가 없습니다.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- 삭제 확인 모달 -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-icon">⚠️</div>
                <div class="modal-title">관리자 삭제</div>
            </div>
            <div class="modal-body">
                <div class="modal-warning">
                    ⚠️ 이 작업은 되돌릴 수 없습니다. 신중하게 진행해주세요.
                </div>
                <div class="modal-admin-info">
                    삭제할 관리자: <strong id="deleteAdminEmail"></strong>
                </div>
                <label class="modal-input-label">
                    삭제를 진행하려면 아래에 <strong>"삭제"</strong> 를 입력하세요
                </label>
                <input type="text" class="modal-input" id="deleteConfirmInput" placeholder="삭제" autocomplete="off">
                <div class="modal-error-message" id="deleteErrorMessage">
                    "삭제" 를 정확히 입력해주세요
                </div>
            </div>
            <div class="modal-footer">
                <button class="modal-btn modal-btn-cancel" onclick="closeDeleteModal()">취소</button>
                <button class="modal-btn modal-btn-delete" id="confirmDeleteBtn" disabled onclick="confirmDelete()">삭제하기</button>
            </div>
        </div>
    </div>
    
    <script>
        let currentDeleteAdminId = null;
        
        // 클라이언트 사이드 검색
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const keyword = e.target.value.trim().toLowerCase();
            const rows = document.querySelectorAll('#adminTableBody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                if (row.cells.length < 7) {
                    row.style.display = 'none';
                    return;
                }
                
                const email = row.cells[1].textContent.toLowerCase();
                const name = row.cells[2].textContent.toLowerCase();
                const company = row.cells[3].textContent.toLowerCase();
                
                if (email.includes(keyword) || name.includes(keyword) || company.includes(keyword)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            document.getElementById('totalCount').textContent = visibleCount;
        });
        
        // 활성/비활성 토글
        function toggleAdmin(id) {
            if (!confirm('관리자의 활성 상태를 변경하시겠습니까?')) {
                return;
            }
            
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '<%= request.getContextPath() %>/admin/user/toggle', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function() {
                if (xhr.status === 200) {
                    alert('상태가 변경되었습니다.');
                    location.reload();
                } else {
                    alert('오류가 발생했습니다: ' + xhr.responseText);
                }
            };
            xhr.send('id=' + id);
        }
        
        // 삭제 모달 열기
        function deleteAdmin(id, email) {
            currentDeleteAdminId = id;
            document.getElementById('deleteAdminEmail').textContent = email;
            document.getElementById('deleteConfirmInput').value = '';
            document.getElementById('deleteErrorMessage').classList.remove('show');
            document.getElementById('deleteConfirmInput').classList.remove('error');
            document.getElementById('confirmDeleteBtn').disabled = true;
            document.getElementById('deleteModal').classList.add('active');
            
            setTimeout(() => {
                document.getElementById('deleteConfirmInput').focus();
            }, 100);
        }
        
        // 삭제 모달 닫기
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
            currentDeleteAdminId = null;
        }
        
        // 삭제 확인
        function confirmDelete() {
            if (!currentDeleteAdminId) return;
            
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '<%= request.getContextPath() %>/admin/user/delete', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function() {
                if (xhr.status === 200) {
                    alert('삭제되었습니다.');
                    location.reload();
                } else {
                    alert('오류가 발생했습니다: ' + xhr.responseText);
                }
            };
            xhr.send('id=' + currentDeleteAdminId);
        }
        
        // 입력값 실시간 검증
        document.getElementById('deleteConfirmInput').addEventListener('input', function(e) {
            const value = e.target.value;
            const confirmBtn = document.getElementById('confirmDeleteBtn');
            const errorMsg = document.getElementById('deleteErrorMessage');
            const input = e.target;
            
            if (value === '삭제') {
                confirmBtn.disabled = false;
                errorMsg.classList.remove('show');
                input.classList.remove('error');
            } else {
                confirmBtn.disabled = true;
                if (value.length > 0) {
                    errorMsg.classList.add('show');
                    input.classList.add('error');
                } else {
                    errorMsg.classList.remove('show');
                    input.classList.remove('error');
                }
            }
        });
        
        // Enter 키로 삭제 실행
        document.getElementById('deleteConfirmInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !document.getElementById('confirmDeleteBtn').disabled) {
                confirmDelete();
            }
        });
        
        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && document.getElementById('deleteModal').classList.contains('active')) {
                closeDeleteModal();
            }
        });
        
        // 모달 배경 클릭시 닫기
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeDeleteModal();
            }
        });
    </script>
</body>
</html>
