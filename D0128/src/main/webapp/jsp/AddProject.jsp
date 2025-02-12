<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectDAO" %>
<%@ page import="dao.TeamDAO" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");


    String projectName = request.getParameter("projectName");
    String adminUserID = request.getParameter("adminUserID");
    String projectDesc = request.getParameter("projectDesc");
    
    System.out.println("addproject.jsp requested projectName: " + projectName);
    System.out.println("addproject.jsp requested adminuserid: " + adminUserID);
    System.out.println("addproject.jsp requested projectDesc: " + projectDesc);
    

    ProjectDAO projectDAO = new ProjectDAO();
    TeamDAO teamdao = new TeamDAO();
    boolean result = projectDAO.addProject(projectName, adminUserID, projectDesc);

    JSONObject jsonResponse = new JSONObject();
    jsonResponse.put("success", result);

    out.print(jsonResponse.toJSONString());
%>