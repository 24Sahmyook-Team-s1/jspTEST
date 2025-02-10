<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ScheduleDAO" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");

    String taskName = request.getParameter("taskName");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    String projectIdParam = request.getParameter("projectId");

    JSONObject jsonResponse = new JSONObject();

    if (taskName != null && startDate != null && endDate != null && projectIdParam != null) {
        try {
            int projectId = Integer.parseInt(projectIdParam);
            ScheduleDAO scheduleDAO = new ScheduleDAO();
            boolean result = scheduleDAO.addTask(taskName, startDate, endDate, projectId);

            jsonResponse.put("success", result);
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("error", "Invalid project ID format.");
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("error", "Database error: " + e.getMessage());
        }
    } else {
        jsonResponse.put("success", false);
        jsonResponse.put("error", "Missing parameters.");
    }

    out.print(jsonResponse.toJSONString());
%>
