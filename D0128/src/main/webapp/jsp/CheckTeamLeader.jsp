<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.TeamDAO" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("id");
    TeamDAO teamdao = new TeamDAO();


    out.print("{\"isLeader\": " + teamdao.isTeamLeader(userId) + "}");
%>
