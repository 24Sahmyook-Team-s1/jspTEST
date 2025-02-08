<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="dao.ProjectDAO" %>
<%

    request.setCharacterEncoding("UTF-8");

	ProjectDAO projectdao = new ProjectDAO();
    JSONArray projectList = new JSONArray();

    projectList =projectdao.getAllProjects();
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
    <h1>프로젝트 목록</h1>
    <table>
        <thead>
            <tr>
                <th>프로젝트 ID</th>
                <th>프로젝트 이름</th>
                <th>생성일</th>
            </tr>
        </thead>
        <tbody>
            <%
                // JSON 배열을 HTML 테이블에 표시
                for (Object obj : projectList) {
                    JSONObject project = (JSONObject) obj;
            %>
            <tr>
                <td><%= project.get("id") %></td>
                <td><%= project.get("name") %></td>
                <td><%= project.get("created_at") %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
