<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin, model.Inquiry" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Inquiry inquiry = (Inquiry) request.getAttribute("inquiry");
    if (inquiry == null) {
        response.sendRedirect(request.getContextPath() + "/admin/inquiry/list");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= inquiry.getTypeLabel() %> 상세</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css">
    <style>
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .btn-list {
            padding: 8px 16px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            transition: background 0.2s;
        }
        
        .btn-list:hover {
            background: #5a6268;
        }
        
        .detail-container {
            background: white;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            overflow: hidden;
        }
        
        .author-info {
            padding: 0;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }
        
        .info-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .info-table tr {
            border-bottom: 1px solid #e9ecef;
        }
        
        .info-table tr:last-child {
            border-bottom: none;
        }
        
        .info-table th {
            background: white;
            padding: 12px 16px;
            font-size: 13px;
            color: #495057;
            font-weight: 600;
            text-align: left;
            width: 120px;
        }
        
        .info-table td {
            background: white;
            padding: 12px 16px;
            font-size: 14px;
            color: #212529;
        }
        
        .content-section {
            padding: 24px;
        }
        
        .content-title {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 8px;
        }
        
        .content-meta {
            display: flex;
            gap: 16px;
            font-size: 13px;
            color: #6c757d;
            padding-bottom: 12px;
            border-bottom: 2px solid #e9ecef;
            margin-bottom: 16px;
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
        
        .content-body {
            font-size: 14px;
            line-height: 1.8;
            color: #495057;
            min-height: 200px;
            white-space: pre-wrap;
        }
        
        .status-control {
            padding: 20px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .status-control label {
            font-size: 14px;
            font-weight: 500;
            color: #495057;
        }
        
        .status-control select {
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
        }
        
        .btn-save {
            padding: 8px 20px;
            background: #1971c2;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s;
        }
        
        .btn-save:hover {
            background: #1864ab;
        }
    </style>
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    <%@ include file="/include/sidebar.jsp" %>
    
    <!-- 메인 컨텐츠 -->
    <div class="main-content">
        <div class="content-header">
            <h2 class="page-title"><%= inquiry.getTypeLabel() %> 상세</h2>
            <a href="<%= request.getContextPath() %>/admin/inquiry/list?type=<%= inquiry.getType() %>" class="btn-list">목록으로</a>
        </div>
        
        <!-- 상세 내용 -->
        <div class="detail-container">
            <!-- 작성자 정보 -->
            <div class="author-info">
                <table class="info-table">
                    <tr>
                        <th>작성자</th>
                        <td><%= inquiry.getName() %></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td><%= inquiry.getEmail() != null ? inquiry.getEmail() : "-" %></td>
                    </tr>
                    <tr>
                        <th>연락처</th>
                        <td><%= inquiry.getPhone() != null ? inquiry.getPhone() : "-" %></td>
                    </tr>
                    <% if (inquiry.getDebtAmount() != null && !inquiry.getDebtAmount().isEmpty()) { %>
                    <tr>
                        <th>채무금액</th>
                        <td><%= inquiry.getDebtAmount() %></td>
                    </tr>
                    <% } %>
                    <% if (inquiry.getMonthlyIncome() != null && !inquiry.getMonthlyIncome().isEmpty()) { %>
                    <tr>
                        <th>월소득</th>
                        <td><%= inquiry.getMonthlyIncome() %></td>
                    </tr>
                    <% } %>
                </table>
            </div>
            
            <!-- 제목 및 내용 -->
            <div class="content-section">
                <h3 class="content-title"><%= inquiry.getTitle() %></h3>
                <div class="content-meta">
                    <span class="type-badge type-<%= inquiry.getType().toLowerCase() %>">
                        <%= inquiry.getTypeLabel() %>
                    </span>
                    <span><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(inquiry.getCreatedAt()) %></span>
                </div>
                <div class="content-body"><%= inquiry.getContent() %></div>
            </div>
            
            <!-- 상태 변경 -->
            <div class="status-control">
                <label>처리 상태</label>
                <select id="statusSelect" onchange="changeStatus()">
                    <option value="pending" <%= "pending".equals(inquiry.getStatus()) ? "selected" : "" %>>대기</option>
                    <option value="processing" <%= "processing".equals(inquiry.getStatus()) ? "selected" : "" %>>처리중</option>
                    <option value="completed" <%= "completed".equals(inquiry.getStatus()) ? "selected" : "" %>>완료</option>
                </select>
                <span id="statusMessage" style="margin-left: 12px; font-size: 13px; color: #28a745;"></span>
            </div>
        </div>
        
        <!-- 메모 섹션 -->
        <div class="memo-section">
            <div class="memo-header">관리자 메모</div>
            
            <!-- 메모 작성 -->
            <div class="memo-write">
                <textarea id="memoContent" placeholder="메모를 입력하세요..."></textarea>
                <div class="memo-write-footer">
                    <button class="btn-save" onclick="addMemo()">메모 추가</button>
                </div>
            </div>
            
            <!-- 메모 목록 -->
            <div class="memo-list" id="memoList">
                <div class="memo-empty">메모를 불러오는 중...</div>
            </div>
        </div>
    </div>
    
    <script>
        const inquiryId = <%= inquiry.getId() %>;
        const contextPath = '<%= request.getContextPath() %>';
        
        // 페이지 로드 시 메모 목록 불러오기
        window.onload = function() {
            loadMemos();
        };
        
        // 상태 변경
        function changeStatus() {
            const status = document.getElementById('statusSelect').value;
            const messageEl = document.getElementById('statusMessage');
            
            fetch(contextPath + '/admin/inquiry/status', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'id=' + inquiryId + '&status=' + status
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    messageEl.textContent = '✓ 상태가 변경되었습니다.';
                    messageEl.style.color = '#28a745';
                    setTimeout(() => {
                        messageEl.textContent = '';
                    }, 3000);
                } else {
                    messageEl.textContent = '✗ ' + data.message;
                    messageEl.style.color = '#dc3545';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                messageEl.textContent = '✗ 오류가 발생했습니다.';
                messageEl.style.color = '#dc3545';
            });
        }
        
        // 메모 목록 불러오기
        function loadMemos() {
            fetch(contextPath + '/admin/inquiry/memo?inquiryId=' + inquiryId)
            .then(response => response.json())
            .then(data => {
                const memoList = document.getElementById('memoList');
                
                if (data.success && data.memos.length > 0) {
                    let html = '';
                    data.memos.forEach(memo => {
                        const date = new Date(memo.createdAt);
                        const dateStr = date.getFullYear() + '-' + 
                                       String(date.getMonth() + 1).padStart(2, '0') + '-' + 
                                       String(date.getDate()).padStart(2, '0') + ' ' +
                                       String(date.getHours()).padStart(2, '0') + ':' + 
                                       String(date.getMinutes()).padStart(2, '0');
                        
                        html += '<div class="memo-item" id="memo-' + memo.id + '">';
                        html += '  <div class="memo-meta">';
                        html += '    <span class="memo-author">' + escapeHtml(memo.adminName) + '</span>';
                        html += '    <div>';
                        html += '      <span class="memo-date">' + dateStr + '</span>';
                        html += '      <button class="memo-btn memo-edit-btn" onclick="editMemo(' + memo.id + ', \'' + escapeHtml(memo.content).replace(/'/g, "\\'").replace(/\n/g, '\\n') + '\')">수정</button>';
                        html += '      <button class="memo-btn memo-delete-btn" onclick="deleteMemo(' + memo.id + ')">삭제</button>';
                        html += '    </div>';
                        html += '  </div>';
                        html += '  <div class="memo-content" id="memo-content-' + memo.id + '">' + escapeHtml(memo.content).replace(/\n/g, '<br>') + '</div>';
                        html += '  <div class="memo-edit-form" id="memo-edit-' + memo.id + '" style="display: none;">';
                        html += '    <textarea class="memo-edit-textarea" id="memo-edit-textarea-' + memo.id + '"></textarea>';
                        html += '    <div class="memo-edit-actions">';
                        html += '      <button class="btn-save" onclick="saveMemo(' + memo.id + ')">저장</button>';
                        html += '      <button class="btn-cancel" onclick="cancelEdit(' + memo.id + ')">취소</button>';
                        html += '    </div>';
                        html += '  </div>';
                        html += '</div>';
                    });
                    memoList.innerHTML = html;
                } else {
                    memoList.innerHTML = '<div class="memo-empty">등록된 메모가 없습니다.</div>';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('memoList').innerHTML = '<div class="memo-empty">메모를 불러올 수 없습니다.</div>';
            });
        }
        
        // 메모 추가
        function addMemo() {
            const content = document.getElementById('memoContent').value.trim();
            
            if (!content) {
                alert('메모 내용을 입력해주세요.');
                return;
            }
            
            fetch(contextPath + '/admin/inquiry/memo', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'inquiryId=' + inquiryId + '&content=' + encodeURIComponent(content)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('memoContent').value = '';
                    loadMemos();
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('메모 추가 중 오류가 발생했습니다.');
            });
        }
        
        // 메모 수정 모드
        function editMemo(id, content) {
            document.getElementById('memo-content-' + id).style.display = 'none';
            document.getElementById('memo-edit-' + id).style.display = 'block';
            document.getElementById('memo-edit-textarea-' + id).value = content;
        }
        
        // 메모 수정 취소
        function cancelEdit(id) {
            document.getElementById('memo-content-' + id).style.display = 'block';
            document.getElementById('memo-edit-' + id).style.display = 'none';
        }
        
        // 메모 저장
        function saveMemo(id) {
            const content = document.getElementById('memo-edit-textarea-' + id).value.trim();
            
            if (!content) {
                alert('메모 내용을 입력해주세요.');
                return;
            }
            
            fetch(contextPath + '/admin/inquiry/memo?id=' + id + '&content=' + encodeURIComponent(content), {
                method: 'PUT'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    loadMemos();
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('메모 수정 중 오류가 발생했습니다.');
            });
        }
        
        // 메모 삭제
        function deleteMemo(id) {
            if (!confirm('메모를 삭제하시겠습니까?')) {
                return;
            }
            
            fetch(contextPath + '/admin/inquiry/memo?id=' + id, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    loadMemos();
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('메모 삭제 중 오류가 발생했습니다.');
            });
        }
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    </script>
    
    <style>
        .memo-section {
            margin-top: 24px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            overflow: hidden;
        }
        
        .memo-header {
            padding: 16px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            font-size: 15px;
            font-weight: 600;
            color: #212529;
        }
        
        .memo-write {
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .memo-write textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }
        
        .memo-write textarea:focus {
            outline: none;
            border-color: #1971c2;
        }
        
        .memo-write-footer {
            display: flex;
            justify-content: flex-end;
            margin-top: 12px;
        }
        
        .memo-list {
            padding: 20px;
        }
        
        .memo-item {
            padding: 16px;
            background: #f8f9fa;
            border-radius: 6px;
            margin-bottom: 12px;
        }
        
        .memo-item:last-child {
            margin-bottom: 0;
        }
        
        .memo-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        
        .memo-author {
            font-size: 13px;
            font-weight: 500;
            color: #495057;
        }
        
        .memo-date {
            font-size: 12px;
            color: #6c757d;
            margin-right: 8px;
        }
        
        .memo-btn {
            padding: 4px 8px;
            font-size: 11px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 4px;
            transition: all 0.2s;
        }
        
        .memo-edit-btn {
            background: #e7f5ff;
            color: #1971c2;
        }
        
        .memo-edit-btn:hover {
            background: #d0ebff;
        }
        
        .memo-delete-btn {
            background: #ffe0e0;
            color: #c92a2a;
        }
        
        .memo-delete-btn:hover {
            background: #ffc9c9;
        }
        
        .memo-edit-form {
            margin-top: 8px;
        }
        
        .memo-edit-textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            resize: vertical;
            min-height: 80px;
            font-family: inherit;
        }
        
        .memo-edit-textarea:focus {
            outline: none;
            border-color: #1971c2;
        }
        
        .memo-edit-actions {
            display: flex;
            gap: 8px;
            margin-top: 8px;
        }
        
        .btn-cancel {
            padding: 8px 16px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
        }
        
        .memo-content {
            font-size: 14px;
            color: #212529;
            line-height: 1.6;
        }
        
        .memo-empty {
            text-align: center;
            padding: 40px;
            color: #adb5bd;
            font-size: 14px;
        }
    </style>
</body>
</html>
