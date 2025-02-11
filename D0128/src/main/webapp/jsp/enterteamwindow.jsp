<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userId = request.getParameter("userId");
    String projectId = request.getParameter("projectId");

    if (userId != null && projectId != null) {
        session.setAttribute("id", userId);
        session.setAttribute("projectId", projectId);
        out.print("OK");
    } else {
        out.print("error");
    }
%>
