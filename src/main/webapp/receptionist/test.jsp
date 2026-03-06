<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Receptionist Test Page</title>
</head>
<body>
    <h1 style="color: green;">✅ Receptionist folder is accessible!</h1>
    <p>Current time: <%= new java.util.Date() %></p>
    <p>Context Path: <%= request.getContextPath() %></p>
    <p>Request URI: <%= request.getRequestURI() %></p>

    <h2>Test Links:</h2>
    <ul>
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard">Go to Receptionist Dashboard (Servlet)</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard.jsp">Go to Receptionist Dashboard (Direct JSP)</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/accountant/dashboard">Accountant Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
    </ul>
</body>
</html>