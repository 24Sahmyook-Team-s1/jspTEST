<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>

<%
    String projectIDParam= request.getParameter("projectID");
    String userID = request.getParameter("userID");

    Integer projectID = null;
    if (projectIDParam != null && !projectIDParam.isEmpty()) {
        try {
            projectID = Integer.parseInt(projectIDParam);
        } catch (NumberFormatException e) {
            projectID = null;
        }
    }

    if (userID != null && projectID != null) {
        TeamDAO invitation = new TeamDAO();
        boolean isInserted = invitation.inviteTeamMember(projectID, userID);

        if (isInserted) {
%>
            <script>alert("초대에 성공하였습니다다");</script>
<%
        } else {
%>
            <script>alert("초대에 실패하였습니다..");</script>
<%
        }
    }
%>