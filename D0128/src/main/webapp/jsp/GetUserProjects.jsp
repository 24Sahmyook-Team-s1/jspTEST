<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ProjectDAO, org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="javax.naming.NamingException, java.sql.SQLException, java.io.PrintWriter" %>

<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String userID = (String) session.getAttribute("id").toString().trim();
    System.out.print(userID);
    PrintWriter writer = response.getWriter();

    if (userID == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        writer.print("{\"error\": \"로그인이 필요합니다.\"}");
        writer.flush();
        return;
    }

    ProjectDAO projectDAO = new ProjectDAO();
    JSONArray projectList = new JSONArray();

    try {
    	projectList = projectDAO.getProjectsByUserId(userID); // ID 리스트 가져오기
        System.out.println("🔍 프로젝트 조회 결과: " + projectList);


        writer.print(projectList.toJSONString());
    } catch (NamingException | SQLException e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        writer.print("{\"error\": \"프로젝트 목록을 불러오는 중 오류 발생\", \"message\": \"" + e.getMessage() + "\"}");
    } finally {
        writer.flush();
    }
%>
