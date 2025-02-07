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
			int projectid = Integer.parseInt(request.getParameter("projectid"));
		    issues = DAO.getIssuesByProjectId(projectid);
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
    <title>프로젝트 이슈 목록</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
	<h2>프로젝트 이슈 출력</h2>
	<%
	if (!message.isEmpty()) {
	%>
	<p><%=message%></p>
	<%
	}
	%>
	<form method="post">
		<label for="projectid">프로젝트 코드:</label> 
		<input type="text" id="projectid" name="projectid" required>
		<br><br>
		<button type="submit">프로젝트 이슈 출력</button>
	</form>

    <h1>프로젝트 이슈 목록</h1>
    <table>
        <thead>
            <tr>
                <th>프로젝트 이슈 ID</th>
                <th>멤버 ID</th>
                <th>프로젝트 ID</th>
                <th>타이틀</th>
                <th>설명</th>
                <th>생성일</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (ProjectissueObj issue : issues) {
            %>
            <tr>
                <td><%= issue.getProjectIssueId() %></td>
                <td><%= issue.getProjectUserId() %></td>
                <td><%= issue.getProjectId() %></td>
                <td><%= issue.getTitle() %></td>
                <td><%= issue.getDescription() %></td>
                <td><%= issue.getCreatedAt() %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
