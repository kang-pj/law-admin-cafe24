<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>서버 IP 확인</title>
</head>
<body>
    <h1>서버 IP 정보</h1>
    
    <h2>클라이언트 IP (요청자):</h2>
    <p><%= request.getRemoteAddr() %></p>
    
    <h2>서버 호스트명:</h2>
    <p><%= InetAddress.getLocalHost().getHostName() %></p>
    
    <h2>서버 로컬 IP:</h2>
    <p><%= InetAddress.getLocalHost().getHostAddress() %></p>
    
    <h2>서버 외부 IP (추정):</h2>
    <%
    try {
        URL whatismyip = new URL("http://checkip.amazonaws.com");
        BufferedReader in = new BufferedReader(new InputStreamReader(whatismyip.openStream()));
        String ip = in.readLine();
        out.println("<p>" + ip + "</p>");
    } catch (Exception e) {
        out.println("<p>외부 IP 확인 실패: " + e.getMessage() + "</p>");
    }
    %>
    
    <h2>모든 네트워크 인터페이스:</h2>
    <%
    java.util.Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
    while (interfaces.hasMoreElements()) {
        NetworkInterface iface = interfaces.nextElement();
        if (iface.isUp()) {
            out.println("<h3>" + iface.getDisplayName() + "</h3>");
            java.util.Enumeration<InetAddress> addresses = iface.getInetAddresses();
            while (addresses.hasMoreElements()) {
                InetAddress addr = addresses.nextElement();
                out.println("<p>" + addr.getHostAddress() + "</p>");
            }
        }
    }
    %>
</body>
</html>
