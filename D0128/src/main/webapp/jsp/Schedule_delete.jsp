<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="dao.ScheduleDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

    try {
        ScheduleDAO scheduleDAO = new ScheduleDAO();
        scheduleDAO.deleteSchedule(scheduleId);
        out.println("스케줄이 성공적으로 삭제되었습니다.");
    } catch (SQLException | NamingException e) {
        e.printStackTrace();
        out.println("스케줄 삭제 중 오류가 발생했습니다.");
    }
%>
