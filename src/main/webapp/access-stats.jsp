<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.AccessLog" %>
<%@ page import="model.Company" %>
<%
    String adminRole = (String) session.getAttribute("adminRole");
    String period = (String) request.getAttribute("period");
    String companyFilter = (String) request.getAttribute("companyFilter");
    List<Map<String, Object>> dailyStats = (List<Map<String, Object>>) request.getAttribute("dailyStats");
    List<Map<String, Object>> hourlyStats = (List<Map<String, Object>>) request.getAttribute("hourlyStats");
    List<AccessLog> logs = (List<AccessLog>) request.getAttribute("logs");
    List<Map<String, Object>> companyStats = (List<Map<String, Object>>) request.getAttribute("companyStats");
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    int totalCount = (Integer) request.getAttribute("totalCount");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>접속 통계</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        <%@ include file="/css/common.css" %>
        
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
        
        .filter-group select,
        .filter-group button.apply-btn {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .filter-group button.apply-btn {
            background: #667eea;
            color: white;
            cursor: pointer;
            border: none;
        }
        
        .filter-group button.apply-btn:hover {
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
        
        .log-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .log-table h2 {
            padding: 20px;
            margin: 0;
            font-size: 18px;
            border-bottom: 1px solid #eee;
        }
        
        .log-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .log-table th,
        .log-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .log-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        
        .log-table td {
            font-size: 14px;
            color: #666;
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
    </style>
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    
    <div class="container">
        <%@ include file="/include/sidebar.jsp" %>
        
        <main class="main-content">
            <div class="content-header">
                <h1>접속 통계</h1>
            </div>
            
            <div class="stats-header">
                <div class="filter-group">
                    <!-- 기간 버튼 -->
                    <div class="period-buttons">
                        <button class="period-btn <%= "today".equals(period) ? "active" : "" %>" onclick="setPeriod('today')">오늘</button>
                        <button class="period-btn <%= "week".equals(period) ? "active" : "" %>" onclick="setPeriod('week')">7일</button>
                        <button class="period-btn <%= "month".equals(period) ? "active" : "" %>" onclick="setPeriod('month')">이번 달</button>
                        <button class="period-btn <%= "30days".equals(period) ? "active" : "" %>" onclick="setPeriod('30days')">30일</button>
                        <button class="period-btn <%= "custom".equals(period) ? "active" : "" %>" onclick="toggleDatePicker()">직접 선택</button>
                    </div>
                    
                    <!-- 날짜 선택 -->
                    <div class="date-picker-group" id="datePickerGroup" style="display: <%= "custom".equals(period) ? "flex" : "none" %>;">
                        <input type="date" id="startDate" value="<%= request.getAttribute("startDate") %>">
                        <span>~</span>
                        <input type="date" id="endDate" value="<%= request.getAttribute("endDate") %>">
                        <button class="apply-btn" onclick="applyCustomDate()">조회</button>
                    </div>
                    
                    <% if ("MASTER".equals(adminRole) && companies != null) { %>
                    <select id="companySelect" onchange="applyFilter()">
                        <option value="">전체 업체</option>
                        <% for (Company company : companies) { %>
                        <option value="<%= company.getId() %>" <%= company.getId().equals(companyFilter) ? "selected" : "" %>>
                            <%= company.getName() %>
                        </option>
                        <% } %>
                    </select>
                    <% } %>
                </div>
            </div>
            
            <div class="stats-cards">
                <div class="stat-card">
                    <h3>총 접속 수</h3>
                    <div class="value"><%= totalCount %></div>
                </div>
                
                <% if (dailyStats != null && !dailyStats.isEmpty()) { %>
                <div class="stat-card">
                    <h3>일평균 접속</h3>
                    <div class="value">
                        <%= Math.round((double) totalCount / dailyStats.size()) %>
                    </div>
                </div>
                <% } %>
            </div>
            
            <% if (dailyStats != null && !dailyStats.isEmpty()) { %>
            <div class="chart-container">
                <h2>일별 접속 통계</h2>
                <div class="chart-wrapper">
                    <canvas id="dailyChart"></canvas>
                </div>
            </div>
            <% } %>
            
            <% if (hourlyStats != null && !hourlyStats.isEmpty()) { %>
            <div class="chart-container">
                <h2>시간별 접속 통계 (오늘)</h2>
                <div class="chart-wrapper">
                    <canvas id="hourlyChart"></canvas>
                </div>
            </div>
            <% } %>
            
            <% if ("MASTER".equals(adminRole) && companyStats != null && !companyStats.isEmpty()) { %>
            <div class="chart-container">
                <h2>업체별 접속 통계</h2>
                <div class="chart-wrapper">
                    <canvas id="companyChart"></canvas>
                </div>
            </div>
            <% } %>
            
            <div class="log-table">
                <h2>상세 로그 (<%= totalCount %>건)</h2>
                <table>
                    <thead>
                        <tr>
                            <th>시간</th>
                            <% if ("MASTER".equals(adminRole)) { %>
                            <th>업체</th>
                            <% } %>
                            <th>IP</th>
                            <th>요청 URI</th>
                            <th>Referer</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (logs != null && !logs.isEmpty()) { 
                            for (AccessLog log : logs) { %>
                        <tr>
                            <td><%= log.getCreatedAt() %></td>
                            <% if ("MASTER".equals(adminRole)) { %>
                            <td><%= log.getCompanyId() %></td>
                            <% } %>
                            <td><%= log.getIpAddress() %></td>
                            <td><%= log.getPageUrl() %></td>
                            <td><%= log.getReferrer() != null ? log.getReferrer() : "-" %></td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="<%= "MASTER".equals(adminRole) ? "5" : "4" %>" style="text-align: center; padding: 40px;">
                                접속 로그가 없습니다.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                    <a href="?period=<%= period %><%= companyFilter != null ? "&company=" + companyFilter : "" %>&page=<%= currentPage - 1 %>">이전</a>
                    <% } %>
                    
                    <% for (int i = 1; i <= totalPages; i++) { 
                        if (i == currentPage) { %>
                    <span class="active"><%= i %></span>
                    <% } else { %>
                    <a href="?period=<%= period %><%= companyFilter != null ? "&company=" + companyFilter : "" %>&page=<%= i %>"><%= i %></a>
                    <% } 
                    } %>
                    
                    <% if (currentPage < totalPages) { %>
                    <a href="?period=<%= period %><%= companyFilter != null ? "&company=" + companyFilter : "" %>&page=<%= currentPage + 1 %>">다음</a>
                    <% } %>
                </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <script>
        function setPeriod(period) {
            const companySelect = document.getElementById('companySelect');
            const company = companySelect ? companySelect.value : '';
            
            let url = '?period=' + period;
            if (company) {
                url += '&company=' + company;
            }
            window.location.href = url;
        }
        
        function toggleDatePicker() {
            const datePickerGroup = document.getElementById('datePickerGroup');
            if (datePickerGroup.style.display === 'none') {
                datePickerGroup.style.display = 'flex';
            } else {
                datePickerGroup.style.display = 'none';
            }
        }
        
        function applyCustomDate() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const companySelect = document.getElementById('companySelect');
            const company = companySelect ? companySelect.value : '';
            
            if (!startDate || !endDate) {
                alert('시작일과 종료일을 모두 선택해주세요.');
                return;
            }
            
            let url = '?period=custom&startDate=' + startDate + '&endDate=' + endDate;
            if (company) {
                url += '&company=' + company;
            }
            window.location.href = url;
        }
        
        function applyFilter() {
            const companySelect = document.getElementById('companySelect');
            const company = companySelect ? companySelect.value : '';
            const period = '<%= period %>';
            
            let url = '?period=' + period;
            if (company) {
                url += '&company=' + company;
            }
            window.location.href = url;
        }
        
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
                    label: '접속 수',
                    data: [<% for (int i = 0; i < dailyStats.size(); i++) { 
                        Map<String, Object> stat = dailyStats.get(i);
                        if (i > 0) out.print(", ");
                        out.print(stat.get("count"));
                    } %>],
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
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
        
        <% if (hourlyStats != null && !hourlyStats.isEmpty()) { %>
        // 시간별 차트
        const hourlyCtx = document.getElementById('hourlyChart').getContext('2d');
        new Chart(hourlyCtx, {
            type: 'bar',
            data: {
                labels: [<% for (int i = 0; i < hourlyStats.size(); i++) { 
                    Map<String, Object> stat = hourlyStats.get(i);
                    if (i > 0) out.print(", ");
                    out.print("'" + stat.get("hour") + "시'");
                } %>],
                datasets: [{
                    label: '접속 수',
                    data: [<% for (int i = 0; i < hourlyStats.size(); i++) { 
                        Map<String, Object> stat = hourlyStats.get(i);
                        if (i > 0) out.print(", ");
                        out.print(stat.get("count"));
                    } %>],
                    backgroundColor: '#667eea'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
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
        
        <% if ("MASTER".equals(adminRole) && companyStats != null && !companyStats.isEmpty()) { %>
        // 업체별 차트
        const companyCtx = document.getElementById('companyChart').getContext('2d');
        new Chart(companyCtx, {
            type: 'bar',
            data: {
                labels: [<% for (int i = 0; i < companyStats.size(); i++) { 
                    Map<String, Object> stat = companyStats.get(i);
                    if (i > 0) out.print(", ");
                    out.print("'" + stat.get("companyName") + "'");
                } %>],
                datasets: [{
                    label: '접속 수',
                    data: [<% for (int i = 0; i < companyStats.size(); i++) { 
                        Map<String, Object> stat = companyStats.get(i);
                        if (i > 0) out.print(", ");
                        out.print(stat.get("count"));
                    } %>],
                    backgroundColor: '#764ba2'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                indexAxis: 'y',
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
        <% } %>
    </script>
</body>
</html>
