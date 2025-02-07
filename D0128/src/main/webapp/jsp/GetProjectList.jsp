<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="util.ConnectionPool" %>
<%

    request.setCharacterEncoding("UTF-8");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray projectList = new JSONArray();

    try {
        // 커넥션 풀에서 연결 가져오기
        conn = ConnectionPool.get();
        
        // SQL 쿼리 작성
        String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt " +
                     "FROM Projects ORDER BY CreatedAt DESC, ProjectID ASC";

        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        // 결과를 JSON 배열에 추가
        while (rs.next()) {
            JSONObject project = new JSONObject();
            project.put("no", rs.getInt("ProjectID"));
            project.put("name", rs.getString("ProjectName"));
            project.put("created_at", rs.getString("CreatedAt"));
            projectList.add(project);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 자원 해제
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>프로젝트 목록</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>프로젝트 목록</h1>
    <table>
        <thead>
            <tr>
                <th>프로젝트 ID</th>
                <th>프로젝트 이름</th>
                <th>생성일</th>
            </tr>
        </thead>
        <tbody>
            <%
                // JSON 배열을 HTML 테이블에 표시
                for (Object obj : projectList) {
                    JSONObject project = (JSONObject) obj;
            %>
            <tr>
                <td><%= project.get("no") %></td>
                <td><%= project.get("name") %></td>
                <td><%= project.get("created_at") %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
