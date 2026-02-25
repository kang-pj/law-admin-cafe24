# Tomcat catalina.out 로그 중지 설정 가이드

## 문제
Tomcat의 catalina.out 로그 파일이 계속 쌓여서 디스크 용량을 차지하는 문제

## 해결 방법

### 1. SSH로 서버 접속
```bash
ssh shesy22@shesy22.cafe24.com
# 비밀번호: Rkdwnl24!!
```

### 2. catalina.sh 파일 편집
```bash
vi ./tomcat/bin/catalina.sh
```

### 3. CATALINA_OUT 설정 변경
파일 내에서 `CATALINA_OUT` 설정을 찾아 다음과 같이 수정:

**기존:**
```bash
CATALINA_OUT="$CATALINA_BASE"/logs/catalina.out
```

**변경 후:**
```bash
CATALINA_OUT=/dev/null
```

### 4. vi 편집기 사용법
1. `/CATALINA_OUT` 입력하여 검색
2. `i` 키를 눌러 편집 모드 진입
3. 해당 라인 수정
4. `ESC` 키를 눌러 편집 모드 종료
5. `:wq` 입력하여 저장 및 종료

### 5. Tomcat 재시작
```bash
./tomcat/bin/shutdown.sh
./tomcat/bin/startup.sh
```

또는 Cafe24 관리자 페이지에서 Tomcat 재시작

### 6. 기존 로그 파일 삭제 (선택사항)
```bash
rm ./tomcat/logs/catalina.out
```

## 참고사항
- `/dev/null`로 설정하면 로그가 기록되지 않고 버려집니다
- 디버깅이 필요한 경우 임시로 원래 설정으로 되돌릴 수 있습니다
- 다른 로그 파일들(access log 등)은 영향받지 않습니다

## 대안: 로그 로테이션 설정
로그를 완전히 끄지 않고 관리하고 싶다면:

```bash
# logrotate 설정 (Cafe24에서 지원하는 경우)
# 또는 cron으로 주기적으로 로그 삭제
0 0 * * 0 rm -f ~/tomcat/logs/catalina.out
```
