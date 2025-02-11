<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");

    String userId = request.getParameter("userId");
    String bio = request.getParameter("bio");
    JSONObject result = new JSONObject();

    // 불필요한 텍스트 제거
    if (userId != null && userId.contains("현재 로그인한 사용자 ID:")) {
        userId = userId.replace("현재 로그인한 사용자 ID:", "").trim();
    }

    System.out.println("📤 SaveBio.jsp - 정제된 userId: '" + userId + "', bio: '" + bio + "'");

    if (userId != null && bio != null) {
        userId = userId.trim();  // 공백 제거
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

            String sql = "UPDATE USER2 SET BIO = ? WHERE UPPER(TRIM(USERID)) = UPPER(TRIM(?))";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bio);
            pstmt.setString(2, userId);

            int updatedRows = pstmt.executeUpdate();

            if (updatedRows > 0) {
                result.put("status", "success");
                System.out.println("✅ BIO 업데이트 성공, 업데이트된 행 수: " + updatedRows);
            } else {
                result.put("status", "fail");
                result.put("message", "사용자를 찾을 수 없습니다.");
                System.out.println("❌ 사용자 찾을 수 없음: '" + userId + "'");
            }
        } catch (Exception e) {
            result.put("status", "error");
            result.put("message", e.getMessage());
            System.out.println("❌ DB 오류 발생: " + e.getMessage());
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    } else {
        result.put("status", "fail");
        result.put("message", "잘못된 요청입니다.");
        System.out.println("❌ 잘못된 요청: userId 또는 bio가 없습니다.");
    }

    out.print(result.toJSONString());
%>
