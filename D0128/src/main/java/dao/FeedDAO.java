package dao;

import java.sql.*;
import java.util.ArrayList;

import javax.naming.NamingException;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import util.*;

public class FeedDAO {

	public boolean insert(String jsonstr) throws NamingException, SQLException, ParseException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            synchronized(this) {
                conn = ConnectionPool.get();

                // phase 1. add "no" property -----------------------------
                String sql = "SELECT no FROM feed ORDER BY no DESC LIMIT 1";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();
                
                int max = (!rs.next()) ? 0 : rs.getInt("no");
                stmt.close(); rs.close();
                
                JSONParser parser = new JSONParser();
                JSONObject jsonobj = (JSONObject) parser.parse(jsonstr);
                jsonobj.put("no", max + 1);

                // phase 2. add "user" property ------------------------------
                String uid = jsonobj.get("id").toString();
                
                sql = "SELECT jsonstr FROM user2 WHERE id = ?"; // user -> user2 변경
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, uid);
                rs = stmt.executeQuery();
                
                if (rs.next()) {
                    String usrstr = rs.getString("jsonstr");
                    JSONObject usrobj = (JSONObject) parser.parse(usrstr);
                    usrobj.remove("password");
                    usrobj.remove("ts");
                    jsonobj.put("user", usrobj);
                }
                stmt.close(); rs.close();
                    
                // phase 3. insert jsonobj to the table ------------------------
                sql = "INSERT INTO feed(no, id, jsonstr) VALUES(?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, max + 1);
                stmt.setString(2, uid);
                stmt.setString(3, jsonobj.toJSONString());
                    
                int count = stmt.executeUpdate();
                return (count == 1);
            }
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    public String getList() throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT * FROM feed ORDER BY no DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            StringBuilder str = new StringBuilder("[");
            int cnt = 0;
            while(rs.next()) {
                if (cnt++ > 0) str.append(", ");
                str.append(rs.getString("jsonstr"));
            }
            return str.append("]").toString();
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    public String getGroup(String frids, String maxNo) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            // IN 연산자의 문자열을 작은따옴표로 변경
            String formattedFrids = frids.replace("\"", "'");

            // Oracle에서는 ROWNUM을 사용하여 제한
            String sql = "SELECT jsonstr FROM (SELECT jsonstr FROM feed WHERE id IN(" + formattedFrids + ")";
            
            if (maxNo != null) {
                sql += " AND no < " + maxNo;
            }

            sql += " ORDER BY no DESC) WHERE ROWNUM <= 3"; // ROWNUM을 사용하여 3개 제한

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
                
            String str = "[";
            int cnt = 0;
            while(rs.next()) {
                if (cnt++ > 0) str += ", ";
                str += rs.getString("jsonstr");
            }
            return str + "]";
                
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

}
