# JSP 관리자 페이지

## 개발 환경
- Tomcat 10.0.x
- JSP 3.0
- Servlet 5.0
- JDK 17
- MariaDB 10.x
- UTF-8 인코딩
- Cafe24 호스팅 환경 최적화

## 서버 접속 정보

### FTP/SSH
- 주소: shesy11.cafe24.com
- 아이디: shesy11
- FTP PORT: 21
- SSH PORT: 22
- 비밀번호: Rkdwnl24((

### 데이터베이스
- DB Host: shesy11.cafe24.com
- Database: shesy11
- ID: shesy11
- PW: Rkdwnl24((

## 프로젝트 구조
```
/
├── WEB-INF/
│   ├── web.xml
│   ├── classes/
│   └── lib/
├── admin/
│   └── (관리자 페이지)
├── css/
├── js/
└── index.jsp
```

## 프로젝트 구조 (MVC 패턴)
```
src/main/
├── java/
│   ├── controller/     # Servlet (Controller)
│   ├── model/          # VO/DTO (Model)
│   ├── dao/            # Database Access
│   └── util/           # 유틸리티
├── webapp/
│   ├── admin/          # JSP (View)
│   └── WEB-INF/
└── resources/
    └── db.properties   # DB 설정
```

## 배포 방법
```powershell
.\deploy.ps1
```

## 로컬 개발
```bash
mvn jetty:run
```
- 로컬: http://localhost:8080/admin/login
- Cafe24: http://shesy11.cafe24.com/admin/admin/login

## DB 초기 설정
http://localhost:8080/setup_admin.jsp 접속
- 계정: admin / admin1234

## 환경별 DB 자동 분기
- 로컬: shesy11.cafe24.com:3306
- Cafe24: localhost:3306
