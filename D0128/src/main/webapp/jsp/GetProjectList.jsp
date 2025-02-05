<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8"); // 응답 타입 명시

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray projectList = new JSONArray();

    try {
        // 최신 오라클 JDBC 드라이버 적용
        Class.forName("oracle.jdbc.OracleDriver"); 
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/XE", "park", "1111");

        System.out.println("🔍 SQL 실행 시작");

        String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt FROM Projects ORDER BY CreatedAt DESC, ProjectID ASC";
        System.out.println("✅ 실행할 SQL: " + sql);

        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        int count = 0;
        while (rs.next()) {
            JSONObject project = new JSONObject();
            project.put("no", rs.getInt("ProjectID"));
            project.put("name", rs.getString("ProjectName"));
            project.put("created_at", rs.getString("CreatedAt"));
            projectList.add(project);
            count++;

            System.out.println("📌 프로젝트 추가됨: " + project.toJSONString());
        }

        System.out.println("✅ 최종 조회된 프로젝트 개수: " + count);
        System.out.println("✅ 최종 JSON 결과: " + projectList.toJSONString());

    } catch (Exception e) {
        e.printStackTrace();

        // 클라이언트에 JSON 형식으로 오류 반환
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", "SQL 실행 오류 발생: " + e.getMessage());
        out.print(errorResponse.toJSONString());

        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }

    out.print(projectList.toJSONString());
%>
