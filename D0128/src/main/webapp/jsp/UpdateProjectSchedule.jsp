<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.FeedDAO" %>
<%@ page import="java.sql.SQLException" %>

<%
    request.setCharacterEncoding("UTF-8");
    String message = "";

    try {
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        String mon = request.getParameter("monday") != null ? "Y" : "N";
        String tue = request.getParameter("tuesday") != null ? "Y" : "N";
        String wed = request.getParameter("wednesday") != null ? "Y" : "N";
        String thu = request.getParameter("thursday") != null ? "Y" : "N";
        String fri = request.getParameter("friday") != null ? "Y" : "N";

        FeedDAO dao = new FeedDAO();
        dao.updateProjectSchedule(projectId, mon, tue, wed, thu, fri);

        message = "프로젝트 스케줄이 성공적으로 업데이트되었습니다.";
    } catch (SQLException | NumberFormatException e) {
        e.printStackTrace();
        message = "스케줄 업데이트 중 오류가 발생했습니다.";
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>스케줄 업데이트 결과</title>
</head>
<body>
    <h2><%= message %></h2>
    <a href="GanttChart.html">간트 차트로 돌아가기</a>
</body>
</html>
