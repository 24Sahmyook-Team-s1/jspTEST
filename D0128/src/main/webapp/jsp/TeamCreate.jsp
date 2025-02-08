<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.TeamDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject responseJson = new JSONObject();

    String teamName = request.getParameter("teamName");
    String adminId = (String) session.getAttribute("id"); // 로그인한 사용자 ID

    // 로그인 체크
    if (adminId == null || adminId.isEmpty()) {
        responseJson.put("status", "error");
        responseJson.put("message", "로그인이 필요합니다.");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 상태 코드 설정
        out.print(responseJson.toJSONString());
        return; // 로그인하지 않은 경우, 처리를 중단합니다.
    }

    // 팀 이름 체크
    if (teamName == null || teamName.trim().isEmpty()) {
        responseJson.put("status", "error");
        responseJson.put("message", "팀 이름을 입력하세요.");
        out.print(responseJson.toJSONString());
        return; // 팀 이름이 없으면 처리를 중단합니다.
    }

    TeamDAO teamDAO = new TeamDAO();
    try {
        // 팀 이름 중복 체크
        if (teamDAO.isTeamNameExists(teamName)) {
            responseJson.put("status", "error");
            responseJson.put("message", "이미 존재하는 팀 이름입니다.");
            out.print(responseJson.toJSONString());
            return; // 중복된 이름이면 처리를 중단합니다.
        }

        // 중복이 없을 경우 팀 생성
        responseJson = teamDAO.createTeam(teamName, adminId);

    } catch (NamingException | SQLException e) {
        e.printStackTrace();
        responseJson.put("status", "error");
        responseJson.put("message", "서버 오류 발생: " + e.getMessage());
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 상태 코드 설정
    }

    out.print(responseJson.toJSONString());
%>
