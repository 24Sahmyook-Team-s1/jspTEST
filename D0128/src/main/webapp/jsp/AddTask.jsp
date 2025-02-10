<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ScheduleDAO" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");

    String taskName = request.getParameter("taskName");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    int projectId = Integer.parseInt(request.getParameter("projectId"));

    JSONObject jsonResponse = new JSONObject();
    ScheduleDAO scheduleDAO = new ScheduleDAO();

    try {
        // 기본 상태 'todo'로 설정하여 작업 추가
        boolean result = scheduleDAO.addTask(taskName, startDate, endDate, projectId, "todo");
        jsonResponse.put("success", result);
    } catch (Exception e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error", e.getMessage());
    }

    out.print(jsonResponse.toJSONString());
%>
