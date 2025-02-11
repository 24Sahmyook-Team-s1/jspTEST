<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ScheduleDAO" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
    response.setContentType("application/json;charset=UTF-8");
	int projectId = Integer.parseInt(request.getParameter("projectId").trim());
    ScheduleDAO scheduleDAO = new ScheduleDAO();
    JSONArray tasks = scheduleDAO.getTasksByProjectIds(projectId);
    out.print(tasks.toJSONString());
%>
