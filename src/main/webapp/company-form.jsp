<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Company, model.Admin" %>
<%
    Company company = (Company) request.getAttribute("company");
    String mode = (String) request.getAttribute("mode");
    boolean isEdit = "edit".equals(mode);
    
    // 현재 사용자 권한 확인
    Admin currentAdmin = (Admin) session.getAttribute("admin");
    String adminRole = currentAdmin != null ? currentAdmin.getRole() : (String) session.getAttribute("adminRole");
    boolean isAdminRole = "ADMIN".equals(adminRole);
    boolean isMasterRole = "MASTER".equals(adminRole);
    
    if (company == null) {
        company = new Company();
        company.setIsActive("Y");
        company.setWeekdayStart("09:00");
        company.setWeekdayEnd("18:00");
        company.setWeekendStart("10:00");
        company.setWeekendEnd("17:00");
        company.setSiteTitle("법무법인 굿플랜");
        company.setSiteSubtitle("당신의 새로운 시작을 함께합니다");
        company.setSiteKeywords("개인회생,파산,채무조정,법무법인");
    }
    
    // form action 결정
    String formAction = isAdminRole ? request.getContextPath() + "/admin/company/my" : 
                        (isEdit ? request.getContextPath() + "/admin/company/edit" : 
                         request.getContextPath() + "/admin/company/add");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "업체 수정" : "업체 추가" %></title>
    <style>
        <%@ include file="/css/common.css" %>
        /* 공통 스타일 (common.css) */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            background: #f8f9fa;
        }
        
        /* 헤더 */
        .header {
            background: #495057;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }
        
        .header-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        
        .header h1 {
            color: white;
            font-size: 18px;
            font-weight: 600;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        
        .user-info span {
            color: #e9ecef;
            font-size: 13px;
        }
        
        .role-badge {
            padding: 3px 8px;
            background: rgba(255,255,255,0.2);
            border-radius: 4px;
            font-size: 11px;
        }
        
        .logout-btn {
            padding: 6px 14px;
            background: rgba(255,255,255,0.1);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 13px;
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.2s;
        }
        
        .logout-btn:hover {
            background: rgba(255,255,255,0.2);
            border-color: rgba(255,255,255,0.3);
        }
        
        /* 사이드바 */
        .sidebar {
            position: fixed;
            top: 56px;
            left: 0;
            width: 220px;
            height: calc(100vh - 56px);
            background: white;
            padding: 16px 0;
            overflow-y: auto;
            border-right: 1px solid #e9ecef;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0 12px;
        }
        
        .sidebar-menu li {
            margin-bottom: 2px;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            color: #495057;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.2s;
            font-size: 14px;
        }
        
        .sidebar-menu a:hover {
            background: #f8f9fa;
        }
        
        .sidebar-menu a.active {
            background: #e7f5ff;
            color: #1971c2;
            font-weight: 500;
        }
        
        .sidebar-menu a .icon {
            width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .menu-parent {
            pointer-events: none;
            color: #adb5bd;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .submenu {
            list-style: none;
            padding-left: 40px;
            margin-top: 4px;
        }
        
        .submenu li {
            margin-bottom: 2px;
        }
        
        .submenu a {
            padding: 8px 12px;
            font-size: 13px;
            color: #6c757d;
        }
        
        .submenu a:hover {
            color: #1971c2;
        }
        
        /* 메인 컨텐츠 */
        .main-content {
            margin-left: 220px;
            margin-top: 56px;
            padding: 24px;
            min-height: calc(100vh - 56px);
        }
        
        .page-title {
            font-size: 20px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 20px;
        }
        
        /* 페이지별 스타일 */
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
        
        .form-container {
            background: white;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            padding: 32px;
        }
        
        .form-section {
            margin-bottom: 32px;
        }
        
        .form-section:last-child {
            margin-bottom: 0;
        }
        
        .form-section-title {
            font-size: 16px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 16px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-row.full {
            grid-template-columns: 1fr;
        }
        
        .form-group {
            margin-bottom: 0;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #495057;
        }
        
        .form-group label .required {
            color: #dc3545;
            margin-left: 2px;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s;
        }
        
        .form-group input[type="time"] {
            width: 150px;
        }
        
        .form-group input[type="file"] {
            padding: 8px;
            font-size: 13px;
        }
        
        .image-preview {
            max-width: 200px;
            max-height: 100px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 4px;
        }
        
        .btn-toggle-schedule {
            padding: 8px 16px;
            background: #f8f9fa;
            color: #495057;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-toggle-schedule:hover {
            background: #e9ecef;
            border-color: #adb5bd;
        }
        
        .btn-toggle-schedule.active {
            background: #e7f5ff;
            color: #1971c2;
            border-color: #1971c2;
        }
        
        #scheduleToggleIcon {
            font-size: 10px;
            transition: transform 0.2s;
        }
        
        .btn-toggle-schedule.active #scheduleToggleIcon {
            transform: rotate(180deg);
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #1971c2;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-group small {
            display: block;
            margin-top: 4px;
            font-size: 12px;
            color: #6c757d;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            padding-top: 24px;
            border-top: 1px solid #e9ecef;
        }
        
        .btn-cancel {
            padding: 10px 20px;
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
        
        .btn-save {
            padding: 10px 20px;
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
        
        .list-table th:nth-child(1) { width: 120px; }
        .list-table th:nth-child(2) { text-align: left; }
        .list-table th:nth-child(3) { width: 120px; }
        .list-table th:nth-child(4) { width: 150px; }
        .list-table th:nth-child(5) { width: 150px; }
        
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
        
        .list-table tbody tr:hover {
            background: #f8f9fa;
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
            background: #fee2e2;
            color: #991b1b;
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
        
        .toast.error {
            background: #dc3545;
        }
        
        .toast-icon {
            font-size: 20px;
        }
        
        .toast-message {
            flex: 1;
            font-size: 14px;
            font-weight: 500;
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
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    <%@ include file="/include/sidebar.jsp" %>
    
    <!-- 메인 컨텐츠 -->
    <div class="main-content">
        <div class="content-header">
            <h2 class="page-title"><%= isEdit ? "업체 수정 - " + company.getId() : "업체 추가" %></h2>
            <a href="<%= request.getContextPath() %>/admin/company/list" class="btn-list">목록으로</a>
        </div>
        
        <form class="form-container" id="companyForm" method="post" action="<%= formAction %>" enctype="multipart/form-data">
            <input type="hidden" name="mode" value="<%= mode %>">
            <input type="hidden" name="schedule_json" id="schedule_json" value="">
            
            <!-- 기본 정보 -->
            <div class="form-section">
                <h3 class="form-section-title">기본 정보</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>업체 ID <span class="required">*</span></label>
                        <input type="text" name="id" value="<%= company.getId() != null ? company.getId() : "" %>" 
                               <%= isEdit ? "readonly style='background: #f8f9fa;'" : "required" %>>
                    </div>
                    <div class="form-group">
                        <label>상태 <span class="required">*</span></label>
                        <select name="is_active">
                            <option value="Y" <%= "Y".equals(company.getIsActive()) ? "selected" : "" %>>활성</option>
                            <option value="N" <%= "N".equals(company.getIsActive()) ? "selected" : "" %>>비활성</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>업체명 (내부용) <span class="required">*</span></label>
                        <input type="text" name="name" value="<%= company.getName() != null ? company.getName() : "" %>" required>
                        <small>관리자 시스템에서 표시되는 이름</small>
                    </div>
                    <div class="form-group">
                        <label>업체명 (공식)</label>
                        <input type="text" name="company_name" value="<%= company.getCompanyName() != null ? company.getCompanyName() : "" %>">
                        <small>사이트에 표시되는 공식 업체명</small>
                    </div>
                </div>
                
                <div class="form-row full">
                    <div class="form-group">
                        <label>설명</label>
                        <textarea name="description" placeholder="업체 설명을 입력하세요"><%= company.getDescription() != null ? company.getDescription() : "" %></textarea>
                    </div>
                </div>
            </div>
            
            <!-- 사업자 정보 -->
            <div class="form-section">
                <h3 class="form-section-title">사업자 정보</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>대표자명</label>
                        <input type="text" name="representative" value="<%= company.getRepresentative() != null ? company.getRepresentative() : "" %>" placeholder="홍길동">
                    </div>
                    <div class="form-group">
                        <label>사업자번호</label>
                        <input type="text" name="business_number" value="<%= company.getBusinessNumber() != null ? company.getBusinessNumber() : "" %>" placeholder="123-45-67890">
                    </div>
                </div>
            </div>
            
            <!-- 연락처 정보 -->
            <div class="form-section">
                <h3 class="form-section-title">연락처 정보</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>전화번호</label>
                        <input type="tel" name="phone" value="<%= company.getPhone() != null ? company.getPhone() : "" %>" placeholder="02-1234-5678">
                    </div>
                    <div class="form-group">
                        <label>팩스번호</label>
                        <input type="tel" name="fax" value="<%= company.getFax() != null ? company.getFax() : "" %>" placeholder="02-1234-5679">
                    </div>
                </div>
                
                <div class="form-row full">
                    <div class="form-group">
                        <label>이메일</label>
                        <input type="email" name="email" value="<%= company.getEmail() != null ? company.getEmail() : "" %>" placeholder="contact@company.com">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>우편번호</label>
                        <input type="text" name="postal_code" value="<%= company.getPostalCode() != null ? company.getPostalCode() : "" %>" placeholder="12345">
                    </div>
                    <div class="form-group">
                        <label>주소</label>
                        <input type="text" name="address" value="<%= company.getAddress() != null ? company.getAddress() : "" %>" placeholder="서울시 강남구...">
                    </div>
                </div>
            </div>
            
            <!-- 운영 시간 -->
            <div class="form-section">
                <h3 class="form-section-title">운영 시간</h3>
                
                <div class="form-row full">
                    <div class="form-group">
                        <button type="button" class="btn-toggle-schedule" onclick="toggleDetailSchedule()">
                            <span id="scheduleToggleText">요일별 상세 설정 보기</span>
                            <span id="scheduleToggleIcon">▼</span>
                        </button>
                    </div>
                </div>
                
                <!-- 기본 설정 -->
                <div id="basicSchedule">
                    <div class="form-row">
                        <div class="form-group">
                            <label>평일 운영 시간</label>
                            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
                                <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0;">
                                    <input type="checkbox" name="weekday_days" value="mon" checked>
                                    <span>월</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0;">
                                    <input type="checkbox" name="weekday_days" value="tue" checked>
                                    <span>화</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0;">
                                    <input type="checkbox" name="weekday_days" value="wed" checked>
                                    <span>수</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0;">
                                    <input type="checkbox" name="weekday_days" value="thu" checked>
                                    <span>목</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0;">
                                    <input type="checkbox" name="weekday_days" value="fri" checked>
                                    <span>금</span>
                                </label>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="time" name="weekday_start" value="09:00">
                                <span>~</span>
                                <input type="time" name="weekday_end" value="18:00">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>주말 운영 시간</label>
                            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
                                <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0;">
                                    <input type="checkbox" name="weekend_days" value="sat" checked>
                                    <span>토</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0;">
                                    <input type="checkbox" name="weekend_days" value="sun" checked>
                                    <span>일</span>
                                </label>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="time" name="weekend_start" value="10:00">
                                <span>~</span>
                                <input type="time" name="weekend_end" value="17:00">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 상세 설정 -->
                <div id="detailScheduleContent" style="display: none;">
                    <div style="display: grid; gap: 12px;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <label style="width: 60px; font-weight: 500; margin: 0;">월요일</label>
                            <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0; width: 60px;">
                                <input type="checkbox" name="mon_enabled" checked>
                                <span>운영</span>
                            </label>
                            <input type="time" name="mon_start" value="09:00">
                            <span>~</span>
                            <input type="time" name="mon_end" value="18:00">
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <label style="width: 60px; font-weight: 500; margin: 0;">화요일</label>
                            <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0; width: 60px;">
                                <input type="checkbox" name="tue_enabled" checked>
                                <span>운영</span>
                            </label>
                            <input type="time" name="tue_start" value="09:00">
                            <span>~</span>
                            <input type="time" name="tue_end" value="18:00">
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <label style="width: 60px; font-weight: 500; margin: 0;">수요일</label>
                            <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0; width: 60px;">
                                <input type="checkbox" name="wed_enabled" checked>
                                <span>운영</span>
                            </label>
                            <input type="time" name="wed_start" value="09:00">
                            <span>~</span>
                            <input type="time" name="wed_end" value="18:00">
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <label style="width: 60px; font-weight: 500; margin: 0;">목요일</label>
                            <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0; width: 60px;">
                                <input type="checkbox" name="thu_enabled" checked>
                                <span>운영</span>
                            </label>
                            <input type="time" name="thu_start" value="09:00">
                            <span>~</span>
                            <input type="time" name="thu_end" value="18:00">
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <label style="width: 60px; font-weight: 500; margin: 0;">금요일</label>
                            <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0; width: 60px;">
                                <input type="checkbox" name="fri_enabled" checked>
                                <span>운영</span>
                            </label>
                            <input type="time" name="fri_start" value="09:00">
                            <span>~</span>
                            <input type="time" name="fri_end" value="18:00">
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <label style="width: 60px; font-weight: 500; margin: 0;">토요일</label>
                            <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0; width: 60px;">
                                <input type="checkbox" name="sat_enabled" checked>
                                <span>운영</span>
                            </label>
                            <input type="time" name="sat_start" value="10:00">
                            <span>~</span>
                            <input type="time" name="sat_end" value="17:00">
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <label style="width: 60px; font-weight: 500; margin: 0;">일요일</label>
                            <label style="display: flex; align-items: center; gap: 4px; font-weight: normal; margin: 0; width: 60px;">
                                <input type="checkbox" name="sun_enabled" checked>
                                <span>운영</span>
                            </label>
                            <input type="time" name="sun_start" value="10:00">
                            <span>~</span>
                            <input type="time" name="sun_end" value="17:00">
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 사이트 설정 -->
            <div class="form-section">
                <h3 class="form-section-title">사이트 설정</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>사이트 제목</label>
                        <input type="text" name="site_title" value="<%= company.getSiteTitle() != null ? company.getSiteTitle() : "" %>">
                    </div>
                    <div class="form-group">
                        <label>사이트 부제목</label>
                        <input type="text" name="site_subtitle" value="<%= company.getSiteSubtitle() != null ? company.getSiteSubtitle() : "" %>">
                    </div>
                </div>
                
                <div class="form-row full">
                    <div class="form-group">
                        <label>사이트 설명</label>
                        <textarea name="site_description" placeholder="사이트 설명을 입력하세요"><%= company.getSiteDescription() != null ? company.getSiteDescription() : "" %></textarea>
                    </div>
                </div>
                
                <div class="form-row full">
                    <div class="form-group">
                        <label>사이트 키워드</label>
                        <input type="text" name="site_keywords" value="<%= company.getSiteKeywords() != null ? company.getSiteKeywords() : "" %>">
                        <small>쉼표(,)로 구분하여 입력</small>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>로고 이미지</label>
                        <input type="file" name="logo_file" accept="image/*" onchange="previewImage(this, 'logoPreview')">
                        <input type="hidden" name="logo_url" value="">
                        <div id="logoPreview" style="margin-top: 10px;"></div>
                        <small>권장 크기: 200x60px</small>
                    </div>
                    <div class="form-group">
                        <label>파비콘</label>
                        <input type="file" name="favicon_file" accept="image/x-icon,image/png" onchange="previewImage(this, 'faviconPreview')">
                        <input type="hidden" name="favicon_url" value="">
                        <div id="faviconPreview" style="margin-top: 10px;"></div>
                        <small>권장 크기: 32x32px (ico 또는 png)</small>
                    </div>
                </div>
            </div>
            
            <!-- 저장 버튼 -->
            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="location.href='/admin/company/list'">취소</button>
                <button type="submit" class="btn-save">저장</button>
            </div>
        </form>
    </div>
    
    <script>
        // 토스트 메시지 표시
        function showToast(message, type) {
            type = type || 'success';
            const toast = document.createElement('div');
            toast.className = 'toast' + (type == 'error' ? ' error' : '');
            
            const icon = document.createElement('span');
            icon.className = 'toast-icon';
            icon.textContent = type == 'success' ? '✓' : '✕';
            
            const msg = document.createElement('span');
            msg.className = 'toast-message';
            msg.textContent = message;
            
            toast.appendChild(icon);
            toast.appendChild(msg);
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
                // URL에서 파라미터 제거
                window.history.replaceState({}, document.title, window.location.pathname);
            } else if (urlParams.get('error') === '1') {
                showToast('저장 중 오류가 발생했습니다.', 'error');
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });
        
        // 이미지 미리보기
        function previewImage(input, previewId) {
            const preview = document.getElementById(previewId);
            preview.innerHTML = '';
            
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.style.maxWidth = '200px';
                    img.style.maxHeight = '100px';
                    img.style.border = '1px solid #dee2e6';
                    img.style.borderRadius = '4px';
                    preview.appendChild(img);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        // 페이지 로드 시 기존 데이터 로드
        window.onload = function() {
            // 기존 로고 이미지 표시
            <% if (company.getLogoUrl() != null && !company.getLogoUrl().isEmpty()) { %>
            const logoPreview = document.getElementById('logoPreview');
            const logoImg = document.createElement('img');
            logoImg.src = '<%= company.getLogoUrl() %>';
            logoImg.style.maxWidth = '200px';
            logoImg.style.maxHeight = '100px';
            logoImg.style.border = '1px solid #dee2e6';
            logoImg.style.borderRadius = '4px';
            logoPreview.appendChild(logoImg);
            document.querySelector('input[name="logo_url"]').value = '<%= company.getLogoUrl() %>';
            <% } %>
            
            // 기존 파비콘 표시
            <% if (company.getFaviconUrl() != null && !company.getFaviconUrl().isEmpty()) { %>
            const faviconPreview = document.getElementById('faviconPreview');
            const faviconImg = document.createElement('img');
            faviconImg.src = '<%= company.getFaviconUrl() %>';
            faviconImg.style.maxWidth = '32px';
            faviconImg.style.maxHeight = '32px';
            faviconImg.style.border = '1px solid #dee2e6';
            faviconImg.style.borderRadius = '4px';
            faviconPreview.appendChild(faviconImg);
            document.querySelector('input[name="favicon_url"]').value = '<%= company.getFaviconUrl() %>';
            <% } %>
            
            // schedule_json 데이터 로드
            <% if (company.getScheduleJson() != null && !company.getScheduleJson().isEmpty()) { %>
            try {
                const scheduleJson = JSON.parse('<%= company.getScheduleJson().replace("'", "\\'") %>');
                loadScheduleData(scheduleJson);
            } catch(e) {
                console.error('Schedule JSON parse error:', e);
            }
            <% } %>
        };
        
        // schedule_json 데이터를 폼에 로드
        function loadScheduleData(scheduleJson) {
            if (!scheduleJson) return;
            
            // 요일별 상세 설정에 데이터 채우기
            const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
            days.forEach(day => {
                if (scheduleJson[day]) {
                    const enabled = scheduleJson[day].enabled;
                    const start = scheduleJson[day].start;
                    const end = scheduleJson[day].end;
                    
                    document.querySelector(`input[name="${day}_enabled"]`).checked = enabled;
                    document.querySelector(`input[name="${day}_start"]`).value = start;
                    document.querySelector(`input[name="${day}_end"]`).value = end;
                }
            });
        }
        
        // 이미지 미리보기
        function previewImage(input, previewId) {
            const preview = document.getElementById(previewId);
            preview.innerHTML = '';
            
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'image-preview';
                    preview.appendChild(img);
                };
                
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        // 상세 스케줄 토글
        function toggleDetailSchedule() {
            const btn = document.querySelector('.btn-toggle-schedule');
            const basicSchedule = document.getElementById('basicSchedule');
            const detailSchedule = document.getElementById('detailScheduleContent');
            const toggleText = document.getElementById('scheduleToggleText');
            
            const isActive = btn.classList.contains('active');
            
            if (isActive) {
                btn.classList.remove('active');
                basicSchedule.style.display = 'block';
                detailSchedule.style.display = 'none';
                toggleText.textContent = '요일별 상세 설정 보기';
            } else {
                btn.classList.add('active');
                basicSchedule.style.display = 'none';
                detailSchedule.style.display = 'block';
                toggleText.textContent = '기본 설정으로 돌아가기';
            }
        }
        
        document.getElementById('companyForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            
            // 운영 시간 JSON 생성
            const scheduleJson = {};
            const isDetailMode = document.querySelector('.btn-toggle-schedule').classList.contains('active');
            
            if (isDetailMode) {
                // 요일별 상세 설정
                const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
                days.forEach(day => {
                    scheduleJson[day] = {
                        enabled: formData.get(day + '_enabled') === 'on',
                        start: formData.get(day + '_start'),
                        end: formData.get(day + '_end')
                    };
                });
            } else {
                // 기본 설정 (평일/주말)
                const weekdayDays = formData.getAll('weekday_days');
                const weekendDays = formData.getAll('weekend_days');
                const weekdayStart = formData.get('weekday_start');
                const weekdayEnd = formData.get('weekday_end');
                const weekendStart = formData.get('weekend_start');
                const weekendEnd = formData.get('weekend_end');
                
                const dayMap = {
                    'mon': 'weekday', 'tue': 'weekday', 'wed': 'weekday', 
                    'thu': 'weekday', 'fri': 'weekday',
                    'sat': 'weekend', 'sun': 'weekend'
                };
                
                ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'].forEach(day => {
                    const type = dayMap[day];
                    const isEnabled = (type === 'weekday' && weekdayDays.includes(day)) ||
                                     (type === 'weekend' && weekendDays.includes(day));
                    
                    scheduleJson[day] = {
                        enabled: isEnabled,
                        start: type === 'weekday' ? weekdayStart : weekendStart,
                        end: type === 'weekday' ? weekdayEnd : weekendEnd
                    };
                });
            }
            
            // schedule_json 추가
            formData.append('schedule_json', JSON.stringify(scheduleJson));
            
            // 기존 weekday/weekend 필드는 호환성을 위해 유지
            // (schedule_json에서 계산 가능)
            
            // schedule_json을 hidden input에 설정
            document.getElementById('schedule_json').value = JSON.stringify(scheduleJson);
            
            // form submit
            e.target.submit();
        });
    </script>
</body>
</html>
