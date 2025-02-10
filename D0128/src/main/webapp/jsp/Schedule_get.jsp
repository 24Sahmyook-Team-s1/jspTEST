<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="dao.ScheduleDAO" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    JSONArray schedules = new JSONArray();

    try {
        ScheduleDAO scheduleDAO = new ScheduleDAO();
        schedules = scheduleDAO.getAllSchedules();
    } catch (SQLException | NamingException e) {
        e.printStackTrace();
    }

    // JSON 배열을 클라이언트에 출력
    out.print(schedules.toJSONString());
%>
