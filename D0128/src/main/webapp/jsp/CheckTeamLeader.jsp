<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("id");
    if (userId == null) {
        out.print("{\"isLeader\": false}");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isLeader = false;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle11g:1521/XE", "park", "1111");

        String sql = "SELECT COUNT(*) FROM PROJECTTEAMS WHERE ADMINUSERID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        if (rs.next() && rs.getInt(1) > 0) {
            isLeader = true;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print("{\"isLeader\": " + isLeader + "}");
%>
