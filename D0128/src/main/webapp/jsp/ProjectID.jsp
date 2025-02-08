<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ProjectDAO" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");
    String userId = request.getParameter("id");

    ProjectDAO projectDAO = new ProjectDAO();
    JSONArray projectList = new JSONArray();

    try {
        // ProjectDAO를 통해 사용자가 속한 프로젝트 목록 조회
        projectList = projectDAO.getProjectsByUserId(userId);
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", "An error occurred while processing your request.");
        out.print(errorResponse.toJSONString());
        e.printStackTrace(); // 로그에 기록
    }

    // JSON 결과 출력
    out.print(projectList.toJSONString());
%>
