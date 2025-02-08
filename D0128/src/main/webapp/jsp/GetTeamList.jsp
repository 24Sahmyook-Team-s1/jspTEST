<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.TeamDAO" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.sql.SQLException" %>

<%
    request.setCharacterEncoding("UTF-8");
    TeamDAO teamDAO = new TeamDAO();
    JSONArray teamList = new JSONArray();

    try {
        teamList = teamDAO.getTeamList(); // TeamDAO를 통해 팀 목록 가져오기
    } catch (SQLException e) {
        e.printStackTrace(); // 오류를 콘솔에 출력
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 상태 코드 설정
        out.print("{\"error\": \"팀 목록을 가져오는 데 실패했습니다.\"}"); // JSON 형태로 오류 메시지 반환
        return; // 추가 처리 중단
    }

    out.print(teamList.toJSONString()); // JSON 형태로 팀 목록 출력
%>
