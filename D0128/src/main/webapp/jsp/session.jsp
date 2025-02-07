<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userID = (String) session.getAttribute("id");

    if (userID != null) {
        out.print("현재 로그인한 사용자 ID: " + userID);
    } else {
        out.print("로그인하지 않았습니다.");
    }
%>
