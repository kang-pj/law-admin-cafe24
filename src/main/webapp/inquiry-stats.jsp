<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>전문 통계</title>
    <style>
        <%@ include file="/css/common.css" %>
    </style>
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 24px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .stat-card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        
        .stat-icon.blue {
            background: #e7f5ff;
        }
        
        .stat-icon.green {
            background: #d3f9d8;
        }
        
        .stat-icon.orange {
            background: #fff3bf;
        }
        
        .stat-icon.purple {
            background: #f3e5f5;
        }
        
        .stat-title {
            font-size: 14px;
            color: #6c757d;
            font-weight: 500;
        }
        
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #212529;
            margin-bottom: 8px;
        }
        
        .stat-change {
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .stat-change.up {
            color: #2f9e44;
        }
        
        .stat-change.down {
            color: #c92a2a;
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
        
        .chart-filters {
            display: flex;
            gap: 8px;
        }
        
        .filter-btn {
            padding: 6px 14px;
            border: 1px solid #dee2e6;
            background: white;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .filter-btn:hover {
            background: #f8f9fa;
        }
        
        .filter-btn.active {
            background: #0d6efd;
            color: white;
            border-color: #0d6efd;
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
        
        .table-container {
            background: white;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            overflow: hidden;
        }
        
        .table-header {
            padding: 16px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            font-weight: 600;
            color: #212529;
        }
        
        .stats-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .stats-table th {
            padding: 12px 16px;
            background: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
            font-size: 13px;
            font-weight: 600;
            color: #495057;
            text-align: left;
        }
        
        .stats-table td {
            padding: 12px 16px;
            border-bottom: 1px solid #f1f3f5;
            font-size: 14px;
            color: #495057;
        }
        
        .stats-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
            margin-top: 4px;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #0d6efd, #0b5ed7);
            border-radius: 4px;
            transition: width 0.3s;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .badge-primary {
            background: #e7f5ff;
            color: #1971c2;
        }
        
        .badge-success {
            background: #d3f9d8;
            color: #2f9e44;
        }
        
        .badge-warning {
            background: #fff3bf;
            color: #856404;
        }
    </style>
</head>
<body>
    <%@ include file="/include/header.jsp" %>
    <%@ include file="/include/sidebar.jsp" %>
    
    <div class="main-content">
        <h2 class="page-title">📊 전문 통계</h2>
        
        <!-- 주요 지표 카드 -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-icon blue">📝</div>
                    <div class="stat-title">총 전문 수</div>
                </div>
                <div class="stat-value">1,234</div>
                <div class="stat-change up">
                    ↑ 12.5% <span style="color: #6c757d;">전월 대비</span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-icon green">✅</div>
                    <div class="stat-title">처리 완료</div>
                </div>
                <div class="stat-value">987</div>
                <div class="stat-change up">
                    ↑ 8.3% <span style="color: #6c757d;">전월 대비</span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-icon orange">⏳</div>
                    <div class="stat-title">처리 중</div>
                </div>
                <div class="stat-value">156</div>
                <div class="stat-change down">
                    ↓ 5.2% <span style="color: #6c757d;">전월 대비</span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-icon purple">⏱️</div>
                    <div class="stat-title">평균 처리 시간</div>
                </div>
                <div class="stat-value">2.4<span style="font-size: 18px; color: #6c757d;">일</span></div>
                <div class="stat-change up">
                    ↑ 0.3일 <span style="color: #6c757d;">전월 대비</span>
                </div>
            </div>
        </div>
        
        <!-- 월별 전문 추이 차트 -->
        <div class="chart-container">
            <div class="chart-header">
                <div class="chart-title">월별 전문 추이</div>
                <div class="chart-filters">
                    <button class="filter-btn active">최근 6개월</button>
                    <button class="filter-btn">최근 1년</button>
                    <button class="filter-btn">전체</button>
                </div>
            </div>
            <div class="chart-placeholder">
                📈 차트 영역 (Chart.js 또는 다른 차트 라이브러리 연동 필요)
            </div>
        </div>
        
        <!-- 전문 유형별 통계 -->
        <div class="chart-container">
            <div class="chart-header">
                <div class="chart-title">전문 유형별 통계</div>
            </div>
            <table class="stats-table">
                <thead>
                    <tr>
                        <th>전문 유형</th>
                        <th>건수</th>
                        <th>비율</th>
                        <th>진행률</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><span class="badge badge-primary">일반 문의</span></td>
                        <td><strong>456</strong></td>
                        <td>37%</td>
                        <td>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 37%"></div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="badge badge-success">자가진단</span></td>
                        <td><strong>389</strong></td>
                        <td>31%</td>
                        <td>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 31%"></div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="badge badge-warning">카카오톡</span></td>
                        <td><strong>234</strong></td>
                        <td>19%</td>
                        <td>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 19%"></div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="badge badge-primary">이메일</span></td>
                        <td><strong>155</strong></td>
                        <td>13%</td>
                        <td>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 13%"></div>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <!-- 상태별 통계 -->
        <div class="chart-container">
            <div class="chart-header">
                <div class="chart-title">상태별 통계</div>
            </div>
            <div class="chart-placeholder">
                🥧 파이 차트 영역 (대기중 / 처리중 / 완료 비율)
            </div>
        </div>
    </div>
    
    <script>
        // 필터 버튼 활성화
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                // TODO: 실제 데이터 필터링 로직
            });
        });
    </script>
</body>
</html>
