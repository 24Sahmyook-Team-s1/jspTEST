<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>

<%
    String userId = request.getParameter("userId");
    String projectId = request.getParameter("projectId");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONObject projectDetails = new JSONObject();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

        // USER2 테이블 조인하여 관리자 이름 및 이메일 가져오기
        String sql = "SELECT P.PROJECTNAME, U.JSONSTR AS OWNERINFO " +
                     "FROM PROJECTS P " +
                     "JOIN USER2 U ON P.ADMINUSERID = U.USERID " +
                     "WHERE P.PROJECTID = ? AND P.ADMINUSERID = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, projectId);
        pstmt.setString(2, userId);

        rs = pstmt.executeQuery();

        if (rs != null && rs.next()) {
            projectDetails.put("projectName", rs.getString("PROJECTNAME"));

            // JSONSTR에서 이름과 이메일(id) 추출
            String ownerInfo = rs.getString("OWNERINFO");
            if (ownerInfo != null && !ownerInfo.isEmpty()) {
                org.json.simple.parser.JSONParser parser = new org.json.simple.parser.JSONParser();
                org.json.simple.JSONObject ownerJson = (org.json.simple.JSONObject) parser.parse(ownerInfo);

                projectDetails.put("ownerName", ownerJson.get("name") != null ? ownerJson.get("name") : "알 수 없음");
                projectDetails.put("ownerEmail", ownerJson.get("id") != null ? ownerJson.get("id") : "알 수 없음");  // id로 이메일 불러오기
            } else {
                projectDetails.put("ownerName", "알 수 없음");
                projectDetails.put("ownerEmail", "알 수 없음");
            }

            // 설명 컬럼이 없으므로 기본 값 설정
            projectDetails.put("description", "프로젝트 설명 없음");
        } else {
            projectDetails.put("status", "fail");
            projectDetails.put("message", "해당 프로젝트 정보를 찾을 수 없습니다. projectId: " + projectId + ", userId: " + userId);
        }


        out.print(projectDetails.toJSONString());

    } catch (Exception e) {
        out.print("{\"status\":\"fail\", \"message\":\"" + e.getMessage() + "\"}");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
