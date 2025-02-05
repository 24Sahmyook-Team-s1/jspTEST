package dao;

import java.sql.*;
import javax.naming.NamingException;
import util.ConnectionPool;

public class ProjectDAO {

	public boolean insert(String projectName, String projectLeader) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		try {
			String sql = "INSERT INTO projects(projectName, createDat, projectLeader) VALUES(?, SYSDATE, ?)";
			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, projectName);
			stmt.setString(2, projectLeader);
			int count = stmt.executeUpdate();
			return (count == 1);
		} finally {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	public boolean exists(String projectID) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT projectName FROM projects WHERE projectName = ?";
			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, projectID);
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
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	public String getList() throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		StringBuilder jsonResult = new StringBuilder("[");

		try {
			String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt, ProjectLeader FROM Projects ORDER BY CreatedAt DESC, ProjectID ASC";
			conn = ConnectionPool.get(); // 커넥션 풀에서 커넥션 획득
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();

			int count = 0;
			while (rs.next()) {
				if (count++ > 0)
					jsonResult.append(", "); // 첫 번째 항목이 아닐 경우 쉼표 추가
				jsonResult.append("{").append("\"no\": ").append(rs.getInt("ProjectID")).append(", ")
						.append("\"name\": \"").append(rs.getString("ProjectName")).append("\", ")
						.append("\"created_at\": \"").append(rs.getString("CreatedAt")).append("\", ")
						.append("\"projectLeader\": \"").append(rs.getString("ProjectLeader")).append("\"") // 프로젝트 리더
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
	public String get(String projectID) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		StringBuilder jsonResult = new StringBuilder("[");
		try {
			String sql = "SELECT projectID, projectName, createDat, projectLeader FROM projects WHERE projectName = ?";
			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, projectID);
			rs = stmt.executeQuery();
//			if (rs.next()) {
//				return "{\"projectID\": \"" + rs.getString("projectID") + "\", " + "\"projectName\": \""
//						+ rs.getString("projectName") + "\", " + "\"createDat\": \"" + rs.getTimestamp("createDat")
//						+ "\", " + "\"projectLeader\": \"" + rs.getString("projectLeader") + "\"}";
//			}
//			return "{}";
			
			int count = 0;
			while (rs.next()) {
				if (count++ > 0)
					jsonResult.append(", "); // 첫 번째 항목이 아닐 경우 쉼표 추가
				jsonResult.append("{").append("\"no\": ").append(rs.getInt("ProjectID")).append(", ")
						.append("\"name\": \"").append(rs.getString("ProjectName")).append("\", ")
						.append("\"created_at\": \"").append(rs.getString("CreatedAt")).append("\", ")
						.append("\"projectLeader\": \"").append(rs.getString("ProjectLeader")).append("\"") // 프로젝트 리더
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

	// 팀 프로젝트 이름 변경
	public boolean updateProjectName(String oldProjectName, String newProjectName)
			throws NamingException, SQLException {
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
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	// 팀 리더 변경
	public boolean updateProjectLeader(String projectName, String newProjectLeader)
			throws NamingException, SQLException {
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
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

}
