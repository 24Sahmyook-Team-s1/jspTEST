<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userID = (String) session.getAttribute("id").toString().trim();

    if (userID != null) {
        out.print(userID);
    } else {
        out.print("로그인하지 않았습니다.");
    }
%>
