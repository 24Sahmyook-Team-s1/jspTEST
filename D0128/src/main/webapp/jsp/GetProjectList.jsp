<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray projectList = new JSONArray();

    try {
        // DB 연결
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@YOUR_DB_HOST:1521:XE", "YOUR_DB_USER", "YOUR_DB_PASSWORD");

        // Projects 테이블에서 모든 프로젝트 정보 가져오기
        String sql = "SELECT ProjectID, ProjectName, CreatedAt FROM Projects";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject project = new JSONObject();
            project.put("no", rs.getInt("ProjectID"));  
            project.put("name", rs.getString("ProjectName"));
            project.put("created_at", rs.getDate("CreatedAt").toString());
            projectList.add(project);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    // JSON 데이터 반환
    out.print(projectList.toJSONString());
%>
