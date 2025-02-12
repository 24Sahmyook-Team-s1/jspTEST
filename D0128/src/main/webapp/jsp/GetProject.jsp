<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%
    request.setCharacterEncoding("utf-8");
    ProjectDAO projectDAO = new ProjectDAO();
    JSONObject jsonResult = new JSONObject(); // JSONObject로 초기화

    if (request.getMethod().equalsIgnoreCase("POST")) {
        int projectid = Integer.parseInt(request.getParameter("projectId").trim());
        System.out.println("projectId in jsp: "+ projectid);

        try {
            // 프로젝트 정보를 JSON 형식으로 가져오기
            jsonResult = projectDAO.getProjectById(projectid);
        } catch (Exception e) {
            e.printStackTrace();
            jsonResult.put("error", e.getMessage()); // 에러 정보를 JSONObject에 추가
        }
        
        out.print(jsonResult.toJSONString()); // JSON 결과 출력
    }
%>

