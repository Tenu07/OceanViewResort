<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <% User user=(User) session.getAttribute("user"); if (user==null || !"administrator".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login" ); return; } Integer totalRooms=(Integer)
            request.getAttribute("totalRooms"); Long availableRooms=(Long) request.getAttribute("availableRooms"); Long
            occupiedRooms=(Long) request.getAttribute("occupiedRooms"); Integer totalUsers=(Integer)
            request.getAttribute("totalUsers"); if (totalRooms==null) totalRooms=0; if (availableRooms==null)
            availableRooms=0L; if (occupiedRooms==null) occupiedRooms=0L; if (totalUsers==null) totalUsers=0; %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Admin Dashboard - Ocean View Resort</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <div class="dashboard">
                    <div class="sidebar">
                        <div class="sidebar-header">
                            <h3>🌊 Ocean View Resort</h3>
                            <p>Welcome, <%= user.getFullName() !=null ? user.getFullName() : user.getUsername() %>
                            </p>
                            <p><small>Administrator</small></p>
                        </div>
                        <ul class="nav-menu">
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active">📊
                                    Dashboard</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/manage-rooms">🏨 Manage Rooms</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/manage-users">👥 Manage Users</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/reports">📈 Reports</a></li>
                            <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
                        </ul>
                    </div>

                    <div class="main-content">
                        <div class="header">
                            <h2>Administrator Dashboard</h2>
                            <p>
                                <%= new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy").format(new java.util.Date())
                                    %>
                            </p>
                        </div>

                        <div class="stats-cards">
                            <div class="stat-card">
                                <h3>Total Rooms</h3>
                                <p class="stat-number">
                                    <%= totalRooms %>
                                </p>
                                <p>In the resort</p>
                            </div>
                            <div class="stat-card">
                                <h3>Available Rooms</h3>
                                <p class="stat-number">
                                    <%= availableRooms %>
                                </p>
                                <p>Ready to book</p>
                            </div>
                            <div class="stat-card">
                                <h3>Occupied Rooms</h3>
                                <p class="stat-number">
                                    <%= occupiedRooms %>
                                </p>
                                <p>Currently booked</p>
                            </div>
                            <div class="stat-card">
                                <h3>System Users</h3>
                                <p class="stat-number">
                                    <%= totalUsers %>
                                </p>
                                <p>Staff accounts</p>
                            </div>
                        </div>

                        <div class="details-card">
                            <h3>Quick Navigation</h3>
                            <div
                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-top: 15px;">
                                <a href="${pageContext.request.contextPath}/admin/manage-rooms" class="btn-primary"
                                    style="text-align:center; padding:20px; text-decoration:none; border-radius:10px; display:block;">
                                    🏨<br><strong>Manage Rooms</strong>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn-secondary"
                                    style="text-align:center; padding:20px; text-decoration:none; border-radius:10px; display:block;">
                                    👥<br><strong>Manage Users</strong>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/reports" class="btn-success"
                                    style="text-align:center; padding:20px; text-decoration:none; border-radius:10px; display:block;">
                                    📈<br><strong>View Reports</strong>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </body>

            </html>