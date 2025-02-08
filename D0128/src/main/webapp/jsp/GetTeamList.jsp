<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray teamList = new JSONArray();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle11g:1521/XE", "park", "1111");

        String sql = "SELECT PROJECTTEAMID, TEAMNAME, TO_CHAR(CREATEDAT, 'YYYY-MM-DD') AS CREATEDAT FROM PROJECTTEAMS ORDER BY CREATEDAT DESC";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject team = new JSONObject();
            team.put("id", rs.getInt("PROJECTTEAMID"));
            team.put("name", rs.getString("TEAMNAME"));
            team.put("created_at", rs.getString("CREATEDAT"));
            teamList.add(team);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print(teamList.toJSONString());
%>
