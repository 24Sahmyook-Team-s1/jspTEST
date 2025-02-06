<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    Connection conn = null;
    PreparedStatement pstmt = null;
    JSONObject responseJson = new JSONObject();

    String teamName = request.getParameter("teamName");
    String adminId = (String) session.getAttribute("id"); // ✅ 로그인한 사용자 ID

    if (adminId == null || adminId.isEmpty()) {
        responseJson.put("status", "error");
        responseJson.put("message", "로그인이 필요합니다.");
        out.print(responseJson.toJSONString());
        return;
    }

    if (teamName == null || teamName.trim().isEmpty()) {
        responseJson.put("status", "error");
        responseJson.put("message", "팀 이름을 입력하세요.");
        out.print(responseJson.toJSONString());
        return;
    }

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/XE", "park", "1111");

        // ✅ 자동 증가되는 TeamID 추가
        String sql = "INSERT INTO PROJECTTEAMS (PROJECTTEAMID, TEAMNAME, CREATEDAT, ADMINUSERID) VALUES (PROJECTTEAMS_SEQ.NEXTVAL, ?, SYSDATE, ?)";

        pstmt = conn.prepareStatement(sql, new String[]{"PROJECTTEAMID"}); // ✅ 생성된 ID 가져오기
        pstmt.setString(1, teamName);
        pstmt.setString(2, adminId);
        
        int rows = pstmt.executeUpdate();
        ResultSet rs = pstmt.getGeneratedKeys(); // ✅ 생성된 TeamID 가져오기

        int teamId = -1;
        if (rs.next()) {
            teamId = rs.getInt(1); // ✅ 방금 생성된 TeamID 저장
        }

        if (rows > 0 && teamId != -1) {
            responseJson.put("status", "success");
            responseJson.put("message", "팀이 성공적으로 생성되었습니다!");
            responseJson.put("teamId", teamId); // ✅ 생성된 팀 ID 반환
        } else {
            responseJson.put("status", "error");
            responseJson.put("message", "팀 생성 실패.");
        }

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
