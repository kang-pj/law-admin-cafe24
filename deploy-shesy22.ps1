# Cafe24 간단 배포 스크립트 (shesy22)
Write-Host "배포 시작..." -ForegroundColor Cyan

# 빌드
Write-Host "빌드 중..." -ForegroundColor Yellow
mvn clean package -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "빌드 실패!" -ForegroundColor Red
    exit 1
}
Write-Host "빌드 완료" -ForegroundColor Green

# FTP 업로드
Write-Host "업로드 중..." -ForegroundColor Yellow

@"
open shesy22.cafe24.com
shesy22
Rkdwnl24!!
cd tomcat/webapps
binary
delete ROOT.war
put target\ROOT.war
bye
"@ | Out-File -FilePath temp_ftp.txt -Encoding ASCII

ftp -s:temp_ftp.txt
Remove-Item temp_ftp.txt -ErrorAction SilentlyContinue

Write-Host "배포 완료!" -ForegroundColor Green
Write-Host "URL: http://shesy22.cafe24.com/admin/login" -ForegroundColor Cyan
