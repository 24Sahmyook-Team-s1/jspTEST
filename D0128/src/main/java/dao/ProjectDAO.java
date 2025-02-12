package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import dao.TeamDAO;
import javax.naming.NamingException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import util.ConnectionPool;

public class ProjectDAO {

    // ✅ 프로젝트 존재 여부 확인
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

    // ✅ 프로젝트 삭제 (ID 기준)
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

    // ✅ 프로젝트 조회 (ID 기준)
    public JSONObject getProjectById(int projectID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONObject project = null;

        try {
            String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt, AdminUserId " +
                         "FROM projects WHERE ProjectID = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, projectID);
            rs = stmt.executeQuery();

            if (rs.next()) {
                project = new JSONObject();
                project.put("id", rs.getInt("ProjectID"));
                project.put("name", rs.getString("ProjectName"));
                project.put("created_at", rs.getString("CreatedAt"));
                project.put("adminuserid", rs.getString("AdminUserId"));
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return project;
    }

    // ✅ 사용자 ID 기준 참여 프로젝트 조회
    public JSONArray getProjectsByUserId(String userId) throws NamingException, SQLException {
        JSONArray projectList = new JSONArray();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionPool.get();
            String sql = "SELECT ProjectID FROM teamMembers WHERE UserID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int projectId = rs.getInt("ProjectID");
                JSONObject projectData = getProjectById(projectId);
                if (projectData != null) {
                    projectList.add(projectData);
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return projectList;
    }

    // ✅ 프로젝트 추가 (시퀀스 사용)
    public boolean addProject(String name, String adminUserID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean isSuccess = false;
        TeamDAO teamdao = new TeamDAO();

        try {
            conn = ConnectionPool.get();

            // 🔹 AdminUserID가 존재하는지 확인
            String checkUserSql = "SELECT USERID FROM User2 WHERE USERID = ?";
            stmt = conn.prepareStatement(checkUserSql);
            stmt.setString(1, adminUserID);
            rs = stmt.executeQuery();

            if (!rs.next()) {
                return false;
            }
            rs.close();
            stmt.close();

            // 🔹 시퀀스를 사용하여 ProjectID 가져오기
            String getNextIdSql = "SELECT projects_seq.NEXTVAL FROM dual";
            stmt = conn.prepareStatement(getNextIdSql);
            rs = stmt.executeQuery();

            int projectId = -1;
            if (rs.next()) {
                projectId = rs.getInt(1);
            }
            rs.close();
            stmt.close();

            // 🔹 프로젝트 추가
            String insertProjectSql = "INSERT INTO Projects (ProjectID, ProjectName, AdminUserID, CreatedAt) VALUES (?, ?, ?, SYSDATE)";
            stmt = conn.prepareStatement(insertProjectSql);
            stmt.setInt(1, projectId);
            stmt.setString(2, name);
            stmt.setString(3, adminUserID);

            int result = stmt.executeUpdate();
            if (result == 1) {
                isSuccess = teamdao.addTeamMember(projectId, adminUserID);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return isSuccess;
    }

    // ✅ 모든 프로젝트 조회
    public JSONArray getAllProjects() throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONArray projectArray = new JSONArray();

        try {
            conn = ConnectionPool.get();
            String sql = "SELECT ProjectID, ProjectName, AdminUserID, CreatedAt FROM Projects ORDER BY ProjectID DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject project = new JSONObject();
                int projectId = rs.getInt("ProjectID");
                project.put("id", projectId);
                project.put("name", rs.getString("ProjectName"));
                project.put("owner", rs.getString("AdminUserID"));
                project.put("createdAt", rs.getDate("CreatedAt").toString());

                // 🔹 간트차트용 스케줄 정보 추가
                JSONArray schedule = getScheduleByProjectId(projectId, conn);
                project.put("schedule", schedule);

                projectArray.add(project);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return projectArray;
    }

    // ✅ 프로젝트 스케줄 조회 (간트차트)
    private JSONArray getScheduleByProjectId(int projectId, Connection conn) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONArray scheduleArray = new JSONArray();

        try {
            String sql = "SELECT START_DATE, END_DATE FROM Schedule WHERE ProjectID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, projectId);
            rs = stmt.executeQuery();

            boolean[] weeklySchedule = new boolean[5];

            while (rs.next()) {
                Date startDate = rs.getDate("START_DATE");
                Date endDate = rs.getDate("END_DATE");
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(startDate);

                while (!calendar.getTime().after(endDate)) {
                    int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
                    if (dayOfWeek >= Calendar.MONDAY && dayOfWeek <= Calendar.FRIDAY) {
                        weeklySchedule[dayOfWeek - Calendar.MONDAY] = true;
                    }
                    calendar.add(Calendar.DATE, 1);
                }
            }

            for (boolean dayActive : weeklySchedule) {
                scheduleArray.add(dayActive);
            }

        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }

        return scheduleArray;
    }
}
