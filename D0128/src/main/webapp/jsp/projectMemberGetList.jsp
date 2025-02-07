<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectMemberDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%
	request.setCharacterEncoding("utf-8");
	String message = "";
    String jsonResult = "[]";
    ProjectMemberDAO projectMemberDAO = new ProjectMemberDAO();
	if (request.getMethod().equalsIgnoreCase("POST")) {
	
		String projectid = request.getParameter("projectid");
	
	    // JSON 결과를 저장할 변수
	
	    try {
	        // 프로젝트 목록을 JSON 형식으로 가져오기
	        jsonResult = projectMemberDAO.getList(projectid);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>프로젝트 구성원 목록</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
	<h2>프로젝트 구성원 검색</h2>
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
		<br>
		<br> 
		<br>
		<br>

		<button type="submit">프로젝트 구성원 찾기</button>
	

    <h1>프로젝트 목록</h1>
    <table>
        <thead>
            <tr>
                <th>프로젝트 ID</th>
                <th>구성원 ID</th>
            </tr>
        </thead>
        <tbody>
            <%
                // JSON 배열을 파싱하여 HTML 테이블에 표시
                JSONArray projectList = (JSONArray) new JSONParser().parse(jsonResult);
                for (Object obj : projectList) {
                    JSONObject project = (JSONObject) obj;
            %>
            <tr>
                <td><%= project.get("project") %></td>
                <td><%= project.get("user") %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
	</form>
</body>
</html>