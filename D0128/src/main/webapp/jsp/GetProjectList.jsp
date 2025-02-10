<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="dao.ProjectDAO" %>

<%
	response.setContentType("application/json;charset=UTF-8");
    ProjectDAO projectDAO = new ProjectDAO();
    JSONArray projects = projectDAO.getAllProjects();
    out.print(projects.toJSONString());
%>
