<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>

<%
    Integer projectID = (Integer) session.getAttribute("projectID");
    String userID = request.getParameter("userID");

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