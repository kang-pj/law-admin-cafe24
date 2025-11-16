<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Company, java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Company> companyList = (List<Company>) request.getAttribute("companyList");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>업체 관리</title>
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
        
        .list-table th:nth-child(1) { width: 10%; }
        .list-table th:nth-child(2) { width: 50%; text-align: left; }
        .list-table th:nth-child(3) { width: 10%; }
        .list-table th:nth-child(4) { width: 15%; }
        .list-table th:nth-child(5) { width: 15%; }
        
        .list-table td {
            padding: 14px 12px;
            font-size: 14px;
            color: #495057;
            border-bottom: 1px solid #f1f3f5;
            text-align: center;
        }
        
        .list-table td:nth-child(2) {
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
        
        .company-id {
            font-family: 'Courier New', monospace;
            color: #1971c2;
            font-weight: 500;
        }
        
        .company-name {
            font-weight: 500;
            color: #212529;
        }
        
        .action-buttons {
            display: flex;
            gap: 6px;
            justify-content: center;
        }
        
        .btn-edit,
        .btn-delete {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .btn-edit {
            background: #e7f5ff;
            color: #1971c2;
        }
        
        .btn-edit:hover {
            background: #d0ebff;
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
        
        .modal-company-info {
            background: #f8f9fa;
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
        }
        
        .modal-company-info strong {
            color: #1971c2;
            font-family: 'Courier New', monospace;
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
    
    <!-- 메인 컨텐츠 -->
    <div class="main-content">
        <div class="content-header">
            <h2 class="page-title">업체 관리</h2>
            <button class="btn-add" onclick="location.href='<%= request.getContextPath() %>/admin/company/add'">+ 업체 추가</button>
        </div>
        
        <!-- 검색창 -->
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="업체 ID 또는 업체명으로 검색..." autocomplete="off">
        </div>
        
        <!-- 업체 목록 -->
        <div class="board-container">
            <div class="board-stats">
                전체 <strong id="totalCount"><%= companyList != null ? companyList.size() : 0 %></strong>개 업체
            </div>
            
            <table class="list-table">
                <thead>
                    <tr>
                        <th>업체 ID</th>
                        <th>업체명</th>
                        <th>관리자 수</th>
                        <th>등록일</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="companyTableBody">
                    <% if (companyList != null && !companyList.isEmpty()) {
                        for (Company company : companyList) { %>
                    <tr>
                        <td><span class="company-id"><%= company.getId() %></span></td>
                        <td><span class="company-name"><%= company.getName() %></span></td>
                        <td><%= company.getDescription() != null ? company.getDescription() : "0" %>명</td>
                        <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(company.getCreatedAt()) %></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-edit" onclick="location.href='<%= request.getContextPath() %>/admin/company/edit?id=<%= company.getId() %>'">수정</button>
                                <button class="btn-delete" onclick="deleteCompany('<%= company.getId() %>')">삭제</button>
                            </div>
                        </td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 40px; color: #adb5bd;">
                            등록된 업체가 없습니다.
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
                <div class="modal-title">업체 삭제</div>
            </div>
            <div class="modal-body">
                <div class="modal-warning">
                    ⚠️ 이 작업은 되돌릴 수 없습니다. 신중하게 진행해주세요.
                </div>
                <div class="modal-company-info">
                    삭제할 업체: <strong id="deleteCompanyId"></strong>
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
    
    <style>
        /* 토스트 메시지 */
        .toast {
            position: fixed;
            top: 80px;
            right: 20px;
            background: #28a745;
            color: white;
            padding: 16px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 10000;
            animation: slideIn 0.3s ease-out;
            min-width: 300px;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }
        
        .toast.hiding {
            animation: slideOut 0.3s ease-out forwards;
        }
    </style>
    
    <script>
        let currentDeleteCompanyId = null;
        
        // 토스트 메시지 표시
        function showToast(message) {
            const toast = document.createElement('div');
            toast.className = 'toast';
            toast.innerHTML = `
                <span style="font-size: 20px;">✓</span>
                <span style="flex: 1; font-size: 14px; font-weight: 500;">${message}</span>
            `;
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.classList.add('hiding');
                setTimeout(() => {
                    document.body.removeChild(toast);
                }, 300);
            }, 3000);
        }
        
        // URL 파라미터 확인하여 토스트 표시
        window.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success') === '1') {
                showToast('저장되었습니다.');
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });
        
        // 클라이언트 사이드 검색 기능
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const keyword = e.target.value.trim().toLowerCase();
            const rows = document.querySelectorAll('#companyTableBody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                // 빈 행은 제외
                if (row.cells.length < 5) {
                    row.style.display = 'none';
                    return;
                }
                
                const companyId = row.cells[0].textContent.toLowerCase();
                const companyName = row.cells[1].textContent.toLowerCase();
                
                if (companyId.includes(keyword) || companyName.includes(keyword)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // 검색 결과 카운트 업데이트
            document.getElementById('totalCount').textContent = visibleCount;
            
            // 검색 결과가 없을 때
            if (visibleCount === 0 && keyword !== '') {
                const tbody = document.getElementById('companyTableBody');
                const emptyRow = tbody.querySelector('.empty-row');
                if (!emptyRow) {
                    const tr = document.createElement('tr');
                    tr.className = 'empty-row';
                    tr.innerHTML = '<td colspan="5" style="text-align: center; padding: 40px; color: #adb5bd;">검색 결과가 없습니다.</td>';
                    tbody.appendChild(tr);
                }
            } else {
                const emptyRow = document.querySelector('.empty-row');
                if (emptyRow) {
                    emptyRow.remove();
                }
            }
        });
        
        function deleteCompany(companyId) {
            currentDeleteCompanyId = companyId;
            document.getElementById('deleteCompanyId').textContent = companyId;
            document.getElementById('deleteConfirmInput').value = '';
            document.getElementById('deleteErrorMessage').classList.remove('show');
            document.getElementById('deleteConfirmInput').classList.remove('error');
            document.getElementById('confirmDeleteBtn').disabled = true;
            document.getElementById('deleteModal').classList.add('active');
            
            // 모달이 열리면 입력창에 포커스
            setTimeout(() => {
                document.getElementById('deleteConfirmInput').focus();
            }, 100);
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
            currentDeleteCompanyId = null;
        }
        
        function confirmDelete() {
            if (currentDeleteCompanyId) {
                // 실제 구현시 서버로 삭제 요청
                alert('삭제되었습니다.');
                location.reload();
            }
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
