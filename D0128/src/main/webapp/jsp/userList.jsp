<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import= "util.*" %>
<%
	out.print((new UserDAO()).getList());
%>