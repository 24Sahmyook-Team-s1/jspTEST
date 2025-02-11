<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    String userId = request.getParameter("userId").toString().trim();
    JSONObject result = new JSONObject();

    System.out.println("📥 BIO 불러오기 요청 - userId: " + userId); // 디버깅 로그 추가

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

        String sql = "SELECT BIO FROM USER2 WHERE USERID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            String bio = rs.getString("BIO");
            result.put("status", "success");
            result.put("bio", bio != null ? bio : "");
            System.out.println("✅ 불러온 BIO: " + bio); // 디버깅 로그
        } else {
            result.put("status", "fail");
            result.put("message", "사용자를 찾을 수 없습니다.");
            System.out.println("❌ 사용자 찾을 수 없음: " + userId); // 디버깅 로그
        }

    } catch (Exception e) {
        result.put("status", "error");
        result.put("message", e.getMessage());
        System.out.println("❌ DB 오류 발생: " + e.getMessage()); // 디버깅 로그
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.setContentType("application/json;charset=UTF-8");
    out.print(result.toJSONString());
%>
