<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.TeamDAO, org.json.simple.JSONObject, java.sql.SQLException, javax.naming.NamingException" %>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject responseJson = new JSONObject();

    // ✅ 요청된 파라미터 받기
    String requestIdStr = request.getParameter("requestId");
    String userId = request.getParameter("userId");
    String teamIdStr = request.getParameter("teamId");

    // ✅ 디버깅 로그 출력
    System.out.println("🔹 승인 요청 도착: requestId=" + requestIdStr + ", userId=" + userId + ", teamId=" + teamIdStr);

    // 🔴 데이터 확인: requestId 또는 teamId가 제대로 들어오지 않으면 오류 반환
    if (requestIdStr == null || userId == null || teamIdStr == null ||
        requestIdStr.isEmpty() || userId.isEmpty() || teamIdStr.isEmpty() || 
        "undefined".equals(teamIdStr) || !teamIdStr.matches("\\d+")) {

        responseJson.put("status", "error");
        responseJson.put("message", "잘못된 요청입니다. (requestId, userId, teamId 없음 또는 잘못된 값)");
        out.print(responseJson.toJSONString());
        return;
    }

    try {
        // ✅ String 값을 int로 변환
        int requestId = Integer.parseInt(requestIdStr);
        int teamId = Integer.parseInt(teamIdStr);

        // ✅ DAO 호출하여 승인 요청 처리
        TeamDAO dao = new TeamDAO();
        boolean success = dao.approveRequest(requestId, userId, teamId);

        if (success) {
            responseJson.put("status", "success");
            responseJson.put("message", "참여 요청이 승인되었습니다.");
        } else {
            responseJson.put("status", "error");
            responseJson.put("message", "승인 실패: 요청을 찾을 수 없음");
        }
    } catch (SQLException | NamingException e) {
        e.printStackTrace();
        responseJson.put("status", "error");
        responseJson.put("message", "서버 오류 발생: " + e.getMessage());
    }

    // ✅ JSON 응답 출력
    out.print(responseJson.toJSONString());
%>
