<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>

<%
    String projectID = request.getParameter("projectID");
    String userID = request.getParameter("userID");
    
    if (projectID != null) {
        System.out.println("User from session: " + projectID + " " + userID);
    } else {
        System.out.println("No user in session.");
    }
    
    if (userID != null && projectID != null) {
        TeamDAO inviteDAO = new TeamDAO();
        boolean isInserted = inviteDAO.inviteTeamMember(projectID, userID);
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