<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONObject, org.json.simple.parser.JSONParser" %>

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

        // 1️⃣ 관리자 및 팀원 모두 확인하는 쿼리
        String sql = "SELECT P.PROJECTNAME, U.JSONSTR AS OWNERINFO, " +
                     "CASE WHEN P.ADMINUSERID = ? THEN 'admin' " +
                     "     WHEN EXISTS (SELECT 1 FROM TEAMMEMBERS TM WHERE TM.PROJECTID = P.PROJECTID AND TM.USERID = ?) THEN 'member' " +
                     "     ELSE 'none' END AS ROLE " +
                     "FROM PROJECTS P " +
                     "JOIN USER2 U ON P.ADMINUSERID = U.USERID " +
                     "WHERE P.PROJECTID = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);      // 관리자 확인
        pstmt.setString(2, userId);      // 팀원 확인
        pstmt.setString(3, projectId);   // 프로젝트 ID

        rs = pstmt.executeQuery();

        if (rs != null && rs.next()) {
            String role = rs.getString("ROLE");

            // 2️⃣ 관리자인 경우 또는 팀원인 경우만 정보를 반환
            if ("admin".equals(role) || "member".equals(role)) {
                projectDetails.put("status", "success");
                projectDetails.put("role", role);
                projectDetails.put("projectName", rs.getString("PROJECTNAME"));

                // 3️⃣ JSONSTR에서 이름과 이메일 추출
                String ownerInfo = rs.getString("OWNERINFO");
                if (ownerInfo != null && !ownerInfo.isEmpty()) {
                    JSONParser parser = new JSONParser();
                    JSONObject ownerJson = (JSONObject) parser.parse(ownerInfo);

                    projectDetails.put("ownerName", ownerJson.get("name") != null ? ownerJson.get("name") : "알 수 없음");
                    projectDetails.put("ownerEmail", ownerJson.get("id") != null ? ownerJson.get("id") : "알 수 없음");
                } else {
                    projectDetails.put("ownerName", "알 수 없음");
                    projectDetails.put("ownerEmail", "알 수 없음");
                }

                // 4️⃣ 설명 컬럼이 없는 경우 기본 값 설정
                projectDetails.put("description", "프로젝트 설명 없음");
            } else {
                // 관리자가 아니고 팀원도 아닌 경우 접근 제한
                projectDetails.put("status", "fail");
                projectDetails.put("message", "해당 프로젝트에 접근 권한이 없습니다.");
            }
        } else {
            // 프로젝트가 존재하지 않을 경우
            projectDetails.put("status", "fail");
            projectDetails.put("message", "해당 프로젝트 정보를 찾을 수 없습니다. projectId: " + projectId + ", userId: " + userId);
        }

        out.print(projectDetails.toJSONString());

    } catch (Exception e) {
        projectDetails.put("status", "error");
        projectDetails.put("message", "서버 오류 발생: " + e.getMessage());
        out.print(projectDetails.toJSONString());
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
