<%@ page contentType="application/json;charset=UTF-8" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
    String uid = (String) session.getAttribute("id");
    JSONObject userInfo = new JSONObject();

    if (uid != null) {
        UserDAO dao = new UserDAO();
        String jsonstr = dao.get(uid);
        JSONObject userJson = (JSONObject) new org.json.simple.parser.JSONParser().parse(jsonstr);
        
        userInfo.put("name", userJson.get("name"));
        userInfo.put("email", userJson.get("id")); // 이메일은 'id'에 저장됨
    } else {
        userInfo.put("error", "로그인되지 않았습니다.");
    }

    out.print(userInfo.toJSONString());
%>
