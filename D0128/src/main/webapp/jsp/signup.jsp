<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%
    request.setCharacterEncoding("utf-8");

    String uid = request.getParameter("id");
    String jsonstr = request.getParameter("jsonstr");
    UserDAO dao = new UserDAO();
    
    try {
        if (dao.exists(uid)) {
            out.print("EX");
            return;
        }
        
        if (dao.insert(uid, jsonstr)) {
            session.setAttribute("id", uid);
            out.print("OK");
        } else {
            out.print("ER");
        }
    } catch (Exception e) {
        // 예외 메시지를 문자열로 변환하여 출력
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        out.print("ERROR: " + sw.toString());
    }
%>
