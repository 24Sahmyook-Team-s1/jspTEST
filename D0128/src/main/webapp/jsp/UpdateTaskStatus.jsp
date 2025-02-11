<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ScheduleDAO" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");

    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
    String status = request.getParameter("status");

    JSONObject jsonResponse = new JSONObject();
    ScheduleDAO scheduleDAO = new ScheduleDAO();

    try {
        boolean result = scheduleDAO.updateTaskStatus(scheduleId, status);
        jsonResponse.put("success", result);
    } catch (Exception e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error", e.getMessage());
    }

    out.print(jsonResponse.toJSONString());
%>
