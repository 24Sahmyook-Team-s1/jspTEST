package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import javax.naming.NamingException;
import util.ConnectionPool;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ScheduleDAO {

	// 할 일 추가 (상태 포함)
    public boolean addTask(String taskName, String startDate, String endDate, int projectId, String status) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionPool.get();
            String sql = "INSERT INTO Schedule (Task_Name, Start_Date, End_Date, ProjectID, Status, Created_At) VALUES (?, TO_DATE(?, 'YYYY-MM-DD'), TO_DATE(?, 'YYYY-MM-DD'), ?, ?, SYSDATE)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, taskName);
            stmt.setString(2, startDate);
            stmt.setString(3, endDate);
            stmt.setInt(4, projectId);
            stmt.setString(5, status);  // 상태 추가

            int result = stmt.executeUpdate();
            return result == 1;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    // 모든 할 일 가져오기 (상태 포함)
    public JSONArray getAllTasks() throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONArray tasks = new JSONArray();

        try {
            conn = ConnectionPool.get();
            String sql = "SELECT ScheduleID, Task_Name, Start_Date, End_Date, NVL(Status, 'todo') AS Status FROM Schedule ORDER BY Start_Date ASC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject task = new JSONObject();
                task.put("scheduleId", rs.getInt("ScheduleID"));
                task.put("taskName", rs.getString("Task_Name"));
                task.put("startDate", rs.getDate("Start_Date").toString());
                task.put("endDate", rs.getDate("End_Date").toString());
                task.put("status", rs.getString("Status"));  // 상태 값 반환
                tasks.add(task);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return tasks;
    }
    
    // 작업 상태 업데이트
    public boolean updateTaskStatus(int scheduleId, String newStatus) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionPool.get();
            String sql = "UPDATE Schedule SET Status = ? WHERE ScheduleID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newStatus);
            stmt.setInt(2, scheduleId);

            int result = stmt.executeUpdate();
            return result == 1;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
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
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
 // 모든 할 일 가져오기 (상태 포함)
    public JSONArray getTasksByProjectIds(int projectId) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        JSONArray tasks = new JSONArray();

        try {
            conn = ConnectionPool.get();
            String sql = "SELECT ScheduleID, Task_Name, Start_Date, End_Date, NVL(Status, 'todo') AS Status FROM Schedule where projectid = ? ORDER BY Start_Date ASC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, projectId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject task = new JSONObject();
                task.put("scheduleId", rs.getInt("ScheduleID"));
                task.put("taskName", rs.getString("Task_Name"));
                task.put("startDate", rs.getDate("Start_Date").toString());
                task.put("endDate", rs.getDate("End_Date").toString());
                task.put("status", rs.getString("Status"));  // 상태 값 반환
                tasks.add(task);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return tasks;
    }
    
    public boolean updateTask(int scheduleId, String startDate, String endDate, String status) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isUpdated = false;

        try {
            conn = ConnectionPool.get();
            String sql = "UPDATE Schedule SET Start_Date = ?, End_Date = ?, Status = ? WHERE ScheduleID = ?";
            stmt = conn.prepareStatement(sql);
            // 스트링 형식으로 날짜를 설정
            stmt.setString(1, startDate); // 시작일
            stmt.setString(2, endDate);   // 종료일
            stmt.setString(3, status);     // 상태
            stmt.setInt(4, scheduleId);    // 작업 ID

            int rowsAffected = stmt.executeUpdate();
            isUpdated = (rowsAffected > 0);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return isUpdated;
    }

 // ✅ 작업 이름 포함하여 업데이트하는 새로운 메서드
    public boolean updateTaskWithName(int scheduleId, String taskName, String startDate, String endDate, String status) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isUpdated = false;

        try {
            conn = ConnectionPool.get();
            String sql = "UPDATE Schedule SET Task_Name = ?, Start_Date = ?, End_Date = ?, Status = ? WHERE ScheduleID = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, taskName); // ✅ 작업 이름 업데이트
            stmt.setString(2, startDate); // 시작일
            stmt.setString(3, endDate);   // 종료일
            stmt.setString(4, status);    // 상태
            stmt.setInt(5, scheduleId);   // 작업 ID

            int rowsAffected = stmt.executeUpdate();
            isUpdated = (rowsAffected > 0);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        return isUpdated;
    }

    
    

}