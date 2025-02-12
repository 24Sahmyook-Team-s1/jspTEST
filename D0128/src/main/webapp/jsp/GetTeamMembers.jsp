<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.TeamDAO" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    String projectIDStr = (String) session.getAttribute("projectId");

    if (projectIDStr == null) {
        out.print("{\"status\":\"fail\", \"message\":\"프로젝트 ID가 세션에 없습니다.\"}");
        return;
    }

    try {
        int projectId = Integer.parseInt(projectIDStr);
        TeamDAO teamDAO = new TeamDAO();
        JSONArray teamMembers = teamDAO.getTeamMembersByProjectId(projectId);

        out.print(teamMembers.toJSONString());
    } catch (Exception e) {
        out.print("{\"status\":\"error\", \"message\":\"서버 오류 발생: " + e.getMessage() + "\"}");
    }
%>