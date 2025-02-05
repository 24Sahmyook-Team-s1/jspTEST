<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>
<%
request.setCharacterEncoding("utf-8");
ProjectDAO projectDAO = new ProjectDAO();
String projectList = "[]";
try {
	projectList = projectDAO.getList();
} catch (NamingException | SQLException e) {
	e.printStackTrace();
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 목록</title>
</head>
<body>
	<h2>프로젝트 목록</h2>
	<pre><%=projectList%></pre>
</body>
</html>
