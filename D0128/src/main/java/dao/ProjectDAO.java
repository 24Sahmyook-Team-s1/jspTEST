package dao;

import java.sql.*;
import javax.naming.NamingException;
import util.ConnectionPool;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ProjectDAO {

    // 프로젝트 추가
    public boolean addProject(String projectName, String projectLeader) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO projects (ProjectName, CreatedAt, ProjectLeader) VALUES (?, SYSDATE, ?)";
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

    // 프로젝트 이름으로 존재 여부 확인
    public boolean isProjectExists(String projectName) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT ProjectName FROM projects WHERE ProjectName = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, projectName);
            rs = stmt.executeQuery();
            return rs.next();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    // 프로젝트 ID로 프로젝트 삭제
    public boolean removeProjectById(int projectID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "DELETE FROM projects WHERE ProjectID = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, projectID);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    // 모든 프로젝트 리스트 조회
    public JSONArray getAllProjects() throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONArray jsonResult = new JSONArray();

        try {
            String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt, ProjectLeader FROM projects ORDER BY CreatedAt DESC, ProjectID ASC";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject project = new JSONObject();
                project.put("id", rs.getInt("ProjectID"));
                project.put("name", rs.getString("ProjectName"));
                project.put("created_at", rs.getString("CreatedAt"));
                project.put("projectLeader", rs.getString("ProjectLeader"));
                jsonResult.add(project);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return jsonResult; // JSON 배열 반환
    }

    // 프로젝트 ID로 프로젝트 조회
    public JSONObject getProjectById(int projectID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONObject project = null;

        try {
            String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt, ProjectLeader FROM projects WHERE ProjectID = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, projectID);
            rs = stmt.executeQuery();

            if (rs.next()) {
                project = new JSONObject();
                project.put("id", rs.getInt("ProjectID"));
                project.put("name", rs.getString("ProjectName"));
                project.put("created_at", rs.getString("CreatedAt"));
                project.put("projectLeader", rs.getString("ProjectLeader"));
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return project; // JSON 객체 반환, 없으면 null
    }

    // 프로젝트 이름 변경
    public boolean updateProjectNameById(int projectID, String newProjectName) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE projects SET ProjectName = ? WHERE ProjectID = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newProjectName);
            stmt.setInt(2, projectID);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    // 프로젝트 리더 변경
    public boolean updateProjectLeaderById(int projectID, String newProjectLeader) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE projects SET ProjectLeader = ? WHERE ProjectID = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newProjectLeader);
            stmt.setInt(2, projectID);
            int count = stmt.executeUpdate();
            return (count == 1);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
}
