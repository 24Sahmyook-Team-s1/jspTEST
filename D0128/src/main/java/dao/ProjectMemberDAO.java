package dao;

import java.sql.*;
import javax.naming.NamingException;
import util.ConnectionPool;

public class ProjectMemberDAO {
	public boolean insert(String projectId, String userid) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		try {
			String sql = "INSERT INTO teammembers(projectId, userid) VALUES(?, ?)";
			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, projectId);
			stmt.setString(2, userid);
			int count = stmt.executeUpdate();
			return (count == 1);
		} finally {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	public boolean exists(String projectID, String userid) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT * FROM teammembers WHERE projectId= ? and userid = ?";
			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, projectID);
			stmt.setString(2, userid);
			rs = stmt.executeQuery();
			return rs.next();
		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	// 멤버 비할당
	public boolean delete(String projectID, String userid) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		try {
			String sql = "DELETE FROM teammembers WHERE projectID = ? and userid = ?";
			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, projectID);
			stmt.setString(2, userid);
			int count = stmt.executeUpdate();
			return (count == 1);
		} finally {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}
	
	public String getList(String projectID) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		StringBuilder jsonResult = new StringBuilder("[");

		try {
			String sql = "SELECT ProjectID, userid FROM teammembers WHERE ProjectID = ?";
			conn = ConnectionPool.get(); // 커넥션 풀에서 커넥션 획득
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, projectID);
			rs = stmt.executeQuery();

			int count = 0;
			while (rs.next()) {
				if (count++ > 0)
					jsonResult.append(", "); // 첫 번째 항목이 아닐 경우 쉼표 추가
				jsonResult.append("{").append("\"project\": ").append(rs.getInt("ProjectID")).append(", ")
						.append("\"user\": \"").append(rs.getString("userid")).append("\"")
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

	// 프로젝트 id 로 프로젝트 검색
	public String get(String projectID, String userID) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		StringBuilder jsonResult = new StringBuilder("[");
		try {
			String sql = "SELECT ProjectID, userid FROM teammembers WHERE ProjectID = ? and userid = ?";
			conn = ConnectionPool.get(); // 커넥션 풀에서 커넥션 획득
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, projectID);
			stmt.setString(2, userID);
			rs = stmt.executeQuery();

			int count = 0;
			while (rs.next()) {
				if (count++ > 0)
					jsonResult.append(", "); // 첫 번째 항목이 아닐 경우 쉼표 추가
				jsonResult.append("{").append("\"project\": ").append(rs.getInt("ProjectID")).append(", ")
						.append("\"user\": \"").append(rs.getString("userid")).append("\"")
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

}
