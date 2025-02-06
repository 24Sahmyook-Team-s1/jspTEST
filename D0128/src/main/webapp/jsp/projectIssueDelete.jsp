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
	List<ProjectissueObj> issues = new ArrayList<>();
    ProjectissueDAO DAO = new ProjectissueDAO();
	if (request.getMethod().equalsIgnoreCase("POST")) {
		try {
			int projectissueid = Integer.parseInt(request.getParameter("projectissueid"));
			DAO.deleteIssue(projectissueid);
		} catch (Exception e) {
		    e.printStackTrace();
		    message = "프로젝트 이슈를 불러오는 중 오류가 발생했습니다.";
		}
	}
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>프로젝트 이슈 삭제</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
	<h2>프로젝트 이슈 지우기</h2>
	<%
	if (!message.isEmpty()) {
	%>
	<p><%=message%></p>
	<%
	}
	%>
	<form method="post">
		<label for="projectissueid">프로젝트 코드:</label> 
		<input type="text" id="projectissueid" name="projectissueid" required>
		
		<br><br>
		<button type="submit">프로젝트 이슈 삭제</button>
	</form>

    
</body>
</html>
