<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.*" %>
<%@ page import="dao.*" %>

<%
	String uid = request.getParameter("id");
	out.print((new FriendDAO()).getList(uid));
%>