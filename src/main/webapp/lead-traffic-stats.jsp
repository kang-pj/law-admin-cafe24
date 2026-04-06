<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLDecoder" %>
<%!
    private String decode(Object value) {
        if (value == null) return null;
        try {
            return URLDecoder.decode(value.toString(), "UTF-8");
        } catch (Exception e) {
            return value.toString();
        }
    }
%>
<%
    String period = (String) request.getAttribute("period");
    List<Map<String, Object>> leads = (List<Map<String, Object>>) request.getAttribute("leads");
    List<Map<String, Object>> dailyStats = (List<Map<String, Object>>) request.getAttribute("dailyStats");
    List<Map<String, Object>> utmSourceStats = (List<Map<String, Object>>) request.getAttribute("utmSourceStats");
    List<Map<String, Object>> deviceStats = (List<Map<String, Object>>) request.getAttribute("deviceStats");
    Map<String, Object> conversionData = (Map<String, Object>) request.getAttribute("conversionData");
    int totalCount = (Integer) request.getAttribute("totalCount");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상담 신청 & 유입 통계</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        function setPeriod(period) {
            window.location.href = '?period=' + period;
        }
        function toggleDatePicker() {
            const group = document.getElementById('datePickerGroup');
            group.style.display = group.style.display === 'none' ? 'flex' : 'none';
        }
        function applyCustomDate() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            if (!startDate || !endDate) {
                alert('시작일과 종료일을 모두 선택해주세요.');
                return;
            }
            window.location.href = '?period=custom&startDate=' + startDate + '&endDate=' + endDate;
        }
    </script>
    <style>
        <%@ include file="/css/common.css" %>
    </style>
    <style>
        .stats-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .filter-group {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .period-buttons {
            display: flex;
            gap: 5px;
            background: #f5f5f5;
            padding: 4px;
            border-radius: 8px;
        }
        
        .period-btn {
            padding: 8px 16px;
            border: none;
            background: transparent;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            color: #666;
            transition: all 0.2s;
        }
        
        .period-btn:hover {
            background: #e0e0e0;
        }
        
        .period-btn.active {
            background: #667eea;
            color: white;
        }
        
        .date-picker-group {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        
        .date-picker-group input[type="date"] {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .apply-btn {
            padding: 8px 15px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
        }
        
        .apply-btn:hover {
            background: #5568d3;
        }
        
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .stat-card h3 {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .stat-card .value {
            font-size: 32px;
            font-weight: bold;
            color: #333;
        }
        
        .stat-card .sub-value {
            font-size: 14px;
            color: #999;
            margin-top: 5px;
        }
        
        .chart-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .chart-container h2 {
            margin-bottom: 20px;
            font-size: 18px;
        }
        
        .chart-wrapper {
            position: relative;
            height: 300px;
        }
        
        .lead-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .lead-table h2 {
            padding: 20px;
            margin: 0;
            font-size: 18px;
            border-bottom: 1px solid #eee;
        }
        
        .lead-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .lead-table th,
        .lead-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
            font-size: 13px;
        }
        
        .lead-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        
        .lead-table td {
            color: #666;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 5px;
            padding: 20px;
        }
        
        .pagination a,
        .pagination span {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
            color: #333;
        }
        
        .pagination a:hover {
            background: #f0f0f0;
        }
        
        .pagination .active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .traffic-info {
            font-size: 12px;
            color: #999;
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    
    <div class="container">
        <%@ include file="/include/sidebar.jsp" %>
        
        <main class="main-content">
            <div class="content-header">
                <h1>상담 신청 & 유입 통계</h1>
            </div>
            
            <div class="stats-header">
                <div class="filter-group">
                    <div class="period-buttons">
                        <button class="period-btn <%= "today".equals(period) ? "active" : "" %>" onclick="setPeriod('today')">오늘</button>
                        <button class="period-btn <%= "week".equals(period) ? "active" : "" %>" onclick="setPeriod('week')">7일</button>
                        <button class="period-btn <%= "month".equals(period) ? "active" : "" %>" onclick="setPeriod('month')">이번 달</button>
                        <button class="period-btn <%= "30days".equals(period) ? "active" : "" %>" onclick="setPeriod('30days')">30일</button>
                        <button class="period-btn <%= "custom".equals(period) ? "active" : "" %>" onclick="toggleDatePicker()">직접 선택</button>
                    </div>
                    
                    <div class="date-picker-group" id="datePickerGroup" style="display: <%= "custom".equals(period) ? "flex" : "none" %>;">
                        <input type="date" id="startDate" value="<%= request.getAttribute("startDate") %>">
                        <span>~</span>
                        <input type="date" id="endDate" value="<%= request.getAttribute("endDate") %>">
                        <button class="apply-btn" onclick="applyCustomDate()">조회</button>
                    </div>
                </div>
            </div>
            
            <div class="stats-cards">
                <div class="stat-card">
                    <h3>총 상담 신청</h3>
                    <div class="value"><%= totalCount %></div>
                </div>
                
                <div class="stat-card">
                    <h3>순 방문자</h3>
                    <div class="value"><%= conversionData.get("visits") %></div>
                    <div class="sub-value">세션 기준</div>
                </div>
                
                <div class="stat-card">
                    <h3>전환율</h3>
                    <div class="value"><%= conversionData.get("conversionRate") %>%</div>
                    <div class="sub-value">상담신청 / 방문자</div>
                </div>
            </div>
            
            <% if (dailyStats != null && !dailyStats.isEmpty()) { %>
            <div class="chart-container">
                <h2>일별 통계 (상담 신청 vs 방문)</h2>
                <div class="chart-wrapper">
                    <canvas id="dailyChart"></canvas>
                </div>
            </div>
            <% } %>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px;">
                <% if (utmSourceStats != null && !utmSourceStats.isEmpty()) { %>
                <div class="chart-container">
                    <h2>유입 경로별 상담 신청</h2>
                    <div class="chart-wrapper">
                        <canvas id="sourceChart"></canvas>
                    </div>
                </div>
                <% } %>
                
                <% if (deviceStats != null && !deviceStats.isEmpty()) { %>
                <div class="chart-container">
                    <h2>디바이스별 상담 신청</h2>
                    <div class="chart-wrapper">
                        <canvas id="deviceChart"></canvas>
                    </div>
                </div>
                <% } %>
            </div>
            
            <div class="lead-table">
                <h2>상담 신청 목록 (<%= totalCount %>건)</h2>
                <table>
                    <thead>
                        <tr>
                            <th style="white-space: nowrap;">신청일시</th>
                            <th style="white-space: nowrap; min-width: 80px;">이름</th>
                            <th style="white-space: nowrap;">연락처</th>
                            <th style="white-space: nowrap;">상담 경로</th>
                            <th>유입 정보</th>
                            <th style="white-space: nowrap;">디바이스</th>
                            <th style="white-space: nowrap; min-width: 70px;">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (leads != null && !leads.isEmpty()) { 
                            for (Map<String, Object> lead : leads) { %>
                        <tr>
                            <td><%= lead.get("createdAt") %></td>
                            <td><%= lead.get("name") %></td>
                            <td><%= lead.get("phone") %></td>
                            <td><%= lead.get("consultationSource") != null ? lead.get("consultationSource") : "-" %></td>
                            <td>
                                <% if (lead.get("utmSource") != null) { %>
                                    <%= decode(lead.get("utmSource")) %>
                                    <% if (lead.get("utmMedium") != null) { %>
                                        / <%= decode(lead.get("utmMedium")) %>
                                    <% } %>
                                <% } else if (lead.get("referrerUrl") != null) { %>
                                    <%= decode(lead.get("referrerUrl")) %>
                                <% } else { %>
                                    직접 유입
                                <% } %>
                                <div class="traffic-info">
                                    <% if (lead.get("landingPage") != null) { %>
                                        랜딩: <%= decode(lead.get("landingPage")) %>
                                    <% } %>
                                </div>
                            </td>
                            <td>
                                <%= lead.get("deviceType") != null ? lead.get("deviceType") : "-" %>
                                <div class="traffic-info">
                                    <%= lead.get("os") != null ? lead.get("os") : "" %>
                                    <%= lead.get("browser") != null ? " / " + lead.get("browser") : "" %>
                                </div>
                            </td>
                            <td>
                                <span class="status-badge status-<%= lead.get("status") %>">
                                    <%= "pending".equals(lead.get("status")) ? "대기" : "완료" %>
                                </span>
                            </td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 40px;">
                                상담 신청 내역이 없습니다.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <% if (totalPages > 1) { %>
                <div class="pagination">
                    <%
                        String ltStartDate = (String) request.getAttribute("startDate");
                        String ltEndDate = (String) request.getAttribute("endDate");
                        String ltDateParams = "custom".equals(period) && ltStartDate != null && ltEndDate != null
                            ? "&startDate=" + ltStartDate + "&endDate=" + ltEndDate : "";
                    %>
                    <% if (currentPage > 1) { %>
                    <a href="?period=<%= period %><%= ltDateParams %>&page=<%= currentPage - 1 %>">이전</a>
                    <% } %>
                    
                    <% for (int i = 1; i <= totalPages; i++) { 
                        if (i == currentPage) { %>
                    <span class="active"><%= i %></span>
                    <% } else { %>
                    <a href="?period=<%= period %><%= ltDateParams %>&page=<%= i %>"><%= i %></a>
                    <% } 
                    } %>
                    
                    <% if (currentPage < totalPages) { %>
                    <a href="?period=<%= period %><%= ltDateParams %>&page=<%= currentPage + 1 %>">다음</a>
                    <% } %>
                </div>
                <% } %>
            </div>
        </main>
    </div>
    
    
    
    <script>
        function setPeriod(p) {
            window.location.href = '?period=' + p;
        }
        
        function toggleDatePicker() {
            const group = document.getElementById('datePickerGroup');
            group.style.display = group.style.display === 'none' ? 'flex' : 'none';
        }
        
        function applyCustomDate() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            if (!startDate || !endDate) {
                alert('시작일과 종료일을 모두 선택해주세요.');
                return;
            }
            window.location.href = '?period=custom&startDate=' + startDate + '&endDate=' + endDate;
        }
    </script>
    
    <script>
        <% if (dailyStats != null && !dailyStats.isEmpty()) { %>
        // 일별 차트
        const dailyCtx = document.getElementById('dailyChart').getContext('2d');
        new Chart(dailyCtx, {
            type: 'line',
            data: {
                labels: [<% for (int i = 0; i < dailyStats.size(); i++) { 
                    Map<String, Object> stat = dailyStats.get(i);
                    if (i > 0) out.print(", ");
                    out.print("'" + stat.get("date") + "'");
                } %>],
                datasets: [{
                    label: '상담 신청',
                    data: [<% for (int i = 0; i < dailyStats.size(); i++) { 
                        Map<String, Object> stat = dailyStats.get(i);
                        if (i > 0) out.print(", ");
                        out.print(stat.get("leadCount"));
                    } %>],
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: '방문자',
                    data: [<% for (int i = 0; i < dailyStats.size(); i++) { 
                        Map<String, Object> stat = dailyStats.get(i);
                        if (i > 0) out.print(", ");
                        out.print(stat.get("visitCount"));
                    } %>],
                    borderColor: '#f093fb',
                    backgroundColor: 'rgba(240, 147, 251, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
        <% } %>
        
        <% if (utmSourceStats != null && !utmSourceStats.isEmpty()) { %>
        // 유입 경로 차트
        const sourceCtx = document.getElementById('sourceChart').getContext('2d');
        new Chart(sourceCtx, {
            type: 'doughnut',
            data: {
                labels: [<% for (int i = 0; i < utmSourceStats.size(); i++) { 
                    Map<String, Object> stat = utmSourceStats.get(i);
                    if (i > 0) out.print(", ");
                    String src = String.valueOf(stat.get("source")).replace("'", "\\'");
                    out.print("'" + src + "'");
                } %>],
                datasets: [{
                    data: [<% for (int i = 0; i < utmSourceStats.size(); i++) { 
                        Map<String, Object> stat = utmSourceStats.get(i);
                        if (i > 0) out.print(", ");
                        out.print(stat.get("count"));
                    } %>],
                    backgroundColor: ['#667eea', '#764ba2', '#f093fb', '#4facfe', '#00f2fe']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
        <% } %>
        
        <% if (deviceStats != null && !deviceStats.isEmpty()) { %>
        // 디바이스 차트
        const deviceCtx = document.getElementById('deviceChart').getContext('2d');
        new Chart(deviceCtx, {
            type: 'pie',
            data: {
                labels: [<% for (int i = 0; i < deviceStats.size(); i++) { 
                    Map<String, Object> stat = deviceStats.get(i);
                    if (i > 0) out.print(", ");
                    String dev = String.valueOf(stat.get("device")).replace("'", "\\'");
                    out.print("'" + dev + "'");
                } %>],
                datasets: [{
                    data: [<% for (int i = 0; i < deviceStats.size(); i++) { 
                        Map<String, Object> stat = deviceStats.get(i);
                        if (i > 0) out.print(", ");
                        out.print(stat.get("count"));
                    } %>],
                    backgroundColor: ['#667eea', '#f093fb', '#4facfe']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
        <% } %>
    </script>
</body>
</html>
