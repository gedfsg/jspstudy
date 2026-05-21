package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
    private static final String URL    = "jdbc:oracle:thin:@14.37.23.166:1521/XE";
    private static final String USER   = "scott";
    private static final String PASS   = "tiger";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Oracle JDBC 드라이버 로드 실패", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        }
    }
}