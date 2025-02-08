<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = request.getParameter("id");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray projectList = new JSONArray();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle11g:1521:XE", "park", "1111");

        // 사용자가 속한 프로젝트 ID 조회
        String sql = "SELECT ProjectID FROM Projects WHERE ProjectTeamID IN (SELECT ProjectTeamID FROM TeamMembers WHERE ProjectUserID = ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject project = new JSONObject();
            project.put("id", rs.getInt("ProjectID"));
            projectList.add(project);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print(projectList.toJSONString());
%>
