# Cafe24 강제 재배포 스크립트
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cafe24 강제 재배포" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. 빌드
Write-Host "`n[1/4] Maven 빌드 중..." -ForegroundColor Yellow
mvn clean package -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "빌드 실패!" -ForegroundColor Red
    exit 1
}
Write-Host "빌드 완료" -ForegroundColor Green

# 2. 기존 배포 삭제
Write-Host "`n[2/4] 기존 배포 삭제 중..." -ForegroundColor Yellow

$ftpDelete = @"
open shesy11.cafe24.com
shesy11
Rkdwnl24((
cd tomcat/webapps
binary
delete admin.war
rmdir admin
bye
"@

$ftpDelete | Out-File -FilePath temp_ftp_delete.txt -Encoding ASCII
ftp -s:temp_ftp_delete.txt
Remove-Item temp_ftp_delete.txt
Write-Host "기존 배포 삭제 완료" -ForegroundColor Green

Start-Sleep -Seconds 3

# 3. 새 WAR 업로드
Write-Host "`n[3/4] 새 WAR 업로드 중..." -ForegroundColor Yellow

$ftpUpload = @"
open shesy11.cafe24.com
shesy11
Rkdwnl24((
cd tomcat/webapps
binary
put target\admin.war
bye
"@

$ftpUpload | Out-File -FilePath temp_ftp_upload.txt -Encoding ASCII
ftp -s:temp_ftp_upload.txt
Remove-Item temp_ftp_upload.txt
Write-Host "업로드 완료" -ForegroundColor Green

# 4. 배포 대기
Write-Host "`n[4/4] Tomcat 자동 배포 대기 중..." -ForegroundColor Yellow
Write-Host "15초 대기..." -ForegroundColor Gray
Start-Sleep -Seconds 15

# 5. 배포 확인
Write-Host "`n배포 확인 중..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://shesy11.cafe24.com/admin/admin/dashboard" -UseBasicParsing -TimeoutSec 10
    if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 302) {
        Write-Host "배포 성공!" -ForegroundColor Green
        Write-Host "`n접속 URL:" -ForegroundColor Cyan
        Write-Host "  로그인: http://shesy11.cafe24.com/admin/admin/login" -ForegroundColor White
        Write-Host "  대시보드: http://shesy11.cafe24.com/admin/admin/dashboard" -ForegroundColor White
    }
} catch {
    Write-Host "배포 확인 실패 (Tomcat 재시작 필요할 수 있음)" -ForegroundColor Yellow
    Write-Host "  수동 확인: http://shesy11.cafe24.com/admin/admin/login" -ForegroundColor White
}

Write-Host "`n========================================" -ForegroundColor Cyan
