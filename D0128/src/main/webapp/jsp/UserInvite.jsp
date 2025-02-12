<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    // 세션 대신 요청 파라미터에서 값 가져오기
    String projectID = request.getParameter("projectID");
    String userID = request.getParameter("userID");

    // 디버깅 로그
    System.out.println("DEBUG - projectID from request: " + projectID);
    System.out.println("DEBUG - userID from request: " + userID);

    JSONObject jsonResponse = new JSONObject();

    if (projectID == null || userID == null || userID.trim().isEmpty()) {
        jsonResponse.put("status", "fail");
        jsonResponse.put("message", "프로젝트 ID 또는 사용자 ID가 올바르지 않습니다.");
    } else {
        try {
            TeamDAO inviteDAO = new TeamDAO();
            boolean isInserted = inviteDAO.inviteTeamMember(projectID, userID);

            if (isInserted) {
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "초대에 성공하였습니다.");
            } else {
                jsonResponse.put("status", "fail");
                jsonResponse.put("message", "이미 초대된 사용자거나, 초대할 수 없는 사용자입니다.");
            }
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "서버 오류 발생: " + e.getMessage());
        }
    }

    out.print(jsonResponse.toJSONString());
%>
