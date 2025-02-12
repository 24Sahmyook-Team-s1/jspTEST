<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    String projectIDStr = (String) session.getAttribute("projectId");
    String userID = request.getParameter("userID");

    JSONObject jsonResponse = new JSONObject();

    if (projectIDStr == null || userID == null || userID.trim().isEmpty()) {
        jsonResponse.put("status", "fail");
        jsonResponse.put("message", "프로젝트 ID 또는 사용자 ID가 올바르지 않습니다.");
    } else {
        try {
            int projectID = Integer.parseInt(projectIDStr);

            TeamDAO inviteDAO = new TeamDAO();
            boolean isInserted = inviteDAO.addTeamMember(projectID, userID);

            if (isInserted) {
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "팀원 추가에 성공하였습니다.");
            } else {
                jsonResponse.put("status", "exists");
                jsonResponse.put("message", "이미 팀원으로 등록된 사용자입니다.");
            }

            // ✅ 팀원 목록을 반환 (추가 성공/실패 상관없이)
            JSONArray teamMembers = inviteDAO.getTeamMembers(projectID);
            jsonResponse.put("teamMembers", teamMembers);

        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "서버 오류 발생: " + e.getMessage());
        }
    }

    out.print(jsonResponse.toJSONString());
%>
