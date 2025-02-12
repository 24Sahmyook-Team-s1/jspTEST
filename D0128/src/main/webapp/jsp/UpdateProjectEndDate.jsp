<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ProjectDAO, javax.naming.NamingException, java.sql.SQLException" %>
<%@ page import="java.io.PrintWriter" %>

<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String projectId = request.getParameter("projectId");
    String newEndDate = request.getParameter("endDate"); // 최신 `end_date` 값

    PrintWriter writer = response.getWriter();

    if (projectId == null || newEndDate == null) {
        writer.print("{\"success\": false, \"message\": \"Missing parameters\"}");
        writer.flush();
        return;
    }

    ProjectDAO projectDAO = new ProjectDAO();

    try {
        boolean updated = projectDAO.updateProjectEndDate(Integer.parseInt(projectId), newEndDate);
        if (updated) {
            writer.print("{\"success\": true, \"message\": \"Project end_date updated successfully\"}");
        } else {
            writer.print("{\"success\": false, \"message\": \"Failed to update end_date\"}");
        }
    } catch (NamingException | SQLException e) {
        writer.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
    } finally {
        writer.flush();
    }
%>
