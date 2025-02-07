<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray requestList = new JSONArray(); // 요청 목록을 저장할 배열

    // ✅ 현재 로그인한 관리자 ID 가져오기
    String adminId = (String) session.getAttribute("id");

    if (adminId == null || adminId.isEmpty()) {
        out.print("{\"status\": \"error\", \"message\": \"로그인이 필요합니다.\"}");
        return;
    }

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/XE", "park", "1111");

        // ✅ 관리자의 팀에 대한 참여 요청 조회
        String sql = "SELECT r.REQUESTID, r.USERID, u.JSONSTR, r.REQUEST_DATE " +
                     "FROM TEAM_JOIN_REQUESTS r " +
                     "JOIN PROJECTTEAMS t ON r.TEAMID = t.PROJECTTEAMID " +
                     "JOIN USER2 u ON r.USERID = u.ID " +
                     "WHERE t.ADMINUSERID = ? AND r.STATUS = 'PENDING'";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, adminId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject requestData = new JSONObject(); // 🔹 requestData로 변경하여 충돌 방지
            requestData.put("requestId", rs.getInt("REQUESTID"));
            requestData.put("userId", rs.getString("USERID"));
            requestData.put("requestDate", rs.getString("REQUEST_DATE"));
            requestList.add(requestData);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print(requestList.toJSONString()); // JSON 응답 출력
%>
