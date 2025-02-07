<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    Connection conn = null;
    PreparedStatement pstmt = null;
    JSONObject responseJson = new JSONObject();

    String requestId = request.getParameter("requestId");

    if (requestId == null || requestId.isEmpty()) {
        responseJson.put("status", "error");
        responseJson.put("message", "유효한 요청 정보가 필요합니다.");
        out.print(responseJson.toJSONString());
        return;
    }

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/XE", "park", "1111");

        // ✅ 요청 상태 변경
        String updateRequestSql = "UPDATE TEAM_REQUESTS SET STATUS = 'REJECTED' WHERE REQUEST_ID = ?";
        pstmt = conn.prepareStatement(updateRequestSql);
        pstmt.setInt(1, Integer.parseInt(requestId));
        pstmt.executeUpdate();

        responseJson.put("status", "success");
        responseJson.put("message", "팀 참여 요청을 거절하였습니다.");
    } catch (Exception e) {
        e.printStackTrace();
        responseJson.put("status", "error");
        responseJson.put("message", "서버 오류 발생: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print(responseJson.toJSONString());
%>
