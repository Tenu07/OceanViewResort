<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = request.getParameter("role");
    if (role == null) {
        role = (String) request.getAttribute("selectedRole");
    }
    if (role == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String roleDisplay = "";
    String roleIcon = "";
    String dbRole = ""; // This will be sent to the servlet

    switch(role.toLowerCase()) {
        case "receptionist":
            roleDisplay = "Receptionist";
            roleIcon = "👨‍💼";
            dbRole = "receptionist";
            break;
        case "admin":
        case "administrator":
            roleDisplay = "Administrator";
            roleIcon = "👑";
            dbRole = "admin";
            break;
        case "accountant":
            roleDisplay = "Accountant";
            roleIcon = "💰";
            dbRole = "accountant";
            break;
        default:
            response.sendRedirect("index.jsp");
            return;
    }

    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= roleDisplay %> Login - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
        }

        .login-box {
            background: white;
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            animation: slideInUp 0.5s ease;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header .icon {
            font-size: 4rem;
            margin-bottom: 10px;
        }

        .login-header h2 {
            color: #333;
            margin-bottom: 5px;
        }

        .login-header p {
            color: #666;
            font-size: 1.1rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
        }

        .error-message {
            background: #fed7d7;
            color: #742a2a;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #f56565;
            animation: shake 0.5s ease;
        }

        .demo-credentials {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            font-size: 0.9rem;
        }

        .demo-credentials h4 {
            color: #333;
            margin-bottom: 10px;
        }

        .demo-credentials p {
            margin: 5px 0;
            color: #666;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #667eea;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        @keyframes slideInUp {
            from {
                transform: translateY(30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }

        .role-badge {
            display: inline-block;
            padding: 5px 15px;
            background: #667eea;
            color: white;
            border-radius: 50px;
            font-size: 0.9rem;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="login-header">
                <div class="icon"><%= roleIcon %></div>
                <h2>Ocean View Resort</h2>
                <p><%= roleDisplay %> Login</p>
                <span class="role-badge"><%= roleDisplay %></span>
            </div>

            <% if (error != null) { %>
                <div class="error-message">
                    <%= error %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="role" value="<%= dbRole %>">

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username"
                           placeholder="Enter your username" required
                           value="<%= dbRole.equals("receptionist") ? "receptionist1" :
                                   dbRole.equals("admin") ? "admin" :
                                   dbRole.equals("accountant") ? "accountant1" : "" %>">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password"
                           placeholder="Enter your password" required
                           value="<%= dbRole.equals("receptionist") ? "rec123" :
                                   dbRole.equals("admin") ? "admin123" :
                                   dbRole.equals("accountant") ? "acc123" : "" %>">
                </div>

                <button type="submit" class="btn-login">Login as <%= roleDisplay %></button>
            </form>

            <div class="demo-credentials">
                <h4>Demo Credentials:</h4>
                <% if ("receptionist".equals(dbRole)) { %>
                    <p><strong>Username:</strong> receptionist1</p>
                    <p><strong>Password:</strong> rec123</p>
                <% } else if ("admin".equals(dbRole)) { %>
                    <p><strong>Username:</strong> admin</p>
                    <p><strong>Password:</strong> admin123</p>
                <% } else if ("accountant".equals(dbRole)) { %>
                    <p><strong>Username:</strong> accountant1</p>
                    <p><strong>Password:</strong> acc123</p>
                <% } %>
            </div>

            <a href="${pageContext.request.contextPath}/index.jsp" class="back-link">← Back to Role Selection</a>
        </div>
    </div>
</body>
</html>