<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
    String projectId = (String) session.getAttribute("projectID");
    JSONArray teamList = new JSONArray();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

        String sql = "SELECT u.USERID, u.JSONSTR " +
                     "FROM TEAMMEMBERS t " +
                     "JOIN USER2 u ON t.USERID = u.USERID " +
                     "WHERE t.PROJECTID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, projectId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject member = new JSONObject();
            String jsonStr = rs.getString("JSONSTR");
            JSONObject jsonData = (JSONObject) new org.json.simple.parser.JSONParser().parse(jsonStr);

            member.put("userID", rs.getString("USERID"));
            member.put("name", jsonData.get("name"));
            member.put("email", jsonData.get("id"));

            teamList.add(member);
        }

        out.print(teamList.toJSONString());

    } catch (Exception e) {
        out.print("{\"status\":\"error\", \"message\":\"팀원 정보를 불러오는 데 실패했습니다: " + e.getMessage() + "\"}");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
