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
			String projectuserid = request.getParameter("projectuserid");
			int projectid = Integer.parseInt(request.getParameter("projectid"));
			String title = request.getParameter("title");
			String description = request.getParameter("description");
		    DAO.addIssue(projectuserid, projectid, title, description);
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
    <title>프로젝트 이슈 등록</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
	<h2>프로젝트 이슈 추가</h2>
	<%
	if (!message.isEmpty()) {
	%>
	<p><%=message%></p>
	<%
	}
	%>
	<form method="post">
		<label for="user2">작성자 코드:</label> 
		<input type="text" id="user2" name="user2" required>
		
		<label for="projectid">프로젝트 코드:</label> 
		<input type="text" id="projectid" name="projectid" required>
		
		<label for="title">제목:</label> 
		<input type="text" id="title" name="title" required>
		
		<label for="description">본문:</label> 
		<input type="text" id="description" name="description" required>
		<br><br>
		<button type="submit">프로젝트 이슈 추가</button>
	</form>

    
</body>
</html>
