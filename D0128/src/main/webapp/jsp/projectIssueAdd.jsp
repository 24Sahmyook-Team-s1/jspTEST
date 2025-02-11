<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectissueDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dao.ProjectissueObj" %>
<%
	request.setCharacterEncoding("utf-8");
	String message = "";
	ProjectissueDAO DAO = new ProjectissueDAO();

	int projectid = Integer.parseInt(request.getParameter("projectid").trim());
	int level = Integer.parseInt(request.getParameter("level").trim());
	String userid = request.getParameter("userid").trim();
	String title = request.getParameter("title").trim();
	String description = request.getParameter("description").trim();
	
    try {
    	DAO.addIssue(userid, projectid, title, description, level);
    	out.print("insert suceess");
    } catch (Exception e) {
        e.printStackTrace();
    }
    
%>

