<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Server Error - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>500</h1>
            <p>Internal Server Error</p>
        </div>

        <div class="details-card" style="text-align: center;">
            <h3>Something went wrong on our end.</h3>
            <p>Please try again later or contact the system administrator.</p>
            <div style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/" class="btn-primary">Go to Homepage</a>
                <button onclick="history.back()" class="btn-secondary">Go Back</button>
            </div>
        </div>
    </div>
</body>
</html>