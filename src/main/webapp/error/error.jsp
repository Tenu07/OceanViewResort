<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Error</h1>
            <p>An unexpected error occurred</p>
        </div>

        <div class="details-card" style="text-align: center;">
            <h3>Error Details:</h3>
            <p class="error-message">
                <%= exception != null ? exception.getMessage() : "Unknown error" %>
            </p>
            <div style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/" class="btn-primary">Go to Homepage</a>
                <button onclick="history.back()" class="btn-secondary">Go Back</button>
            </div>
        </div>
    </div>
</body>
</html>