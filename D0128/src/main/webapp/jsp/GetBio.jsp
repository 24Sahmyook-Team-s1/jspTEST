<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");

    String userId = request.getParameter("userId");
    JSONObject result = new JSONObject();

    // 디버깅: 전달된 userId 확인
    System.out.println("🔍 GetBio.jsp - 전달된 userId: '" + userId + "'");

    if (userId != null) {
        userId = userId.trim();  // 앞뒤 공백 제거
        System.out.println("🔍 GetBio.jsp - 트림된 userId: '" + userId + "'");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

            // 대소문자 문제 방지를 위해 UPPER 사용
            String sql = "SELECT BIO FROM USER2 WHERE UPPER(TRIM(USERID)) = UPPER(TRIM(?))";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                String bio = rs.getString("BIO");
                result.put("status", "success");
                result.put("bio", bio != null ? bio : "");
                System.out.println("✅ 불러온 BIO: " + bio);  // 디버깅 출력
            } else {
                result.put("status", "fail");
                result.put("message", "사용자를 찾을 수 없습니다.");
                System.out.println("❌ 사용자를 찾을 수 없습니다: '" + userId + "'");  // 디버깅 출력
            }
        } catch (Exception e) {
            result.put("status", "error");
            result.put("message", e.getMessage());
            System.out.println("❌ DB 오류 발생: " + e.getMessage());  // 디버깅 출력
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    } else {
        result.put("status", "fail");
        result.put("message", "잘못된 요청입니다.");
        System.out.println("❌ 잘못된 요청: userId가 없습니다.");  // 디버깅 출력
    }

    out.print(result.toJSONString());
%>
