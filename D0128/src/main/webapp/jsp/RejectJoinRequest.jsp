<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.JSONObject, java.sql.SQLException" %>
<%@ page import="dao.TeamDAO" %>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject responseJson = new JSONObject();
    
    String requestId = request.getParameter("requestId");

    if (requestId == null || requestId.isEmpty()) {
        responseJson.put("status", "error");
        responseJson.put("message", "유효한 요청 정보가 필요합니다.");
        out.print(responseJson.toJSONString());
        return;
    }

    try {
        TeamDAO dao = new TeamDAO();
        boolean success = dao.rejectJoinRequest(Integer.parseInt(requestId));

        if (success) {
            responseJson.put("status", "success");
            responseJson.put("message", "팀 참여 요청을 거절하였습니다.");
        } else {
            responseJson.put("status", "error");
            responseJson.put("message", "요청을 찾을 수 없습니다.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        responseJson.put("status", "error");
        responseJson.put("message", "서버 오류 발생: " + e.getMessage());
    }

    out.print(responseJson.toJSONString());
%>
