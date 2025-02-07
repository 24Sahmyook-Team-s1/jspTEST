<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectMemberDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>

<%
request.setCharacterEncoding("utf-8");
String message = "";
if (request.getMethod().equalsIgnoreCase("POST")) {
	request.setCharacterEncoding("utf-8");

	String projectId = request.getParameter("projectId");
	String userId = request.getParameter("userId");

	ProjectMemberDAO dao = new ProjectMemberDAO();
	boolean code = false;

	try {
		code = dao.exists(projectId, userId);
	} catch (NamingException | SQLException e) {
		e.printStackTrace();
	}

	if (code) {
		message = "멤버가 해당 프로젝트의 멤버입니다.";
	} else {
		message = "멤버 검색 중 오류가 발생했습니다.";
	}
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 구성원 확인</title>
</head>
<body>
	<h2>멤버 검색</h2>
	<%
	if (!message.isEmpty()) {
	%>
	<p><%=message%></p>
	<%
	}
	%>
	<form method="post">
		<label for="projectId">프로젝트 ID:</label> <input type="text"
			id="projectId" name="projectId" required><br>
		<br> <label for="userId">검색할 멤버 ID:</label> <input type="text"
			id="leaderId" name="userId" required><br>
		<br>

		<button type="submit">멤버 검색</button>
	</form>
</body>
</html>
