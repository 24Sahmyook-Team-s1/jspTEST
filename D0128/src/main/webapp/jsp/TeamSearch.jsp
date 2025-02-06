<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>팀 찾기</title>
    <link rel="stylesheet" href="css/TeamPage.css">
</head>
<body>
    <h2>팀 목록</h2>
    <table border="1">
        <tr>
            <th>팀 ID</th>
            <th>팀 이름</th>
            <th>관리자</th>
            <th>생성 날짜</th>
        </tr>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "park", "1111");

                String sql = "SELECT P.PROJECTTEAMID, P.TEAMNAME, U.ID AS ADMIN, P.CREATEDAT FROM PROJECTTEAMS P JOIN user2 U ON P.ADMINUSERID = U.ID ORDER BY P.CREATEDAT DESC";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    int teamId = rs.getInt("PROJECTTEAMID");
                    String teamName = rs.getString("TEAMNAME");
                    String adminId = rs.getString("ADMIN");
                    String createdAt = rs.getString("CREATEDAT");
        %>
                    <tr>
                        <td><%= teamId %></td>
                        <td><%= teamName %></td>
                        <td><%= adminId %></td>
                        <td><%= createdAt %></td>
                    </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
    <a href="TeamPage.jsp">돌아가기</a>
</body>
</html>
