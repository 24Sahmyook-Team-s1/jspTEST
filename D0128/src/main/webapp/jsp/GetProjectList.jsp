<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="dao.ProjectDAO" %>
<%

    request.setCharacterEncoding("UTF-8");

	ProjectDAO projectdao = new ProjectDAO();
    JSONArray projectList = new JSONArray();

    projectList =projectdao.getAllProjects();
    
    out.print(projectList.toJSONString());
%>
