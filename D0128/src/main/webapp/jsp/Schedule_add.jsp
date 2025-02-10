<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="dao.ScheduleDAO" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    String taskName = request.getParameter("task_name");
    String startDate = request.getParameter("start_date");
    String endDate = request.getParameter("end_date");
    int projectId = Integer.parseInt(request.getParameter("projectId"));

    try {
        ScheduleDAO scheduleDAO = new ScheduleDAO();
        JSONObject scheduleJson = new JSONObject();
        scheduleJson.put("task_name", taskName);
        scheduleJson.put("start_date", startDate);
        scheduleJson.put("end_date", endDate);
        scheduleJson.put("projectId", projectId);
        JSONArray schedulesArray = new JSONArray();
        schedulesArray.add(scheduleJson);
        scheduleDAO.addSchedules(schedulesArray);
        out.println("스케줄이 성공적으로 추가되었습니다.");
    } catch (SQLException | NamingException e) {
        e.printStackTrace();
        out.println("스케줄 추가 중 오류가 발생했습니다.");
    }
%>
