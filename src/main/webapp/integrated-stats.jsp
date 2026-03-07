<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
    Integer totalVisits = (Integer) request.getAttribute("totalVisits");
    Integer todayVisits = (Integer) request.getAttribute("todayVisits");
    Integer uniqueVisitors = (Integer) request.getAttribute("uniqueVisitors");
    Integer totalLeads = (Integer) request.getAttribute("totalLeads");
    Integer todayLeads = (Integer) request.getAttribute("todayLeads");
    Integer pendingLeads = (Integer) request.getAttribute("pendingLeads");
    Integer completedLeads = (Integer) request.getAttribute("completedLeads");
    
    @SuppressWarnings("unchecked")
    Map<String, Object> conversionData = (Map<String, Object>) request.getAttribute("conversionData");
    
    @SuppressWarnings("unchecked")
    Map<String, Integer> dailyVisits = (Map<String, Integer>) request.getAttribute("dailyVisits");
    
    @SuppressWarnings("unchecked")
    Map<String, Integer> dailyLeads = (Map<String, Integer>) request.getAttribute("dailyLeads");
    
    @SuppressWarnings("unchecked")
    Map<String, Integer> sourceStats = (Map<String, Integer>) request.getAttribute("sourceStats");
    
    Integer period = (Integer) request.getAttribute("period");
    
    if (totalVisits == null) totalVisits = 0;
    if (todayVisits == null) todayVisits = 0;
    if (uniqueVisitors == null) uniqueVisitors = 0;
    if (totalLeads == null) totalLeads = 0;
    if (todayLeads == null) todayLeads = 0;
    if (pendingLeads == null) pendingLeads = 0;
    if (completedLeads == null) completedLeads = 0;
    if (period == null) period = 7;
    
    double conversionRate = 0;
    if (conversionData != null) {
        conversionRate = (Double) conversionData.getOrDefault("conversionRate", 0.0);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>통합 통계</title>
    <style>
        <%@ include file="/css/common.css" %>
    </style>
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        
        .stat-card h3 {
            font-size: 13px;
            color: #6c757d;
            margin-bottom: 12px;
            font-weight: 500;
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #212529;
            margin-bottom: 4px;
        }
        
        .stat-label {
            font-size: 12px;
            color: #6c757d;
        }
        
        .conversion-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .conversion-card h3 {
            color: rgba(255,255,255,0.9);
        }
        
        .conversion-card .stat-value {
            color: white;
        }
        
        .conversion-card .stat-label {
            color: rgba(255,255,255,0.8);
        }
        
        .chart-container {
            background: white;
            padding: 24px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            margin-bottom: 20px;
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .chart-title {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
        }
        
        .period-filters {
            display: flex;
            gap: 8px;
        }
        
        .period-btn {
            padding: 6px 14px;
            border: 1px solid #dee2e6;
            background: white;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            color: #495057;
        }
        
        .period-btn:hover {
            background: #f8f9fa;
        }
        
        .period-btn.active {
            background: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }
        
        .comparison-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .comparison-table th,
        .comparison-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #f1f3f5;
        }
        
        .comparison-table th {
            background: #f8f9fa;
            font-weight: 600;
            font-size: 13px;
            color: #495057;
        }
        
        .comparison-table td {
            font-size: 14px;
        }
        
        .trend-up {
            color: #2f9e44;
        }
        
        .trend-down {
            color: #c92a2a;
        }
        
        .chart-placeholder {
            height: 300px;
            background: #f8f9fa;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    <%@ include file="/include/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="content-header">
            <h2 class="page-title">📊 통합 통계 (접속 + 접수)</h2>
            <div class="period-filters">
                <a href="?period=7" class="period-btn <%= period == 7 ? "active" : "" %>">최근 7일</a>
                <a href="?period=30" class="period-btn <%= period == 30 ? "active" : "" %>">최근 30일</a>
                <a href="?period=90" class="period-btn <%= period == 90 ? "active" : "" %>">최근 90일</a>
            </div>
        </div>
        
        <!-- 주요 지표 -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>총 방문 수</h3>
                <div class="stat-value"><%= totalVisits %></div>
                <div class="stat-label">전체 페이지뷰</div>
            </div>
            
            <div class="stat-card">
                <h3>오늘 방문</h3>
                <div class="stat-value"><%= todayVisits %></div>
                <div class="stat-label">Today</div>
            </div>
            
            <div class="stat-card">
                <h3>총 접수 수</h3>
                <div class="stat-value"><%= totalLeads %></div>
                <div class="stat-label">전체 상담 신청</div>
            </div>
            
            <div class="stat-card">
                <h3>오늘 접수</h3>
                <div class="stat-value"><%= todayLeads %></div>
                <div class="stat-label">Today</div>
            </div>
            
            <div class="stat-card conversion-card">
                <h3>전환율</h3>
                <div class="stat-value"><%= String.format("%.2f", conversionRate) %>%</div>
                <div class="stat-label">방문 대비 접수 비율</div>
            </div>
            
            <div class="stat-card">
                <h3>처리 대기</h3>
                <div class="stat-value"><%= pendingLeads %></div>
                <div class="stat-label">미처리 접수</div>
            </div>
        </div>
        
        <!-- 일별 비교 차트 -->
        <div class="chart-container">
            <div class="chart-header">
                <div class="chart-title">일별 방문 vs 접수 추이</div>
            </div>
            <div class="chart-placeholder">
                📈 차트 영역 (Chart.js 연동 필요)<br>
                파란선: 방문 수 / 빨간선: 접수 수
            </div>
        </div>
        
        <!-- 일별 데이터 테이블 -->
        <div class="chart-container">
            <div class="chart-header">
                <div class="chart-title">일별 상세 데이터</div>
            </div>
            <table class="comparison-table">
                <thead>
                    <tr>
                        <th>날짜</th>
                        <th>방문 수</th>
                        <th>접수 수</th>
                        <th>전환율</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (dailyVisits != null && !dailyVisits.isEmpty()) {
                        for (String date : dailyVisits.keySet()) {
                            int visits = dailyVisits.get(date);
                            int leads = dailyLeads != null ? dailyLeads.getOrDefault(date, 0) : 0;
                            double rate = visits > 0 ? (double) leads / visits * 100 : 0;
                    %>
                    <tr>
                        <td><%= date %></td>
                        <td><%= visits %></td>
                        <td><%= leads %></td>
                        <td><%= String.format("%.2f", rate) %>%</td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 40px; color: #adb5bd;">
                            데이터가 없습니다.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <!-- 유입 경로별 통계 -->
        <div class="chart-container">
            <div class="chart-header">
                <div class="chart-title">유입 경로별 접수 현황</div>
            </div>
            <table class="comparison-table">
                <thead>
                    <tr>
                        <th>유입 경로</th>
                        <th>접수 수</th>
                        <th>비율</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (sourceStats != null && !sourceStats.isEmpty()) {
                        int totalSourceLeads = sourceStats.values().stream().mapToInt(Integer::intValue).sum();
                        for (Map.Entry<String, Integer> entry : sourceStats.entrySet()) {
                            double percentage = totalSourceLeads > 0 ? (double) entry.getValue() / totalSourceLeads * 100 : 0;
                    %>
                    <tr>
                        <td><%= entry.getKey() %></td>
                        <td><%= entry.getValue() %></td>
                        <td><%= String.format("%.1f", percentage) %>%</td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="3" style="text-align: center; padding: 40px; color: #adb5bd;">
                            데이터가 없습니다.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
