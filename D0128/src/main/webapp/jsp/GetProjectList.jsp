<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.ProjectDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%

    request.setCharacterEncoding("UTF-8");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray projectList = new JSONArray();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle11g:1521/XE", "park", "1111");

        System.out.println("🔍 SQL 실행 시작");

        String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt, " +
                     "ScheduleMonday, ScheduleTuesday, ScheduleWednesday, ScheduleThursday, ScheduleFriday " +
                     "FROM Projects ORDER BY CreatedAt DESC, ProjectID ASC";

    // JSON 결과를 저장할 변수
    String jsonResult = "[]";
    ProjectDAO projectDAO = new ProjectDAO();

        while (rs.next()) {
            JSONObject project = new JSONObject();
            project.put("no", rs.getInt("ProjectID"));
            project.put("name", rs.getString("ProjectName"));
            project.put("created_at", rs.getString("CreatedAt"));

            // ✅ Gantt Chart 일정 배열 추가
            JSONArray schedule = new JSONArray();
            schedule.add(rs.getInt("ScheduleMonday"));
            schedule.add(rs.getInt("ScheduleTuesday"));
            schedule.add(rs.getInt("ScheduleWednesday"));
            schedule.add(rs.getInt("ScheduleThursday"));
            schedule.add(rs.getInt("ScheduleFriday"));

            project.put("schedule", schedule);
            projectList.add(project);
        }

    } catch (Exception e) {
        e.printStackTrace();


    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>프로젝트 목록</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>프로젝트 목록</h1>
    <table>
        <thead>
            <tr>
                <th>프로젝트 ID</th>
                <th>프로젝트 이름</th>
                <th>생성일</th>
                <th>프로젝트 리더</th> <!-- 프로젝트 리더 열 추가 -->
            </tr>
        </thead>
        <tbody>
            <%
                // JSON 배열을 파싱하여 HTML 테이블에 표시
                JSONArray projectList = (JSONArray) new JSONParser().parse(jsonResult);
                for (Object obj : projectList) {
                    JSONObject project = (JSONObject) obj;
            %>
            <tr>
                <td><%= project.get("no") %></td>
                <td><%= project.get("name") %></td>
                <td><%= project.get("created_at") %></td>
                <td><%= project.get("projectLeader") %></td> <!-- 프로젝트 리더 데이터 표시 -->
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
