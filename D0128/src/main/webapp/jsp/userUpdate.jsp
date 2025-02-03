<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="util.FileUtil" %>
<%@ page import="dao.UserDAO" %>
<%
    try {
        request.setCharacterEncoding("utf-8");

        String uid = null, jsonstr = null, ufname = null;
        byte[] ufile = null;

        ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory());
        List<FileItem> items = sfu.parseRequest(request);
        Iterator<FileItem> iter = items.iterator();
        while(iter.hasNext()) {
            FileItem item = iter.next();
            String name = item.getFieldName();
            if(item.isFormField()) {
                String value = item.getString("utf-8");
                if (name.equals("id")) uid = value;
                if (name.equals("jsonstr")) jsonstr = value;
            } else {
                if (name.equals("image")) {
                    ufname = item.getName();
                    ufile = item.get();
                    String root = application.getRealPath(java.io.File.separator);
                    FileUtil.saveImage(root, ufname, ufile);
                }
            }
        }

        // 디버깅 메시지 추가
        out.println("uid: " + uid);
        out.println("jsonstr: " + jsonstr);
        out.println("ufname: " + ufname);

        UserDAO dao = new UserDAO();
        if (dao.update(uid, jsonstr)) {
            out.print("OK");    
        } else {
            out.print("ER");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("ERROR: " + e.getMessage());
    }
%>