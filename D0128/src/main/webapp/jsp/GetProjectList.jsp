<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray projectList = new JSONArray();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/XE", "park", "1111");

        System.out.println("🔍 SQL 실행 시작");

        String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt, " +
                     "ScheduleMonday, ScheduleTuesday, ScheduleWednesday, ScheduleThursday, ScheduleFriday " +
                     "FROM Projects ORDER BY CreatedAt DESC, ProjectID ASC";

        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject project = new JSONObject();
            project.put("no", rs.getInt("ProjectID"));
            project.put("name", rs.getString("ProjectName"));
            project.put("created_at", rs.getString("CreatedAt"));

            // ✅ Gantt Chart 일정 배열 추가
            JSONArray schedule = new JSONArray();
            schedule.add(rs.getInt("ScheduleMonday"));
            schedule.add(rs.getInt("ScheduleTuesday"));
            schedule.add(rs.getInt("ScheduleWednesday"));
            schedule.add(rs.getInt("ScheduleThursday"));
            schedule.add(rs.getInt("ScheduleFriday"));

            project.put("schedule", schedule);
            projectList.add(project);
        }

    } catch (Exception e) {
        e.printStackTrace();
        System.out.println("❌ SQL 실행 오류 발생");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print(projectList.toJSONString());
%>
