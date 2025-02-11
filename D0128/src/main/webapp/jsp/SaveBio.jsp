<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    String userId = request.getParameter("userId").trim();
    String bio = request.getParameter("bio");
    boolean append = Boolean.parseBoolean(request.getParameter("append"));
    JSONObject result = new JSONObject();

    System.out.println("📤 저장 요청 - userId: " + userId + ", bio: " + bio + ", append: " + append); // 디버깅 로그 추가

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

        if (append) {
            String selectSql = "SELECT BIO FROM USER2 WHERE USERID = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            String existingBio = "";
            if (rs.next()) {
                existingBio = rs.getString("BIO");
            }

            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();

            String updatedBio = (existingBio == null || existingBio.isEmpty()) ? bio : existingBio + "\n" + bio;

            String updateSql = "UPDATE USER2 SET BIO = ? WHERE USERID = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, updatedBio);
            pstmt.setString(2, userId);
        } else {
            String sql = "UPDATE USER2 SET BIO = ? WHERE USERID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bio);
            pstmt.setString(2, userId);
        }

        int updatedRows = pstmt.executeUpdate();

        if (updatedRows > 0) {
            result.put("status", "success");
            System.out.println("✅ BIO 저장 성공!");
        } else {
            result.put("status", "fail");
            result.put("message", "사용자를 찾을 수 없습니다.");
            System.out.println("❌ 사용자 찾을 수 없음: " + userId);
        }

    } catch (Exception e) {
        result.put("status", "error");
        result.put("message", e.getMessage());
        System.out.println("❌ DB 오류 발생: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.setContentType("application/json;charset=UTF-8");
    out.print(result.toJSONString());
%>
