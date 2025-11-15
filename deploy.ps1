# Cafe24 배포 스크립트
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cafe24 배포 시작" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. 빌드
Write-Host "`n[1/3] Maven 빌드 중..." -ForegroundColor Yellow
mvn clean package -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 빌드 실패!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ 빌드 완료" -ForegroundColor Green

# 2. FTP 업로드
Write-Host "`n[2/3] FTP 업로드 중..." -ForegroundColor Yellow

@"
open shesy11.cafe24.com
shesy11
Rkdwnl24((
cd tomcat/webapps
binary
delete admin.war
put target\admin.war
bye
"@ | Out-File -FilePath temp_ftp.txt -Encoding ASCII

ftp -s:temp_ftp.txt
Remove-Item temp_ftp.txt
Write-Host "✓ 업로드 완료" -ForegroundColor Green

# 3. 배포 대기
Write-Host "`n[3/3] Tomcat 자동 배포 대기 중..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# 4. 배포 확인
Write-Host "`n배포 확인 중..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://shesy11.cafe24.com/admin/" -UseBasicParsing -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ 배포 성공!" -ForegroundColor Green
        Write-Host "`n접속 URL: http://shesy11.cafe24.com/admin/" -ForegroundColor Cyan
        Write-Host "로그인: http://shesy11.cafe24.com/admin/admin/login.jsp" -ForegroundColor Cyan
        Write-Host "DB 테스트: http://shesy11.cafe24.com/admin/test-db.jsp" -ForegroundColor Cyan
    }
} catch {
    Write-Host "✗ 배포 확인 실패: $_" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
