<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    String projectIdStr = request.getParameter("projectId");
    JSONObject jsonResponse = new JSONObject();

    if (projectIdStr == null || projectIdStr.trim().isEmpty()) {
        jsonResponse.put("status", "fail");
        jsonResponse.put("message", "프로젝트 ID가 유효하지 않습니다.");
    } else {
        try {
            int projectId = Integer.parseInt(projectIdStr);
            ProjectDAO dao = new ProjectDAO();
            boolean isDeleted = dao.removeProjectById(projectId);

            if (isDeleted) {
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "프로젝트가 성공적으로 삭제되었습니다.");
            } else {
                jsonResponse.put("status", "fail");
                jsonResponse.put("message", "프로젝트 삭제에 실패했습니다.");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "프로젝트 ID 형식이 잘못되었습니다.");
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "서버 오류 발생: " + e.getMessage());
        }
    }

    out.print(jsonResponse.toJSONString());
%>