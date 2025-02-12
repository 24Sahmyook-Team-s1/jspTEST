<%@ page import="java.io.*, java.sql.*, javax.naming.NamingException, org.json.simple.JSONObject" %>
<%@ page import="dao.ScheduleDAO" %>
<%@ page contentType="application/json; charset=UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

// 요청 파라미터 받기
String scheduleId = request.getParameter("scheduleId");
String taskName = request.getParameter("taskName"); // ✅ 추가된 taskName
String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");
String status = request.getParameter("status");

JSONObject responseJson = new JSONObject();

if (scheduleId == null || taskName == null || startDate == null || endDate == null || status == null) {
    responseJson.put("status", "error");
    responseJson.put("message", "Missing parameters: scheduleId, taskName, startDate, endDate, status required.");
} else {
    try {
        ScheduleDAO dao = new ScheduleDAO();
        boolean result = dao.updateTaskWithName(Integer.parseInt(scheduleId), taskName, startDate, endDate, status); // ✅ 새로운 DAO 메서드 사용

        if (result) {
            responseJson.put("status", "success");
        } else {
            responseJson.put("status", "error");
            responseJson.put("message", "Failed to update task");
        }
    } catch (NamingException | SQLException e) {
        responseJson.put("status", "error");
        responseJson.put("message", e.getMessage());
    }
}

out.print(responseJson);
out.flush();
%>
