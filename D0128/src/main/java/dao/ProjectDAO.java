package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import javax.naming.NamingException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
            conn = ConnectionPool.get();
            
            // 프로젝트 삭제 전, 관련된 팀원 데이터도 삭제
            String deleteTeamMembersSql = "DELETE FROM TEAMMEMBERS WHERE PROJECTID = ?";
            stmt = conn.prepareStatement(deleteTeamMembersSql);
            stmt.setInt(1, projectID);
            stmt.executeUpdate();
            stmt.close();
            
            // 프로젝트 삭제
            String deleteProjectSql = "DELETE FROM PROJECTS WHERE PROJECTID = ?";
            stmt = conn.prepareStatement(deleteProjectSql);
            stmt.setInt(1, projectID);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }


    // ✅ 프로젝트 조회 (ID 기준) - 책임자 정보 포함
    public JSONObject getProjectById(int projectID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONObject project = null;

        try {
            // 책임자 정보 포함하여 USER2 테이블과 조인
            String sql = "SELECT p.ProjectID, p.ProjectName, TO_CHAR(p.CreatedAt, 'YYYY-MM-DD') AS CreatedAt, " +
                         "u.JSONSTR AS OwnerInfo " +
                         "FROM projects p " +
                         "JOIN USER2 u ON p.AdminUserId = u.UserId " +
                         "WHERE p.ProjectID = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, projectID);
            rs = stmt.executeQuery();

            if (rs.next()) {
                project = new JSONObject();
                project.put("id", rs.getInt("ProjectID"));
                project.put("name", rs.getString("ProjectName"));
                project.put("created_at", rs.getString("CreatedAt"));

                // 책임자 정보 파싱
                String ownerJson = rs.getString("OwnerInfo");
                if (ownerJson != null) {
                    JSONParser parser = new JSONParser();
                    JSONObject ownerData = (JSONObject) parser.parse(ownerJson);
                    project.put("ownerName", ownerData.get("name"));
                    project.put("ownerEmail", ownerData.get("id"));  // 이메일은 JSON의 id 필드에 저장됨
                } else {
                    project.put("ownerName", "정보 없음");
                    project.put("ownerEmail", "정보 없음");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
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

            // AdminUserID가 존재하는지 확인
            String checkUserSql = "SELECT USERID FROM User2 WHERE USERID = ?";
            stmt = conn.prepareStatement(checkUserSql);
            stmt.setString(1, adminUserID);
            rs = stmt.executeQuery();

            if (!rs.next()) {
                return false;
            }
            rs.close();
            stmt.close();

            // 시퀀스를 사용하여 ProjectID 가져오기
            String getNextIdSql = "SELECT projects_seq.NEXTVAL FROM dual";
            stmt = conn.prepareStatement(getNextIdSql);
            rs = stmt.executeQuery();

            int projectId = -1;
            if (rs.next()) {
                projectId = rs.getInt(1);
            }
            rs.close();
            stmt.close();

            // 프로젝트 추가
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

                // 간트차트용 스케줄 정보 추가
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
    
    public JSONObject getProjectDetails(int projectId, String userId) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONObject projectDetails = new JSONObject();

        try {
            conn = ConnectionPool.get();

            // 1️⃣ 프로젝트 기본 정보 가져오기
            String projectSql = "SELECT PROJECTNAME, ADMINUSERID FROM PROJECTS WHERE PROJECTID = ?";
            pstmt = conn.prepareStatement(projectSql);
            pstmt.setInt(1, projectId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String adminUserId = rs.getString("ADMINUSERID");
                String projectName = rs.getString("PROJECTNAME");

                // 2️⃣ 관리자 권한 확인
                if (userId.equals(adminUserId)) {
                    projectDetails.put("status", "success");
                    projectDetails.put("projectName", projectName);
                    projectDetails.put("role", "admin");
                    return projectDetails;
                }

                rs.close();
                pstmt.close();

                // 3️⃣ 팀원인지 확인
                String teamSql = "SELECT USERID FROM TEAMMEMBERS WHERE PROJECTID = ? AND USERID = ?";
                pstmt = conn.prepareStatement(teamSql);
                pstmt.setInt(1, projectId);
                pstmt.setString(2, userId);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    projectDetails.put("status", "success");
                    projectDetails.put("projectName", projectName);
                    projectDetails.put("role", "member");
                    return projectDetails;
                } else {
                    // 팀원도 아니고, 관리자도 아님 → 접근 불가
                    projectDetails.put("status", "fail");
                    projectDetails.put("message", "프로젝트에 접근할 수 없습니다.");
                }
            } else {
                // 프로젝트가 존재하지 않음
                projectDetails.put("status", "fail");
                projectDetails.put("message", "해당 프로젝트를 찾을 수 없습니다.");
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return projectDetails;
    }
    // 프로젝트 추가
    public boolean addProject(String name, String adminUserID, String desc) throws NamingException, SQLException {
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
            String insertProjectSql = "INSERT INTO Projects (ProjectName, AdminUserID, CreatedAt, description) VALUES (?, ?, SYSDATE, ?)";
            stmt = conn.prepareStatement(insertProjectSql, new String[]{"ProjectID"});
            stmt.setString(1, name);
            stmt.setString(2, adminUserID);
            stmt.setString(3, desc);

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
<<<<<<< HEAD
}
=======
}
>>>>>>> branch 'dev' of https://github.com/24Sahmyook-Team-s1/jspTEST.git
