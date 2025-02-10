<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="dao.ProjectDAO" %>

<%

    request.setCharacterEncoding("UTF-8");
    String uid = (String) session.getAttribute("id");
	ProjectDAO projectdao = new ProjectDAO();
    JSONArray projectList = new JSONArray();

    try {
        JSONArray projectIds = projectdao.getProjectIdsByUserId(uid);
        for (int i = 0; i < projectIds.size(); i++) {
            JSONObject project = (JSONObject) projectIds.get(i);
            projectList.add(project);
        }
    } catch (Exception e) {
        out.print("{\"error\": \"프로젝트 목록을 가져오는 중 오류가 발생했습니다.\"}");
        e.printStackTrace(); // 로그에 오류 출력
        return; // JSP 처리 중단
    }


    
    out.print(projectList.toJSONString());
%>
