<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.naming.*, org.json.simple.JSONObject, org.json.simple.parser.JSONParser" %>
<%@ page import="dao.UserDAO" %>

<%
    request.setCharacterEncoding("utf-8");
    String userID = request.getParameter("id");

    if (userID != null && !userID.isEmpty()) {
        try {
            UserDAO dao = new UserDAO();
            String userJson = dao.get(userID);
            JSONObject userObj = (JSONObject) new JSONParser().parse(userJson);
            out.print(userObj.toJSONString());
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{}");
        }
    } else {
        out.print("{}");
    }
%>
