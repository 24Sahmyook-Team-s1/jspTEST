<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.TeamDAO, org.json.simple.JSONArray, java.sql.SQLException, javax.naming.NamingException" %>

<%
    request.setCharacterEncoding("UTF-8");

    // ✅ 현재 로그인한 관리자 ID 가져오기
    String adminId = (String) session.getAttribute("id");

    //if (adminId == null || adminId.isEmpty()) {
    //    out.print("{\"status\": \"error\", \"message\": \"로그인이 필요합니다.\"}");
     //   return;
   // }

    try {
        // ✅ DAO 호출하여 대기 중인 요청 목록 가져오기
        TeamDAO dao = new TeamDAO();
        JSONArray requestList = dao.getPendingRequests();
        out.print(requestList.toJSONString()); // JSON 응답 출력
    } catch (SQLException | NamingException e) {

        e.printStackTrace();
        out.print("{\"status\": \"error\", \"message\": \"서버 오류 발생: " + e.getMessage() + "\"}");
    }
%>
