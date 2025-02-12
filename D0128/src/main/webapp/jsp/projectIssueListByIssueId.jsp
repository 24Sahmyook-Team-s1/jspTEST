<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="dao.ProjectissueDAO" %>
<%
    request.setCharacterEncoding("utf-8");
	String message = "";
    String jsonResult = "[]";
    ProjectissueDAO DAO = new ProjectissueDAO();
	if (request.getMethod().equalsIgnoreCase("POST")) {
	
		int issueid = Integer.parseInt(request.getParameter("issueid").trim());
	
	    // JSON 결과를 저장할 변수
	
	    try {
	        // 프로젝트 목록을 JSON 형식으로 가져오기
	        jsonResult = DAO.getIssuesByIssueIdJSON(issueid);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    	out.print(jsonResult);
	    }
	}
%>
