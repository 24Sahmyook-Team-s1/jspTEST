<%@ page import="java.sql.*, java.io.*, javax.servlet.http.Part, org.json.simple.JSONObject" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");

    String projectId = request.getParameter("projectId");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    Part filePart = request.getPart("file");
    String filePath = null;

    if (filePart != null && filePart.getSize() > 0) {
        String fileName = new File(filePart.getSubmittedFileName()).getName();
        String uploadPath = application.getRealPath("") + "uploads" + File.separator + fileName;
        filePart.write(uploadPath);
        filePath = "uploads/" + fileName;
    }

    JSONObject result = new JSONObject();

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

        String sql = "INSERT INTO PROJECTBOARD (PROJECTID, TITLE, CONTENT, FILEPATH, CREATED_AT) VALUES (?, ?, ?, ?, SYSDATE)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, projectId);
        pstmt.setString(2, title);
        pstmt.setString(3, content);
        pstmt.setString(4, filePath);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            result.put("status", "success");
        } else {
            result.put("status", "fail");
            result.put("message", "DB에 글 저장 실패");
        }
    } catch (Exception e) {
        result.put("status", "error");
        result.put("message", e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print(result.toJSONString());
%>
