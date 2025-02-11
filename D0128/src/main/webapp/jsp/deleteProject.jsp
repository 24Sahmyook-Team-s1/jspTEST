<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    String projectId = request.getParameter("projectId");
    JSONObject result = new JSONObject();

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

        String sql = "DELETE FROM PROJECTS WHERE PROJECTID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, projectId);

        int deletedRows = pstmt.executeUpdate();

        if (deletedRows > 0) {
            result.put("status", "success");
        } else {
            result.put("status", "fail");
            result.put("message", "프로젝트를 찾을 수 없습니다.");
        }

    } catch (Exception e) {
        result.put("status", "error");
        result.put("message", e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.setContentType("application/json;charset=UTF-8");
    out.print(result.toJSONString());
%>
