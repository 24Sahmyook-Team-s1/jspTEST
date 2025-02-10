<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="dao.ProjectissueDAO" %>
<%
    //request.setCharacterEncoding("UTF-8");

//	ProjectissueDAO dao = new ProjectissueDAO();
//    JSONArray List = new JSONArray();

//	int projectid = 1;
//    List = dao.getIssuesByProjectIdJSON(projectid);
    
//    out.print(List.toJSONString());
    
    request.setCharacterEncoding("utf-8");
	String message = "";
    String jsonResult = "[]";
    ProjectissueDAO DAO = new ProjectissueDAO();
	if (request.getMethod().equalsIgnoreCase("POST")) {
	
		int projectid = 1;//request.getParameter("projectid");
	
	    // JSON 결과를 저장할 변수
	
	    try {
	        // 프로젝트 목록을 JSON 형식으로 가져오기
	        jsonResult = DAO.getIssuesByProjectIdJSON(projectid);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    	out.print(jsonResult);
	    }
	}
%>
