# Cafe24 롤백 스크립트 - ROOT.war (shesy11 계정)
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  Cafe24 ROOT.war 롤백" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta

$FTP_HOST = "shesy11.cafe24.com"
$FTP_USER = "shesy11"
$FTP_PASS = "Rkdwnl24(("
$BACKUP_DIR = "tomcat/webapps/backups"

# 1. 백업 목록 조회
Write-Host "`n[1/4] 서버 백업 목록 조회 중..." -ForegroundColor Yellow

@"
open $FTP_HOST
$FTP_USER
$FTP_PASS
cd $BACKUP_DIR
ls
bye
"@ | Out-File -FilePath temp_ftp_list.txt -Encoding ASCII

$listOutput = ftp -s:temp_ftp_list.txt 2>&1
Remove-Item temp_ftp_list.txt -ErrorAction SilentlyContinue

# 백업 파일 파싱 (ROOT_backup_*.war)
$backupFiles = $listOutput | Where-Object { $_ -match "ROOT_backup_\d{8}_\d{6}\.war" } |
    ForEach-Object { ($_ -split "\s+")[-1] } |
    Where-Object { $_ -match "ROOT_backup_" } |
    Sort-Object -Descending

if ($backupFiles.Count -eq 0) {
    Write-Host "X 백업 파일이 없습니다. 롤백할 수 없습니다." -ForegroundColor Red
    exit 1
}

Write-Host "`n사용 가능한 백업 목록:" -ForegroundColor Cyan
for ($i = 0; $i -lt $backupFiles.Count; $i++) {
    $marker = if ($i -eq 0) { " <- 최신" } else { "" }
    Write-Host "  [$($i+1)] $($backupFiles[$i])$marker" -ForegroundColor White
}

# 2. 롤백 대상 선택
Write-Host ""
$selection = Read-Host "롤백할 번호를 입력하세요 (기본값: 1 = 최신 백업)"
if ([string]::IsNullOrWhiteSpace($selection)) { $selection = "1" }

$idx = [int]$selection - 1
if ($idx -lt 0 -or $idx -ge $backupFiles.Count) {
    Write-Host "X 잘못된 번호입니다." -ForegroundColor Red
    exit 1
}

$targetBackup = $backupFiles[$idx]
Write-Host "`n선택된 백업: $targetBackup" -ForegroundColor Cyan

# 3. 확인
$confirm = Read-Host "정말 롤백하시겠습니까? 현재 배포된 ROOT.war가 교체됩니다. (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "롤백이 취소되었습니다." -ForegroundColor Yellow
    exit 0
}

# 4. 백업 파일 다운로드
Write-Host "`n[2/4] 백업 파일 다운로드 중..." -ForegroundColor Yellow

@"
open $FTP_HOST
$FTP_USER
$FTP_PASS
cd $BACKUP_DIR
binary
get $targetBackup rollback_ROOT.war
bye
"@ | Out-File -FilePath temp_ftp_dl.txt -Encoding ASCII

ftp -s:temp_ftp_dl.txt 2>$null
Remove-Item temp_ftp_dl.txt -ErrorAction SilentlyContinue

if (-not (Test-Path "rollback_ROOT.war")) {
    Write-Host "X 백업 파일 다운로드 실패!" -ForegroundColor Red
    exit 1
}
Write-Host "O 다운로드 완료" -ForegroundColor Green

# 5. 현재 ROOT.war 제거 및 롤백 파일 업로드
Write-Host "`n[3/4] 현재 배포 제거 및 롤백 파일 업로드 중..." -ForegroundColor Yellow

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

@"
open $FTP_HOST
$FTP_USER
$FTP_PASS
cd tomcat/webapps
binary
put rollback_ROOT.war ROOT.war
bye
"@ | Out-File -FilePath temp_ftp_up.txt -Encoding ASCII

ftp -s:temp_ftp_up.txt
Start-Sleep -Seconds 2
Remove-Item temp_ftp_up.txt -ErrorAction SilentlyContinue
Remove-Item rollback_ROOT.war -ErrorAction SilentlyContinue
Write-Host "O 롤백 파일 업로드 완료" -ForegroundColor Green

# 6. 배포 대기 및 확인
Write-Host "`n[4/4] Tomcat 재배포 대기 중..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

Write-Host "`n롤백 확인 중..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://$FTP_HOST/admin/login" -UseBasicParsing -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "O 롤백 성공!" -ForegroundColor Green
        Write-Host "`n  로그인:   http://$FTP_HOST/admin/login" -ForegroundColor Cyan
        Write-Host "  복원본:   $targetBackup" -ForegroundColor DarkGray
    }
} catch {
    Write-Host "X 롤백 확인 실패: $_" -ForegroundColor Red
    Write-Host "Tomcat이 아직 배포 중일 수 있습니다. 잠시 후 직접 확인해주세요." -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Magenta
