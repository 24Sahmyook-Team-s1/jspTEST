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


    // 프로젝트 ID로 프로젝트 조회
    public JSONObject getProjectById(int projectID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONObject project = null;

        try {
            String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt, AdminUserId FROM projects WHERE ProjectID = ?";
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

        return project; // JSON 객체 반환, 없으면 null
    }
    
    public String getProjectByprojectname(String projectName) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		StringBuilder jsonResult = new StringBuilder("[");
		try {
			String sql = "SELECT projectID, projectName, createDat, adminuserid FROM projects WHERE projectName = ?";
			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, projectName);
			rs = stmt.executeQuery();			
			int count = 0;
			while (rs.next()) {
				if (count++ > 0)
					jsonResult.append(", "); // 첫 번째 항목이 아닐 경우 쉼표 추가
				jsonResult.append("{").append("\"no\": ").append(rs.getInt("ProjectID")).append(", ")
						.append("\"name\": \"").append(rs.getString("ProjectName")).append("\", ")
						.append("\"created_at\": \"").append(rs.getString("CreatedAt")).append("\", ")
						.append("\"adminuserid\": \"").append(rs.getString("adminuserid")).append("\"") // 프로젝트 리더
																											// 추가
						.append("}");
			}
			jsonResult.append("]");
		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
		return jsonResult.toString(); // JSON 문자열 반환
	}
    
    // 사용자 id로 참여하고 있는 프로젝트 조회
    public JSONArray getProjectsByUserId(String userId) throws NamingException, SQLException {
        JSONArray projectList = new JSONArray();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionPool.get();
            // 사용자가 속한 프로젝트 ID 조회
            String sql = "SELECT ProjectID from teamMembers WHERE UserID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            // 결과를 JSON 배열에 추가
            while (rs.next()) {
                int projectId = rs.getInt("ProjectID");
                JSONObject projectData = getProjectById(projectId); // 프로젝트 정보를 조회
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
    // 프로젝트 추가
    public boolean addProject(String name, String adminUserID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean isSuccess = false;
        TeamDAO teamdao = new TeamDAO();

        try {
            conn = ConnectionPool.get();

            // 1️⃣ AdminUserID가 User2 테이블에 존재하는지 확인
            String checkUserSql = "SELECT USERID FROM User2 WHERE USERID = ?";
            stmt = conn.prepareStatement(checkUserSql);
            stmt.setString(1, adminUserID);
            rs = stmt.executeQuery();

            if (!rs.next()) {
                System.out.println("❌ AdminUserID not found: " + adminUserID);
                return false;
            }
            rs.close();
            stmt.close();

            // 2️⃣ Projects 테이블에 프로젝트 추가
            String insertProjectSql = "INSERT INTO Projects (ProjectName, AdminUserID, CreatedAt) VALUES (?, ?, SYSDATE)";
            stmt = conn.prepareStatement(insertProjectSql, new String[]{"ProjectID"});
            stmt.setString(1, name);
            stmt.setString(2, adminUserID);

            int result = stmt.executeUpdate();
            if (result == 1) {
                // 3️⃣ 생성된 프로젝트 ID 가져오기
                rs = stmt.getGeneratedKeys();
                int projectId = -1;
                if (rs.next()) {
                    projectId = rs.getInt(1);
                }

                // 4️⃣ 프로젝트 생성이 성공하면 팀 멤버 추가
                if (projectId != -1) {
                    isSuccess = teamdao.addTeamMember(projectId, adminUserID);
                    if (!isSuccess) {
                        System.out.println("❌ 팀 멤버 추가 실패");
                    }
                }
            }

        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return isSuccess; // 프로젝트 생성 및 팀 멤버 추가 성공 여부 반환
    }


    // 모든 프로젝트 리스트 조회
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

                // 간트차트용 스케줄 정보 가져오기
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

    // 프로젝트 ID로 Schedule 테이블의 스케줄 조회
    private JSONArray getScheduleByProjectId(int projectId, Connection conn) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONArray scheduleArray = new JSONArray();

        try {
            String sql = "SELECT START_DATE, END_DATE FROM Schedule WHERE ProjectID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, projectId);
            rs = stmt.executeQuery();

            boolean[] weeklySchedule = new boolean[5]; // 월~금 초기화

            while (rs.next()) {
                Date startDate = rs.getDate("START_DATE");
                Date endDate = rs.getDate("END_DATE");

                // 날짜 범위에 따라 주간 스케줄 업데이트
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

            // 스케줄을 JSON 배열로 변환
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