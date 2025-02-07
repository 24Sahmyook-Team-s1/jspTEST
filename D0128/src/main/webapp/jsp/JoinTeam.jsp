<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    Connection conn = null;
    PreparedStatement pstmt = null;
    JSONObject responseJson = new JSONObject();

    // ✅ 현재 로그인한 사용자 ID 가져오기
    String userId = (String) session.getAttribute("id");
    String teamIdStr = request.getParameter("teamId");

    if (userId == null || userId.isEmpty() || teamIdStr == null || teamIdStr.isEmpty()) {
        responseJson.put("status", "error");
        responseJson.put("message", "로그인이 필요하거나 유효한 팀 ID가 필요합니다.");
        out.print(responseJson.toJSONString());
        return;
    }

    int teamId = Integer.parseInt(teamIdStr);

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/XE", "park", "1111");

        // ✅ 중복 신청 확인
        String checkSql = "SELECT COUNT(*) FROM TEAM_REQUESTS WHERE USER_ID = ? AND TEAM_ID = ? AND STATUS = 'PENDING'";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, userId);
        pstmt.setInt(2, teamId);
        ResultSet rs = pstmt.executeQuery();
        rs.next();
        if (rs.getInt(1) > 0) {
            responseJson.put("status", "error");
            responseJson.put("message", "이미 팀에 참여 신청을 보냈습니다.");
            out.print(responseJson.toJSONString());
            return;
        }
        rs.close();
        pstmt.close();

        // ✅ 팀 참가 요청 삽입
        String sql = "INSERT INTO TEAM_REQUESTS (TEAM_ID, USER_ID, STATUS, REQUEST_DATE) VALUES (?, ?, 'PENDING', SYSDATE)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, teamId);
        pstmt.setString(2, userId);
        pstmt.executeUpdate();

        responseJson.put("status", "success");
        responseJson.put("message", "팀 참가 신청이 완료되었습니다.");
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
