# Cafe24 배포 스크립트
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cafe24 배포 시작" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. 빌드
Write-Host "`n[1/4] Maven 빌드 중..." -ForegroundColor Yellow
mvn clean package -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 빌드 실패!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ 빌드 완료" -ForegroundColor Green

# 2. ROOT 디렉토리 초기화
Write-Host "`n[2/4] ROOT 디렉토리 초기화 중..." -ForegroundColor Yellow

@"
open shesy11.cafe24.com
shesy11
Rkdwnl24((
cd tomcat/webapps
binary
delete ROOT.war
cd ROOT
mdelete *.*
cd ..
rmdir ROOT
bye
"@ | Out-File -FilePath temp_ftp_clean.txt -Encoding ASCII

ftp -s:temp_ftp_clean.txt 2>$null
Remove-Item temp_ftp_clean.txt
Write-Host "✓ ROOT 초기화 완료" -ForegroundColor Green

# 3. FTP 업로드
Write-Host "`n[3/4] FTP 업로드 중..." -ForegroundColor Yellow

@"
open shesy11.cafe24.com
shesy11
Rkdwnl24((
cd tomcat/webapps
binary
delete admin.war
rmdir admin
put target\admin.war
bye
"@ | Out-File -FilePath temp_ftp.txt -Encoding ASCII

ftp -s:temp_ftp.txt
Remove-Item temp_ftp.txt
Write-Host "✓ 업로드 완료" -ForegroundColor Green

# 4. 배포 대기
Write-Host "`n[4/4] Tomcat 자동 배포 대기 중..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# 5. 배포 확인
Write-Host "`n배포 확인 중..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://shesy11.cafe24.com/admin/admin/login" -UseBasicParsing -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ 배포 성공!" -ForegroundColor Green
        Write-Host "`n로그인: http://shesy11.cafe24.com/admin/admin/login" -ForegroundColor Cyan
        Write-Host "대시보드: http://shesy11.cafe24.com/admin/admin/dashboard" -ForegroundColor Cyan
    }
} catch {
    Write-Host "✗ 배포 확인 실패: $_" -ForegroundColor Red
    Write-Host "Tomcat이 아직 배포 중일 수 있습니다. 잠시 후 다시 확인해주세요." -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Cyan
