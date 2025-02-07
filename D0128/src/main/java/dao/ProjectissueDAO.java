package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.NamingException;
import util.ConnectionPool;

public class ProjectissueDAO {
	// 프로젝트 이슈 추가
	public void addIssue(String projectUserId, int projectId, String title, String description)
			throws NamingException, SQLException {
		String sql = "INSERT INTO projectissues (projectissueid, projectuserid, projectid, title, description, createdat) VALUES (2, ?, ?, ?, ?, SYSDATE)";

		try (Connection conn = ConnectionPool.get(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, projectUserId); // 사용자 ID
			stmt.setInt(2, projectId); // 프로젝트 ID
			stmt.setString(3, title); // 제목
			stmt.setString(4, description); // 설명
			stmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace(); // 예외 처리 강화
			throw e; // 예외를 다시 던져서 호출자에게 알림
		}
	}

	// 특정 프로젝트의 이슈 목록 조회
	public List<ProjectissueObj> getIssuesByProjectId(int projectId) throws NamingException, SQLException {
		String sql = "SELECT projectissueid, projectuserid, projectid, title, description, createdat FROM projectissues WHERE projectid = ?";
		List<ProjectissueObj> issues = new ArrayList<>();

		try (Connection conn = ConnectionPool.get(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, projectId); // 프로젝트 ID
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					ProjectissueObj issue = new ProjectissueObj(
						rs.getInt("projectissueid"), 
						rs.getString("projectuserid"), 
						rs.getInt("projectid"), 
						rs.getString("title"), 
						rs.getString("description"), 
						rs.getTimestamp("createdat") // Timestamp로 처리
					); 
					issues.add(issue);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace(); // 예외 처리 강화
			throw e; // 예외를 다시 던져서 호출자에게 알림
		}

		return issues; // 이슈 목록 반환
	}

	// 이슈 수정
	public void updateIssue(int projectIssueId, String title, String description) throws NamingException, SQLException {
		String sql = "UPDATE projectissues SET title = ?, description = ? WHERE projectissueid = ?";

		try (Connection conn = ConnectionPool.get(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, title); // 제목
			stmt.setString(2, description); // 설명
			stmt.setInt(3, projectIssueId); // 이슈 ID
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

