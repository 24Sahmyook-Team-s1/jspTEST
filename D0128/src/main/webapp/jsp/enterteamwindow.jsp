<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.UserDAO" %>
<%
    request.setCharacterEncoding("utf-8");
    String userId = request.getParameter("userId");
    String projectId = request.getParameter("projectId");
    System.out.println("enterteamwindow projectId before session set: "+ projectId);
	
    if (userId == null){
    	out.print("ue");
    	return;
    }
    else if(projectId == null){
    	out.print("pe");
    	return;
    }
    else{
    	session.setAttribute("id", userId);
    	session.setAttribute("projectId", projectId);
    	System.out.println("enterteamwindow projectId after session set: "+ projectId);
        out.print("OK");
    }
%>