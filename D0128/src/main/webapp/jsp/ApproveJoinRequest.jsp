<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    Connection conn = null;
    PreparedStatement pstmt = null;
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

    // ✅ String 값을 int로 변환
    int requestId = Integer.parseInt(requestIdStr);
    int teamId = Integer.parseInt(teamIdStr);

    try {
        // ✅ 데이터베이스 연결
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle11g:1521/XE", "park", "1111");

        // ✅ 요청 상태를 "APPROVED"로 변경
        String updateSql = "UPDATE TEAM_REQUESTS SET STATUS = 'APPROVED' WHERE REQUEST_ID = ?";
        pstmt = conn.prepareStatement(updateSql);
        
        pstmt.setInt(1, requestId);
        int updatedRows = pstmt.executeUpdate();
        pstmt.close();

        if (updatedRows > 0) {
            // ✅ 승인된 요청을 TEAM_MEMBERS 테이블에 추가
            String insertSql = "INSERT INTO TEAM_MEMBERS (PROJECTTEAMID, USERID, JOINED_AT) VALUES (?, ?, SYSDATE)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt(1, teamId);
            pstmt.setString(2, userId);
            pstmt.executeUpdate();
            pstmt.close();

            responseJson.put("status", "success");
            responseJson.put("message", "참여 요청이 승인되었습니다.");
        } else {
            responseJson.put("status", "error");
            responseJson.put("message", "승인 실패: 요청을 찾을 수 없음");
        }
    } catch (Exception e) {
        e.printStackTrace();
        responseJson.put("status", "error");
        responseJson.put("message", "서버 오류 발생: " + e.getMessage());
    } finally {
        // ✅ 리소스 정리
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    // ✅ JSON 응답 출력
    out.print(responseJson.toJSONString());
%>
