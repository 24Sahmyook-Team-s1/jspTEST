package dao;

import java.sql.*;
import javax.naming.NamingException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import util.ConnectionPool;

public class UserDAO {

    public boolean insert(String uid, String jsonstr) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO user2(id, jsonstr) VALUES(?, ?)";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);
            stmt.setString(2, jsonstr);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    // ID 존재 여부 확인 메서드
    public boolean exists(String uid) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT id FROM user2 WHERE id = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);
            rs = stmt.executeQuery();
            return rs.next(); // 존재하면 true 반환
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    public boolean delete(String uid) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "DELETE FROM user2 WHERE id = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    public int login(String uid, String upass) throws NamingException, SQLException, ParseException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT jsonstr FROM user2 WHERE id = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);
            rs = stmt.executeQuery();
            if (!rs.next()) return 1;

            String jsonstr = rs.getString("jsonstr");
            JSONObject obj = (JSONObject) (new JSONParser()).parse(jsonstr);
            String pass = obj.get("password").toString();
            if (!upass.equals(pass)) return 2;

            return 0;
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    // 전체 사용자 목록 조회
    public String getList() throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        StringBuilder str = new StringBuilder("[");
        try {
            String sql = "SELECT * FROM user2";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            int cnt = 0;
            while (rs.next()) {
                if (cnt++ > 0) str.append(", ");
                str.append(rs.getString("jsonstr"));
            }
            str.append("]");
            return str.toString();
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    // 특정 사용자 정보 조회
    public String get(String uid) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT jsonstr FROM user2 WHERE id = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);
            rs = stmt.executeQuery();
            return rs.next() ? rs.getString("jsonstr") : "{}"; // 사용자 정보가 없을 경우 빈 JSON 반환
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    // 사용자 정보 업데이트
    public boolean update(String uid, String jsonstr) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE user2 SET jsonstr = ? WHERE id = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, jsonstr);
            stmt.setString(2, uid);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }
    
    public String findPassword(String name, String email) throws NamingException, SQLException, ParseException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = ConnectionPool.get();
            if (conn == null) {
                System.out.println("ConnectionPool.get() returned null.");
                return null;
            }
            // CLOB을 문자열로 변환하여 검색 (최대 4000자)
            String sql = "SELECT jsonstr FROM user2 " +
                         "WHERE DBMS_LOB.SUBSTR(jsonstr, 4000, 1) LIKE ? " +
                         "AND DBMS_LOB.SUBSTR(jsonstr, 4000, 1) LIKE ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%\"name\":\"" + name + "\"%");
            // 기존에는 email을 "%\"email\":\"" + email + "\"%"로 검색했지만,
            // 데이터베이스에는 이메일 정보가 "id" 키에 저장되어 있으므로 아래와 같이 수정합니다.
            stmt.setString(2, "%\"id\":\"" + email + "\"%");
            
            System.out.println("Executing SQL: " + stmt.toString());
            rs = stmt.executeQuery();

            while (rs.next()) {
                String jsonstr = rs.getString("jsonstr");
                if (jsonstr == null) continue;
                // 디버깅: 실제 JSON 데이터를 출력
                System.out.println("Retrieved JSON: " + jsonstr);
                JSONObject obj = (JSONObject) new JSONParser().parse(jsonstr);

                // 이름과 이메일을 비교할 때, 이메일은 "id" 키에 저장되어 있습니다.
                if (obj.get("name") != null && obj.get("id") != null &&
                    obj.get("name").toString().equals(name) &&
                    obj.get("id").toString().equals(email)) {
                    return obj.get("password").toString();
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
        return null; // 일치하는 사용자를 찾지 못한 경우
    }
    
    
    


}