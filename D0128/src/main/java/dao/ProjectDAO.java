package dao;

import java.sql.*;
import javax.naming.NamingException;
import util.ConnectionPool;

public class ProjectDAO {
    
    public boolean insert(String projectName, String projectLeader) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO projects(projectName, createDate, projectLeader) VALUES(?, SYSDATE, ?)";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, projectName);
            stmt.setString(2, projectLeader);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }
    
    public boolean exists(String projectID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT projectName FROM projects WHERE projectID = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, projectID);
            rs = stmt.executeQuery();
            return rs.next();
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    // 프로젝트 삭제
    public boolean delete(String projectID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "DELETE FROM projects WHERE projectID = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, projectID);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }
    
    // 전체 프로젝트 반환
    public String getList() throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        StringBuilder str = new StringBuilder("[");
        try {
            String sql = "SELECT projectName, createDate, projectLeader FROM projects";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            int cnt = 0;
            while (rs.next()) {
                if (cnt++ > 0) str.append(", ");
                str.append("{\"projectName\": \"" + rs.getString("projectName") + "\", ")
                   .append("\"createDate\": \"" + rs.getTimestamp("createDate") + "\", ")
                   .append("\"projectLeader\": \"" + rs.getString("projectLeader") + "\"}");
            }
            str.append("]");
            return str.toString();
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

    // 프로젝트 id 로 프로젝트 검색
    public String get(String projectID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT projectID, projectName, createDate, projectLeader FROM projects WHERE projectName = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, projectID);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return "{\"projectID\": \"" + rs.getString("projectID") + "\", " +
                		"\"projectName\": \"" + rs.getString("projectName") + "\", " +
                       "\"createDate\": \"" + rs.getTimestamp("createDate") + "\", " +
                       "\"projectLeader\": \"" + rs.getString("projectLeader") + "\"}";
            }
            return "{}";
        } finally {
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }
    
    // 팀 프로젝트 이름 변경
    public boolean updateProjectName(String oldProjectName, String newProjectName) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE projects SET projectName = ? WHERE projectName = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newProjectName);
            stmt.setString(2, oldProjectName);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }
    
    // 팀 리더 변경
    public boolean updateProjectLeader(String projectName, String newProjectLeader) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE projects SET projectLeader = ? WHERE projectName = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newProjectLeader);
            stmt.setString(2, projectName);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close(); 
            if (conn != null) conn.close();
        }
    }

}
