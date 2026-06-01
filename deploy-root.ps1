# Cafe24 배포 스크립트 - ROOT.war (shesy11 계정)
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cafe24 ROOT.war 배포 시작" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$FTP_HOST = "shesy11.cafe24.com"
$FTP_USER = "shesy11"
$FTP_PASS = "Rkdwnl24(("
$TIMESTAMP = Get-Date -Format "yyyyMMdd_HHmmss"
$BACKUP_NAME = "ROOT_backup_$TIMESTAMP.war"

# 1. 빌드
Write-Host "`n[1/5] Maven 빌드 중..." -ForegroundColor Yellow
mvn clean package -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "X 빌드 실패!" -ForegroundColor Red
    exit 1
}
Write-Host "O 빌드 완료 (ROOT.war)" -ForegroundColor Green

# 2. 기존 ROOT.war 백업 (서버에서 다운로드 후 backups/ 에 재업로드)
Write-Host "`n[2/5] 기존 ROOT.war 백업 중... ($BACKUP_NAME)" -ForegroundColor Yellow

@"
open $FTP_HOST
$FTP_USER
$FTP_PASS
cd tomcat/webapps
binary
get ROOT.war temp_ROOT_download.war
bye
"@ | Out-File -FilePath temp_ftp_dl.txt -Encoding ASCII

ftp -s:temp_ftp_dl.txt 2>$null
Remove-Item temp_ftp_dl.txt -ErrorAction SilentlyContinue

if (Test-Path "temp_ROOT_download.war") {
    @"
open $FTP_HOST
$FTP_USER
$FTP_PASS
mkdir tomcat/webapps/backups
cd tomcat/webapps/backups
binary
put temp_ROOT_download.war $BACKUP_NAME
bye
"@ | Out-File -FilePath temp_ftp_backup.txt -Encoding ASCII

    ftp -s:temp_ftp_backup.txt 2>$null
    Remove-Item temp_ftp_backup.txt -ErrorAction SilentlyContinue
    Remove-Item temp_ROOT_download.war -ErrorAction SilentlyContinue
    Write-Host "O 백업 완료 -> tomcat/webapps/backups/$BACKUP_NAME" -ForegroundColor Green
} else {
    Write-Host "! 기존 ROOT.war 없음 - 백업 건너뜀 (최초 배포)" -ForegroundColor Yellow
}

# 3. ROOT 디렉토리 초기화
Write-Host "`n[3/5] ROOT 디렉토리 초기화 중..." -ForegroundColor Yellow

@"
open $FTP_HOST
$FTP_USER
$FTP_PASS
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
Start-Sleep -Seconds 2
Remove-Item temp_ftp_clean.txt -ErrorAction SilentlyContinue
Write-Host "O ROOT 초기화 완료" -ForegroundColor Green

# 4. 신규 ROOT.war 업로드
Write-Host "`n[4/5] ROOT.war 업로드 중..." -ForegroundColor Yellow

@"
open $FTP_HOST
$FTP_USER
$FTP_PASS
cd tomcat/webapps
binary
put target\ROOT.war
bye
"@ | Out-File -FilePath temp_ftp.txt -Encoding ASCII

ftp -s:temp_ftp.txt
Start-Sleep -Seconds 2
Remove-Item temp_ftp.txt -ErrorAction SilentlyContinue
Write-Host "O 업로드 완료" -ForegroundColor Green

# 5. 배포 대기 및 확인
Write-Host "`n[5/5] Tomcat 자동 배포 대기 중..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

Write-Host "`n배포 확인 중..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://$FTP_HOST/admin/login" -UseBasicParsing -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "O 배포 성공!" -ForegroundColor Green
        Write-Host "`n  로그인:   http://$FTP_HOST/admin/login" -ForegroundColor Cyan
        Write-Host "  대시보드: http://$FTP_HOST/admin/dashboard" -ForegroundColor Cyan
        Write-Host "  백업파일: tomcat/webapps/backups/$BACKUP_NAME" -ForegroundColor DarkGray
        Write-Host "  문제 발생시: .\rollback.ps1" -ForegroundColor DarkGray
    }
} catch {
    Write-Host "X 배포 확인 실패: $_" -ForegroundColor Red
    Write-Host "Tomcat이 아직 배포 중일 수 있습니다. 잠시 후 다시 확인해주세요." -ForegroundColor Yellow
    Write-Host "문제가 지속되면 .\rollback.ps1 을 실행하세요." -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Cyan
