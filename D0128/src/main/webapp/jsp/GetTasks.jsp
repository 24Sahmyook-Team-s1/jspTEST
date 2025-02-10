<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ScheduleDAO" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
    response.setContentType("application/json;charset=UTF-8");
    ScheduleDAO scheduleDAO = new ScheduleDAO();
    JSONArray tasks = scheduleDAO.getAllTasks();
    out.print(tasks.toJSONString());
%>
