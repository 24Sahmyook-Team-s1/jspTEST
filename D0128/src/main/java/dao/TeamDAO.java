package dao;

import java.sql.*;
import javax.naming.NamingException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import util.ConnectionPool;

public class TeamDAO {
	
	// 팀 목록 불러오는 메소드
	public JSONArray getTeamList() throws NamingException,  SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray teamList = new JSONArray();

        try {
            conn = ConnectionPool.get(); // ConnectionPool을 통해 연결 받기
            
            String sql = "SELECT PROJECTTEAMID, TEAMNAME, TO_CHAR(CREATEDAT, 'YYYY-MM-DD') AS CREATEDAT FROM PROJECTTEAMS ORDER BY CREATEDAT DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                JSONObject team = new JSONObject();
                team.put("id", rs.getInt("PROJECTTEAMID"));
                team.put("name", rs.getString("TEAMNAME"));
                team.put("created_at", rs.getString("CREATEDAT"));
                teamList.add(team);
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return teamList;
    }

	
	public boolean approveRequest(int requestId, String userId, int teamId) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionPool.get();
            
            // ✅ 요청 상태를 "APPROVED"로 변경
            String updateSql = "UPDATE TEAM_REQUESTS SET STATUS = 'APPROVED' WHERE REQUEST_ID = ?";
            stmt = conn.prepareStatement(updateSql);
            stmt.setInt(1, requestId);
            int updatedRows = stmt.executeUpdate();
            stmt.close();

            if (updatedRows > 0) {
                // ✅ 승인된 요청을 TEAM_MEMBERS 테이블에 추가
                String insertSql = "INSERT INTO TEAMMEMBERS (PROJECTTEAMID, USERID, JOINED_AT) VALUES (?, ?, SYSDATE)";
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
            String sql = "UPDATE TEAM_REQUESTS SET STATUS = 'REJECTED' WHERE REQUEST_ID = ?";
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
            String sql = "SELECT r.REQUESTID, r.USERID, r.REQUEST_DATE " +
                         "FROM TEAM_JOIN_REQUESTS r " +
                         "JOIN PROJECTTEAMS t ON r.TEAMID = t.PROJECTTEAMID " +
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
            String sql = "SELECT r.REQUEST_ID, r.USER_ID, r.TEAM_ID, r.REQUEST_DATE " +
                         "FROM TEAM_REQUESTS r " +
                         //"JOIN PROJECTTEAMS t ON r.TEAMID = t.PROJECTTEAMID " +
                         "WHERE r.STATUS = 'PENDING'";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject requestData = new JSONObject();
                requestData.put("requestId", rs.getInt("REQUEST_ID"));
                requestData.put("userId", rs.getString("USER_ID"));
                requestData.put("teamId", rs.getString("TEAM_ID"));
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
}