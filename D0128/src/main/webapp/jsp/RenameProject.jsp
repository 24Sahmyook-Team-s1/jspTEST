<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    String projectId = request.getParameter("projectId");
    String newName = request.getParameter("newName");

    JSONObject result = new JSONObject();

    if (projectId != null && newName != null && !newName.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

            String sql = "UPDATE PROJECTS SET PROJECTNAME = ? WHERE PROJECTID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newName);
            pstmt.setInt(2, Integer.parseInt(projectId));

            int rowsUpdated = pstmt.executeUpdate();

            if (rowsUpdated > 0) {
                result.put("status", "success");
                result.put("message", "프로젝트 이름이 성공적으로 변경되었습니다.");
            } else {
                result.put("status", "fail");
                result.put("message", "프로젝트를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            result.put("status", "error");
            result.put("message", "DB 오류: " + e.getMessage());
            System.out.println("DB 오류 발생: " + e.getMessage());  // 디버깅 로그
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

    } else {
        result.put("status", "fail");
        result.put("message", "잘못된 요청: 프로젝트 ID 또는 새 이름이 없습니다.");
    }

    response.setContentType("application/json;charset=UTF-8");
    out.print(result.toJSONString());
    
    System.out.println("🔍 전달된 projectId: " + projectId);
    System.out.println("🔍 전달된 newName: " + newName);

%>
