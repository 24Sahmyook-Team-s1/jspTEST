package dao;

import java.sql.*;
import util.ConnectionPool;
import javax.naming.NamingException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ScheduleDAO {
	// 할 일 추가
	public boolean addTask(String taskName, String startDate, String endDate, int projectId)
			throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;

		try {
			conn = ConnectionPool.get();
			String sql = "INSERT INTO Schedule (Task_Name, Start_Date, End_Date, ProjectID, Created_At) VALUES (?, TO_DATE(?, 'YYYY-MM-DD'), TO_DATE(?, 'YYYY-MM-DD'), ?, SYSDATE)";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, taskName);
			stmt.setString(2, startDate);
			stmt.setString(3, endDate);
			stmt.setInt(4, projectId);

			int result = stmt.executeUpdate();
			return result == 1;
		} finally {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	// 모든 할 일 가져오기
	public JSONArray getAllTasks() throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		JSONArray tasks = new JSONArray();

		try {
			conn = ConnectionPool.get();
			String sql = "SELECT ScheduleID, Task_Name, Start_Date, End_Date FROM Schedule ORDER BY Start_Date ASC";
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();

			while (rs.next()) {
				JSONObject task = new JSONObject();
				task.put("scheduleId", rs.getInt("ScheduleID"));
				task.put("taskName", rs.getString("Task_Name"));
				task.put("startDate", rs.getDate("Start_Date").toString());
				task.put("endDate", rs.getDate("End_Date").toString());
				task.put("status", "todo"); // 기본 상태
				tasks.add(task);
			}
		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}

		return tasks;
	}

	// 작업 삭제
	public boolean deleteTask(int scheduleId) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;

		try {
			conn = ConnectionPool.get();
			String sql = "DELETE FROM Schedule WHERE ScheduleID = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, scheduleId);

			int result = stmt.executeUpdate();
			return result == 1;
		} finally {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}
}