<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%
    session.invalidate();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그아웃 완료</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #E2F9FF;
            font-family: 'Arial', sans-serif;
        }
        .logout-container {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .logout-container p {
            font-size: 20px;
            margin-bottom: 20px;
            color: #333;
        }
        .logout-container button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .logout-container button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <p>로그아웃을 완료하였습니다.</p>
        <a href="../index.html"><button>로그인하기</button></a>
    </div>
</body>
</html>
