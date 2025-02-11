<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String projectId = request.getParameter("projectId");
    String userId = request.getParameter("userId");

    if (title == null || content == null || projectId == null || userId == null) {
        out.print("{\"status\":\"fail\", \"message\":\"모든 필드를 입력하세요.\"}");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

        String sql = "INSERT INTO PROJECTBOARD (PROJECTID, USERID, TITLE, CONTENT, CREATED_AT) VALUES (?, ?, ?, ?, SYSDATE)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, projectId);
        pstmt.setString(2, userId);
        pstmt.setString(3, title);
        pstmt.setString(4, content);

        int result = pstmt.executeUpdate();
        if (result > 0) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"fail\", \"message\":\"데이터베이스 저장 실패.\"}");
        }
    } catch (Exception e) {
        out.print("{\"status\":\"fail\", \"message\":\"" + e.getMessage() + "\"}");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
