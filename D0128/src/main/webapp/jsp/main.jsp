<%@ page contentType="application/json" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%
    // 로그인한 사용자 ID 가져오기
    String uid = (String) session.getAttribute("id");
    if (uid == null) {
        response.sendRedirect("login.html");
        return;
    }

    // 데이터 가져오기
    String str = (new FeedDAO()).getList();

    // JSON 응답 설정
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    out.print(str);
    
    try {
        String ar = (new FeedDAO()).getList();
        out.print(ar);
    } catch (Exception e) {
        e.printStackTrace(); // 서버 콘솔에서 확인 가능
        out.print("오류 발생: " + e.getMessage());
    }
%>
