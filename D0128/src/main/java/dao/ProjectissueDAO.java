package dao;

import java.sql.*;
import javax.naming.NamingException;
import util.ConnectionPool;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ProjectissueDAO {
	// 프로젝트 이슈 추가
	public void addIssue(String userid, int projectId, String title, String description, int issuelevel)
			throws NamingException, SQLException {
		String sql = "INSERT INTO projectissues (projectissueid, userid, projectid, title, description, issuelevel, createdat) VALUES (2, ?, ?, ?, ?, ?, SYSDATE)";

		
		userid = userid.trim();
        title = title.trim();
        description = description.trim();
        
		try (Connection conn = ConnectionPool.get(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, userid); // 사용자 ID
			stmt.setInt(2, projectId); // 프로젝트 ID
			stmt.setString(3, title); // 제목
			stmt.setString(4, description); // 설명
			stmt.setInt(5, issuelevel);
			stmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace(); // 예외 처리 강화
			throw e; // 예외를 다시 던져서 호출자에게 알림
		}
	}

	
	public String getIssuesByProjectIdJSON(int projectId) throws Exception {
		Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
		StringBuilder jsonResult = new StringBuilder("[");

        try {
        	String sql = "SELECT projectissueid, userid, projectid, title, description, issuelevel, createdat FROM projectissues WHERE projectid = ?";
    		conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, projectId); // 프로젝트 ID
            rs = stmt.executeQuery();
            
            int count = 0;
			while (rs.next()) {
				if (count++ > 0)
					jsonResult.append(", "); // 첫 번째 항목이 아닐 경우 쉼표 추가
				jsonResult.append("{").append("\"issueid\": ").append(rs.getInt("Projectissueid")).append(", ")
						.append("\"userid\": \"").append(rs.getString("userid")).append("\", ")
						.append("\"projectid\": \"").append(rs.getInt("projectid")).append("\", ")
						.append("\"title\": \"").append(rs.getString("title")).append("\", ")
						.append("\"description\": \"").append(rs.getString("description")).append("\", ")
						.append("\"level\": \"").append(rs.getInt("issuelevel")).append("\", ")
						.append("\"createdat\": \"").append(rs.getTimestamp("createdat")).append("\"") 

						.append("}");
			}
			jsonResult.append("]");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return  jsonResult.toString(); // JSON 문자열 반환
	}
	
	
	public String getIssuesByUserIdJSON(String userId) throws Exception {
		Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
		StringBuilder jsonResult = new StringBuilder("[");

        try {
        	String sql = "SELECT projectissueid, userid, projectid, title, description, issuelevel, createdat FROM projectissues WHERE userid = ? ORDER BY createdat desc";
    		conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, userId); // 프로젝트 ID
            rs = stmt.executeQuery();
            
            int count = 0;
			while (rs.next()) {
				if (count++ > 0)
					jsonResult.append(", "); // 첫 번째 항목이 아닐 경우 쉼표 추가
				jsonResult.append("{").append("\"issueid\": ").append(rs.getInt("Projectissueid")).append(", ")
						.append("\"userid\": \"").append(rs.getString("userid")).append("\", ")
						.append("\"projectid\": \"").append(rs.getInt("projectid")).append("\", ")
						.append("\"title\": \"").append(rs.getString("title")).append("\", ")
						.append("\"description\": \"").append(rs.getString("description")).append("\", ")
						.append("\"level\": \"").append(rs.getInt("issuelevel")).append("\", ")
						.append("\"createdat\": \"").append(rs.getTimestamp("createdat")).append("\"") 

						.append("}");
			}
			jsonResult.append("]");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return  jsonResult.toString(); // JSON 문자열 반환
	}
	
	public String getIssuesByIssueIdJSON(int issueId) throws Exception {
		Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
		StringBuilder jsonResult = new StringBuilder("[");

        try {
        	String sql = "SELECT projectissueid, userid, projectid, title, description, issuelevel, createdat FROM projectissues WHERE projectissueid = ?";
    		conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, issueId); // 프로젝트 ID
            rs = stmt.executeQuery();
            
            int count = 0;
			while (rs.next()) {
				if (count++ > 0)
					jsonResult.append(", "); // 첫 번째 항목이 아닐 경우 쉼표 추가
				jsonResult.append("{").append("\"issueid\": ").append(rs.getInt("Projectissueid")).append(", ")
						.append("\"userid\": \"").append(rs.getString("userid")).append("\", ")
						.append("\"projectid\": \"").append(rs.getInt("projectid")).append("\", ")
						.append("\"title\": \"").append(rs.getString("title")).append("\", ")
						.append("\"description\": \"").append(rs.getString("description")).append("\", ")
						.append("\"level\": \"").append(rs.getInt("issuelevel")).append("\", ")
						.append("\"createdat\": \"").append(rs.getTimestamp("createdat")).append("\"") 

						.append("}");
			}
			jsonResult.append("]");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return  jsonResult.toString(); // JSON 문자열 반환
	}

	// 이슈 수정
	public void updateIssue(int projectIssueId, String title, String description, int issuelevel) throws NamingException, SQLException {
		String sql = "UPDATE projectissues SET title = ?, description = ?, issuelevel = ? WHERE projectissueid = ?";

		try (Connection conn = ConnectionPool.get(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, title); // 제목
			stmt.setString(2, description); // 설명
			stmt.setInt(3, issuelevel);
			stmt.setInt(4, projectIssueId); // 이슈 ID
			stmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace(); // 예외 처리 강화
			throw e; // 예외를 다시 던져서 호출자에게 알림
		}
	}

	// 이슈 삭제
	public void deleteIssue(int projectIssueId) throws NamingException, SQLException {
		String sql = "DELETE FROM projectissues WHERE projectissueid = ?";

		try (Connection conn = ConnectionPool.get(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, projectIssueId); // 이슈 ID
			stmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace(); // 예외 처리 강화
			throw e; // 예외를 다시 던져서 호출자에게 알림
		}
	}

}
