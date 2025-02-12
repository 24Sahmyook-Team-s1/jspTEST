<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ProjectDAO"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");

    ProjectDAO projectDAO = new ProjectDAO();
    JSONObject jsonResult = new JSONObject();

    try {
        String projectIdStr = request.getParameter("projectId");
        
        // ✅ projectId가 null이거나 빈 값이면 오류 반환
        if (projectIdStr == null || projectIdStr.trim().isEmpty()) {
            jsonResult.put("error", "프로젝트 ID가 제공되지 않았습니다.");
        } else {
            int projectid = Integer.parseInt(projectIdStr.trim());
            System.out.println("📌 프로젝트 ID in jsp: " + projectid);

            // ✅ 프로젝트 정보 가져오기
            JSONObject projectData = projectDAO.getProjectById(projectid);
            
            if (projectData == null) {
                jsonResult.put("error", "프로젝트 데이터를 찾을 수 없습니다.");
            } else {
                jsonResult = projectData; // 프로젝트 데이터 반환
            }
        }
    } catch (NumberFormatException e) {
        jsonResult.put("error", "잘못된 프로젝트 ID 형식입니다.");
    } catch (SQLException | NamingException e) {
        jsonResult.put("error", "서버 데이터베이스 오류: " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        jsonResult.put("error", "알 수 없는 오류 발생: " + e.getMessage());
        e.printStackTrace();
    }

    out.print(jsonResult.toJSONString());
%>
