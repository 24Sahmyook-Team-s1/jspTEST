<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%
	request.setCharacterEncoding("utf-8");
	String message = "";
    String jsonResult = "[]";
    ProjectDAO projectDAO = new ProjectDAO();
	if (request.getMethod().equalsIgnoreCase("POST")) {
	
		String projectname = request.getParameter("projectname");
	
	    // JSON 결과를 저장할 변수
	
	    try {
	        // 프로젝트 목록을 JSON 형식으로 가져오기
	        jsonResult = projectDAO.getProjectByprojectname(projectname);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>프로젝트 목록</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
	<h2>프로젝트 검색</h2>
	<%
	if (!message.isEmpty()) {
	%>
	<p><%=message%></p>
	<%
	}
	%>
	<form method="post">
		<label for="projectname">프로젝트 이름:</label> 
		<input type="text" id="projectname" name="projectname" required>
		<br>
		<br> 
		<br>
		<br>

		<button type="submit">프로젝트 찾기</button>
	

    <h1>프로젝트 목록</h1>
    <table>
        <thead>
            <tr>
                <th>프로젝트 ID</th>
                <th>프로젝트 이름</th>
                <th>생성일</th>
                <th>프로젝트 리더</th> <!-- 프로젝트 리더 열 추가 -->
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
                <td><%= project.get("no") %></td>
                <td><%= project.get("name") %></td>
                <td><%= project.get("created_at") %></td>
                <td><%= project.get("projectLeader") %></td> <!-- 프로젝트 리더 데이터 표시 -->
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
	</form>
</body>
</html>