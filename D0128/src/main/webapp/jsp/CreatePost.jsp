<%@ page import="java.io.*, java.sql.*, java.util.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");

    String title = null;
    String content = null;
    String projectId = null;
    String userId = null;
    String imagePath = null;

    // 파일 업로드 처리
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    if (isMultipart) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        try {
            List<FileItem> items = upload.parseRequest(request);
            for (FileItem item : items) {
                if (item.isFormField()) {
                    // 텍스트 데이터 처리
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8");

                    switch (fieldName) {
                        case "title": title = fieldValue; break;
                        case "content": content = fieldValue; break;
                        case "projectId": projectId = fieldValue; break;
                        case "userId": userId = fieldValue; break;
                    }
                } else {
                    // 파일 처리
                    String fileName = UUID.randomUUID().toString() + "_" + new File(item.getName()).getName();
                    String uploadDir = application.getRealPath("/uploads");
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) uploadDirFile.mkdirs();

                    imagePath = "uploads/" + fileName;
                    File uploadedFile = new File(uploadDir, fileName);
                    item.write(uploadedFile);
                }
            }
        } catch (Exception e) {
            out.print("{\"status\":\"fail\", \"message\":\"파일 업로드 오류: " + e.getMessage() + "\"}");
            return;
        }
    }

    // 디버깅: 값 확인
    System.out.println("Title: " + title);
    System.out.println("Content: " + content);
    System.out.println("Project ID: " + projectId);
    System.out.println("User ID: " + userId);

    if (title == null || content == null || projectId == null || userId == null) {
        out.print("{\"status\":\"fail\", \"message\":\"모든 필드를 입력하세요.\"}");
        return;
    }

    // 데이터베이스에 저장
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@15.164.30.107:1521:xe", "park", "1111");

        String sql = "INSERT INTO PROJECTBOARD (PROJECTID, USERID, TITLE, CONTENT, FILEPATH, CREATED_AT) VALUES (?, ?, ?, ?, ?, SYSDATE)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, projectId);
        pstmt.setString(2, userId);
        pstmt.setString(3, title);
        pstmt.setString(4, content);
        pstmt.setString(5, imagePath);

        int result = pstmt.executeUpdate();
        if (result > 0) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"fail\", \"message\":\"데이터베이스 저장 실패.\"}");
        }
    } catch (Exception e) {
        out.print("{\"status\":\"fail\", \"message\":\"" + e.getMessage() + "\"}");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>