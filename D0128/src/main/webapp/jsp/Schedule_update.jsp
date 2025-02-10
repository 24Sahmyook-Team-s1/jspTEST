<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="dao.ScheduleDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
    String taskName = request.getParameter("task_name");
    Date startDate = Date.valueOf(request.getParameter("start_date"));
    Date endDate = Date.valueOf(request.getParameter("end_date"));

    try {
        ScheduleDAO scheduleDAO = new ScheduleDAO();
        scheduleDAO.updateSchedule(scheduleId, taskName, startDate, endDate);
        out.println("스케줄이 성공적으로 업데이트되었습니다.");
    } catch (SQLException | NamingException e) {
        e.printStackTrace();
        out.println("스케줄 업데이트 중 오류가 발생했습니다.");
    }
%>
