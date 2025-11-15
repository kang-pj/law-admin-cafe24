package util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static String driver;
    private static String url;
    private static String username;
    private static String password;
    
    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class.getClassLoader()
                .getResourceAsStream("db.properties");
            props.load(is);
            
            driver = props.getProperty("db.driver");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");
            
            // 환경 감지: Cafe24 서버인지 로컬인지 확인
            String osName = System.getProperty("os.name").toLowerCase();
            String userHome = System.getProperty("user.home");
            
            // Cafe24 서버 환경 감지 (Linux + cafe24 경로)
            boolean isCafe24Server = osName.contains("linux") && 
                                    (userHome.contains("cafe24") || userHome.contains("shesy11"));
            
            if (isCafe24Server) {
                // Cafe24 서버: localhost 사용
                url = props.getProperty("db.url.server");
                System.out.println("[DBConnection] Running on Cafe24 Server - Using localhost");
            } else {
                // 로컬 개발 환경: 외부 접속
                url = props.getProperty("db.url.local");
                System.out.println("[DBConnection] Running on Local - Using remote host");
            }
            
            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
    
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
