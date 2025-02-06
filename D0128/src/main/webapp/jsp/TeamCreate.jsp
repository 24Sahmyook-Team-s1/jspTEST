<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 로그인된 사용자 ID 가져오기 (세션에서)
    String adminUserID = (String) session.getAttribute("userID"); // 세션에서 userID 가져오기
    String teamName = request.getParameter("teamName"); // 사용자가 입력한 팀 이름

    if (adminUserID != null && teamName != null && !teamName.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "park", "1111");

            String sql = "INSERT INTO PROJECTTEAMS (PROJECTTEAMID, TEAMNAME, ADMINUSERID, CREATEDAT) VALUES (PROJECTTEAMS_SEQ.NEXTVAL, ?, ?, SYSDATE)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, teamName);
            pstmt.setString(2, adminUserID);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                out.println("<script>alert('팀이 생성되었습니다!'); location.href='TeamPage.jsp';</script>");
            } else {
                out.println("<script>alert('팀 생성 실패! 다시 시도해주세요.'); history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    } else {
        out.println("<script>alert('올바른 입력값을 제공해주세요!'); history.back();</script>");
    }
%>
