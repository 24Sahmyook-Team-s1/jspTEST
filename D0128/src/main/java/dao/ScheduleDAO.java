package dao;

import java.sql.*;
import util.ConnectionPool;
import javax.naming.NamingException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ScheduleDAO {

    // 스케줄 추가 (JSON 배열을 받아서 처리)
    public void addSchedules(JSONArray schedulesArray) throws SQLException, NamingException {
        String sql = "INSERT INTO Schedule (task_name, start_date, end_date, projectId) VALUES (?, ?, ?, ?)";
        
        try (Connection connection = ConnectionPool.get()) {
            try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
                for (int i = 0; i < schedulesArray.size(); i++) {
                    JSONObject scheduleJson = (JSONObject) schedulesArray.get(i);
                    pstmt.setString(1, (String) scheduleJson.get("task_name"));
                    pstmt.setDate(2, Date.valueOf((String) scheduleJson.get("start_date")));
                    pstmt.setDate(3, Date.valueOf((String) scheduleJson.get("end_date")));
                    pstmt.setInt(4, ((Long) scheduleJson.get("projectId")).intValue());
                    pstmt.addBatch(); // 배치 추가
                }
                pstmt.executeBatch(); // 한 번에 실행
            }
        }
    }

    // 스케줄 조회 (JSON 배열로 반환)
    public JSONArray getAllSchedules() throws SQLException, NamingException {
        JSONArray schedulesArray = new JSONArray();
        String sql = "SELECT scheduleId, task_name, start_date, end_date, projectId, created_at";

        try (Connection connection = ConnectionPool.get(); 
             Statement stmt = connection.createStatement(); 
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                JSONObject scheduleJson = new JSONObject();
                scheduleJson.put("scheduleId", rs.getInt("scheduleId"));
                scheduleJson.put("task_name", rs.getString("task_name"));
                scheduleJson.put("start_date", rs.getDate("start_date").toString());
                scheduleJson.put("end_date", rs.getDate("end_date").toString());
                scheduleJson.put("projectId", rs.getInt("projectId"));
                scheduleJson.put("created_at", rs.getTimestamp("created_at").toString());
                schedulesArray.add(scheduleJson);
            }
        }
        return schedulesArray;
    }

    // 스케줄 수정
    public void updateSchedule(int scheduleId, String taskName, Date startDate, Date endDate) throws SQLException, NamingException {
        String sql = "UPDATE Schedule SET task_name = ?, start_date = ?, end_date = ? WHERE scheduleId = ?";
        
        try (Connection connection = ConnectionPool.get(); 
             PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, taskName);
            pstmt.setDate(2, startDate);
            pstmt.setDate(3, endDate);
            pstmt.setInt(4, scheduleId);
            pstmt.executeUpdate();
        }
    }

    // 스케줄 삭제
    public void deleteSchedule(int scheduleId) throws SQLException, NamingException {
        String sql = "DELETE FROM Schedule WHERE scheduleId = ?";
        
        try (Connection connection = ConnectionPool.get(); 
             PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, scheduleId);
            pstmt.executeUpdate();
        }
    }
}
