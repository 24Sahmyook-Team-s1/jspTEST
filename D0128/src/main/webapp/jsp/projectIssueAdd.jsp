<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            String projectIdStr = request.getParameter("projectid");
            String title = request.getParameter("title");
            String description = request.getParameter("description");

            // 디버깅용 로그 추가
            System.out.println("Received Data:");
            System.out.println("projectuserid: " + projectuserid);
            System.out.println("projectid: " + projectIdStr);
            System.out.println("title: " + title);
            System.out.println("description: " + description);

            // null 체크 및 예외 처리
            if (projectuserid != null && !projectuserid.isEmpty() &&
                projectIdStr != null && !projectIdStr.isEmpty() &&
                title != null && !title.isEmpty() &&
                description != null && !description.isEmpty()) {

                int projectid = Integer.parseInt(projectIdStr);
                DAO.addIssue(projectuserid, projectid, title, description);
                message = "프로젝트 이슈가 성공적으로 추가되었습니다.";
            } else {
                message = "모든 필드를 입력해주세요.";
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            message = "프로젝트 코드가 올바른 숫자가 아닙니다.";
        } catch (Exception e) {
            e.printStackTrace();
            message = "프로젝트 이슈를 추가하는 중 오류가 발생했습니다.";
        }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>프로젝트 이슈 등록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }
        h2 {
            color: #333;
        }
        form {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            margin: auto;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
        }
        input {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
        }
        button:hover {
            background-color: #45a049;
        }
        .message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <h2>프로젝트 이슈 추가</h2>
    <% if (!message.isEmpty()) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <form method="post">
        <label for="projectuserid">작성자 코드:</label>
        <input type="text" id="projectuserid" name="projectuserid" required>

        <label for="projectid">프로젝트 코드:</label>
        <input type="text" id="projectid" name="projectid" required>

        <label for="title">제목:</label>
        <input type="text" id="title" name="title" required>

        <label for="description">본문:</label>
        <input type="text" id="description" name="description" required>

        <button type="submit">프로젝트 이슈 추가</button>
    </form>
</body>
</html>
