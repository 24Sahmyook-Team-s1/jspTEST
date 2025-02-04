<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("utf-8");
	
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	
	out.print("Received Name: " + name + "<br>");
	out.print("Received Email: " + email + "<br>");
    
	UserDAO dao = new UserDAO();
    
    try {
        String password = dao.findPassword(name, email);
        
        if (password != null) {
            out.print("PW:" + password);
        } else {
            out.print("NF"); // Not Found
        }
    } catch (Exception e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        out.print("ERROR: " + sw.toString());
    }
%>
