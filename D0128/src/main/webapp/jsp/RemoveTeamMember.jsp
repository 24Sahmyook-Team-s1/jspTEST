<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="dao.TeamDAO, org.json.simple.JSONObject" %>

<%
    String userId = request.getParameter("userId");
    String projectId = request.getParameter("projectId");

    JSONObject result = new JSONObject();

    try {
        TeamDAO dao = new TeamDAO();
        boolean isRemoved = dao.removeTeamMember(Integer.parseInt(projectId), userId);

        if (isRemoved) {
            result.put("status", "success");
            result.put("message", "팀원이 성공적으로 제거되었습니다.");
        } else {
            result.put("status", "fail");
            result.put("message", "팀원 제거 실패 또는 존재하지 않는 팀원입니다.");
        }
    } catch (Exception e) {
        result.put("status", "fail");
        result.put("message", "팀원 제거 중 오류 발생: " + e.getMessage());
    }

    out.print(result.toJSONString());
%>
