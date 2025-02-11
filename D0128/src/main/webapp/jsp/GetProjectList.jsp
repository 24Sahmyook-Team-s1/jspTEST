<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="dao.ProjectDAO" %>

<%
    response.setContentType("application/json;charset=UTF-8");
    ProjectDAO projectDAO = new ProjectDAO();
    JSONArray projects = null;

    try {
        projects = projectDAO.getAllProjects();
        out.print(projects.toJSONString());
    } catch (Exception e) {
        e.printStackTrace();  // 서버 로그에 에러 출력
        response.setStatus(500);  // 클라이언트에 500 오류 코드 반환
        out.print("{\"error\":\"프로젝트 목록을 불러오는 중 오류가 발생했습니다.\"}");
    }
%>
