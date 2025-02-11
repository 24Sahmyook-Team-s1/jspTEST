<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%
    String projectId = request.getParameter("projectId");
    JSONArray posts = new JSONArray();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

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
            post.put("filepath", rs.getString("FILEPATH"));
            posts.add(post);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.setContentType("application/json;charset=UTF-8");
    out.print(posts.toJSONString());
%>
