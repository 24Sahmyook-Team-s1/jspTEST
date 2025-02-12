<%@ page import="java.io.*, java.sql.*, javax.naming.NamingException, org.json.simple.JSONObject" %>
<%@ page import="dao.ScheduleDAO" %>
<%@ page contentType="application/json; charset=UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

// 요청 파라미터 받기
String scheduleId = request.getParameter("scheduleId");
String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");
String status = request.getParameter("status");

JSONObject responseJson = new JSONObject();

if (scheduleId == null || startDate == null || endDate == null || status == null) {
    responseJson.put("status", "error");
    responseJson.put("message", "Missing parameters");
} else {
    try {
        ScheduleDAO dao = new ScheduleDAO();
        // 작업 업데이트 메소드 호출
        boolean result = dao.updateTask(Integer.parseInt(scheduleId), startDate, endDate, status);
        
        if (result) {
            responseJson.put("status", "success");
            responseJson.put("message", "Task updated successfully");
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
