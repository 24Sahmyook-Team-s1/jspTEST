<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
    String projectId = request.getParameter("projectId");

    if (projectId == null || projectId.isEmpty()) {
        out.print("{\"status\":\"fail\", \"message\":\"프로젝트 ID가 전달되지 않았습니다.\"}");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    JSONArray postList = new JSONArray();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

        String sql = "SELECT * FROM PROJECTBOARD WHERE PROJECTID = ? ORDER BY CREATED_AT DESC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, projectId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject post = new JSONObject();
            post.put("id", rs.getInt("BOARDID"));
            post.put("title", rs.getString("TITLE"));
            post.put("content", rs.getString("CONTENT"));
            post.put("createdAt", rs.getString("CREATED_AT"));
            post.put("userId", rs.getString("USERID"));
            post.put("imagePath", rs.getString("FILEPATH"));  // FILEPATH 컬럼 사용
            postList.add(post);
        }

        out.print(postList.toJSONString());

    } catch (Exception e) {
        out.print("{\"status\":\"fail\", \"message\":\"" + e.getMessage() + "\"}");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>