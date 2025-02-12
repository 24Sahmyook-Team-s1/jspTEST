<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectissueDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>
<%
	request.setCharacterEncoding("utf-8");
	String message = "";
    ProjectissueDAO DAO = new ProjectissueDAO();
	if (request.getMethod().equalsIgnoreCase("POST")) {
		try {
			int projectissueid = Integer.parseInt(request.getParameter("issueid"));
			DAO.deleteIssue(projectissueid);
		} catch (Exception e) {
		    e.printStackTrace();
		    message = "프로젝트 이슈를 불러오는 중 오류가 발생했습니다.";
		}
	}
%>