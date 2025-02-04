<%@ page contentType="text/plain; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%
    request.setCharacterEncoding("utf-8");

    // 디버깅용 출력 제거: 이제 오직 결과만 출력됩니다.
    String name = request.getParameter("name");
    String email = request.getParameter("email");

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
