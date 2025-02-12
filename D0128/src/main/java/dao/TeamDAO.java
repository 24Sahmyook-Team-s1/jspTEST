package dao;

import java.sql.*;
import javax.naming.NamingException;
import javax.naming.event.NamingExceptionEvent;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import util.ConnectionPool;

public class TeamDAO {    
	
	public boolean inviteTeamMember(String projectId, String userId) throws NamingException, SQLException {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    boolean isSuccess = false;

	    try {
	        conn = ConnectionPool.get();

	        // 1. USER2 테이블에서 사용자 존재 여부 확인
	        String checkUserSql = "SELECT USERID FROM USER2 WHERE JSONSTR LIKE ?";
	        pstmt = conn.prepareStatement(checkUserSql);
	        pstmt.setString(1, "%\"id\":\"" + userId + "\"%");  // 문자열로 수정

	        rs = pstmt.executeQuery();

	        if (!rs.next()) {
	            // 사용자 존재하지 않음
	            return false;
	        }
	        rs.close();
	        pstmt.close();

	        // 2. INVITATION 테이블에 이미 초대된 사용자인지 확인
	        String checkInvitationSql = "SELECT * FROM INVITATION WHERE PROJECTID = ? AND USERID = ?";
	        pstmt = conn.prepareStatement(checkInvitationSql);
	        pstmt.setString(1, projectId);
	        pstmt.setString(2, userId);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            // 이미 초대된 사용자
	            return false;
	        }
	        rs.close();
	        pstmt.close();

	        // 3. 초대 진행 (INVITATION 테이블에 삽입)
	        String inviteSql = "INSERT INTO INVITATION (PROJECTID, USERID) VALUES (?, ?)";
	        pstmt = conn.prepareStatement(inviteSql);
	        pstmt.setString(1, projectId);
	        pstmt.setString(2, userId);

	        int rowsAffected = pstmt.executeUpdate();  // 초대 성공 여부 확인
	        isSuccess = (rowsAffected > 0);

	    } finally {
	        if (rs != null) rs.close();
	        if (pstmt != null) pstmt.close();
	        if (conn != null) conn.close();
	    }

	    return isSuccess;
	}




	public boolean addTeamMember(int projectId, String userId) throws NamingException, SQLException {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    boolean isSuccess = false;

	    try {
	        conn = ConnectionPool.get();

	        // ✅ 1️⃣ 먼저 중복된 팀원이 있는지 확인
	        String checkSql = "SELECT COUNT(*) FROM TEAMMEMBERS WHERE PROJECTID = ? AND USERID = ?";
	        pstmt = conn.prepareStatement(checkSql);
	        pstmt.setInt(1, projectId);
	        pstmt.setString(2, userId);
	        rs = pstmt.executeQuery();

	        if (rs.next() && rs.getInt(1) > 0) {
	            // 이미 존재하는 팀원이므로 삽입하지 않음
	            System.out.println("이미 팀원으로 등록된 사용자입니다.");
	            return false;  // 삽입하지 않고 false 반환
	        }
	        
	        rs.close();
	        pstmt.close();

	        // ✅ 2️⃣ 존재하지 않으면 삽입
	        String sql = "INSERT INTO TEAMMEMBERS (PROJECTID, USERID, JOINED_AT) VALUES (?, ?, SYSDATE)";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, projectId);
	        pstmt.setString(2, userId);

	        int rowsAffected = pstmt.executeUpdate();
	        isSuccess = (rowsAffected > 0);
	        
	    } finally {
	        if (rs != null) rs.close();
	        if (pstmt != null) pstmt.close();
	        if (conn != null) conn.close();
	    }

	    return isSuccess;
	}




    
    public boolean isTeamLeader(String userId) throws NamingException, SQLException {
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isLeader = false;
        
        if (userId == null) {
            return isLeader;
        }

        try {
            conn = ConnectionPool.get();

            String sql = "SELECT COUNT(*) FROM PROJECTS WHERE ADMINUSERID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                isLeader = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        return isLeader;
    }
	
	public boolean approveRequest(int requestId, String userId, int teamId) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionPool.get();
            
            // ✅ 요청 상태를 "APPROVED"로 변경
            String updateSql = "UPDATE TEAM_REQUESTS SET STATUS = 'APPROVED' WHERE REQUESTID = ?";
            stmt = conn.prepareStatement(updateSql);
            stmt.setInt(1, requestId);
            int updatedRows = stmt.executeUpdate();
            stmt.close();

            if (updatedRows > 0) {
                // ✅ 승인된 요청을 TEAM_MEMBERS 테이블에 추가
                String insertSql = "INSERT INTO TEAMMEMBERS (PROJECTID, USERID, JOINED_AT) VALUES (?, ?, SYSDATE)";
                stmt = conn.prepareStatement(insertSql);
                stmt.setInt(1, teamId);
                stmt.setString(2, userId);
                stmt.executeUpdate();
                stmt.close();

                return true; // 승인 성공
            }
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return false; // 승인 실패
    }

	public boolean rejectJoinRequest(int requestId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isUpdated = false;

        try {
            conn = ConnectionPool.get();
            String sql = "UPDATE TEAM_REQUESTS SET STATUS = 'REJECTED' WHERE REQUESTID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, requestId);
            int updatedRows = pstmt.executeUpdate();

            if (updatedRows > 0) {
                isUpdated = true;
            }
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return isUpdated;
    }

	public JSONArray getPendingRequests(String adminId) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONArray requestList = new JSONArray();

        try {
            conn = ConnectionPool.get();
            
            // ✅ 관리자의 팀에 대한 참여 요청 조회
            String sql = "SELECT r.REQUESTID, r.USERID, r.REQUESTDATE " +
                         "FROM TEAM_REQUESTS r " +
                         "JOIN PROJECTS t ON r.PROJECTID = t.PROJECTID " +
                         "WHERE t.ADMINUSERID = ? AND r.STATUS = 'PENDING'";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, adminId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject requestData = new JSONObject();
                requestData.put("requestId", rs.getInt("REQUESTID"));
                requestData.put("userId", rs.getString("USERID"));
                requestData.put("requestDate", rs.getString("REQUEST_DATE"));
                requestList.add(requestData);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return requestList;
    }
	public JSONArray getPendingRequests() throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONArray requestList = new JSONArray();

        try {
            conn = ConnectionPool.get();
            
            // ✅ 관리자의 팀에 대한 참여 요청 조회
            String sql = "SELECT r.REQUESTID, r.USERID, r.PROJECTID, r.REQUESTDATE " +
                         "FROM TEAM_REQUESTS r " +
                         //"JOIN PROJECTTEAMS t ON r.TEAMID = t.PROJECTTEAMID " +
                         "WHERE r.STATUS = 'PENDING'";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject requestData = new JSONObject();
                requestData.put("requestId", rs.getInt("REQUESTID"));
                requestData.put("userId", rs.getString("USERID"));
                requestData.put("projectId", rs.getString("PROJECTID"));
                requestData.put("requestDate", rs.getString("REQUESTDATE"));
                requestList.add(requestData);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return requestList;
    }
	
	public JSONArray getTeamMembers(int projectId) throws NamingException, SQLException {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray membersList = new JSONArray();

	    try {
	        conn = ConnectionPool.get();
	        String sql = "SELECT u.USERID, u.JSONSTR FROM TEAMMEMBERS t JOIN USER2 u ON t.USERID = u.USERID WHERE t.PROJECTID = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, projectId);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            JSONObject member = new JSONObject();
	            String userJson = rs.getString("JSONSTR");

	            // JSON 문자열 파싱
	            org.json.simple.parser.JSONParser parser = new org.json.simple.parser.JSONParser();
	            JSONObject userObj = (JSONObject) parser.parse(userJson);

	            member.put("name", userObj.get("name"));
	            member.put("email", userObj.get("id"));
	            membersList.add(member);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (rs != null) rs.close();
	        if (pstmt != null) pstmt.close();
	        if (conn != null) conn.close();
	    }

	    return membersList;
	}
	public JSONArray getTeamMembersByProjectId(int projectId) throws NamingException, SQLException {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray teamList = new JSONArray();

	    try {
	        conn = ConnectionPool.get();
	        String sql = "SELECT u.USERID, u.JSONSTR " +
	                     "FROM TEAMMEMBERS tm " +
	                     "JOIN USER2 u ON tm.USERID = u.USERID " +
	                     "WHERE tm.PROJECTID = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, projectId);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            String jsonStr = rs.getString("JSONSTR");
	            JSONObject userDetails = (JSONObject) new JSONParser().parse(jsonStr);
	            JSONObject teamMember = new JSONObject();
	            teamMember.put("userId", rs.getString("USERID"));
	            teamMember.put("name", userDetails.get("name"));
	            teamMember.put("email", userDetails.get("id"));
	            teamList.add(teamMember);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (rs != null) rs.close();
	        if (pstmt != null) pstmt.close();
	        if (conn != null) conn.close();
	    }
	    return teamList;
	}


}