<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>

<%
request.setCharacterEncoding("utf-8");
String message = "";
if (request.getMethod().equalsIgnoreCase("POST")) {
	request.setCharacterEncoding("utf-8");

	String projectname = request.getParameter("projectname");

	ProjectDAO dao = new ProjectDAO();
	boolean code = false;

	try {
		code = dao.delete(projectname);
	} catch (NamingException | SQLException e) {
		e.printStackTrace();
	}

	if (code) {
		message = "프로젝트를 삭제 했습니다.";
	} else {
		message = "프로젝트가 없거나 삭제 중 오류가 발생했습니다.";
	}
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 삭제</title>
</head>
<body>
	<h2>프로젝트 삭제</h2>
	<%
	if (!message.isEmpty()) {
	%>
	<p><%=message%></p>
	<%
	}
	%>
	<form method="post">
		<label for="projectname">프로젝트 ID:</label> 
		<input type="text" id="projectname" name="projectname" required>
		<br>
		<br> 
		<br>
		<br>

		<button type="submit">프로젝트 삭제</button>
	</form>
</body>
</html>
