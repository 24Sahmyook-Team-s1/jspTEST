<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.UserDAO" %>
<%
    request.setCharacterEncoding("utf-8");
    String uid = request.getParameter("id");
    String upass = request.getParameter("ps");

    UserDAO dao = new UserDAO();
    int code = dao.login(uid, upass);

    if (code == 1) {
        out.print("NE"); // 아이디가 존재하지 않음
    } else if (code == 2) {
        out.print("PE"); // 패스워드 불일치
    } else if (code == 0) {
        session.setAttribute("id", uid);
        out.print("OK");
    } else {
        out.print("ERROR"); // DB 오류 발생
    }
%>
