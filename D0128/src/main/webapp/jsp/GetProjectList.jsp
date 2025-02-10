<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="dao.ProjectDAO" %>

<%

    request.setCharacterEncoding("UTF-8");
    String uid = (String) session.getAttribute("id");
	ProjectDAO projectdao = new ProjectDAO();
    JSONArray projectList = new JSONArray();



    projectList =projectdao.getProjectsByUserId(uid);

    
    out.print(projectList.toJSONString());

%>

