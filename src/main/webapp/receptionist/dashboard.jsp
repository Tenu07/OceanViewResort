<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Reservation" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"receptionist".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Long availableRooms = (Long) request.getAttribute("availableRooms");
    Long confirmedReservations = (Long) request.getAttribute("confirmedReservations");
    Long todayCheckIns = (Long) request.getAttribute("todayCheckIns");
    Integer totalGuests = (Integer) request.getAttribute("totalGuests");
    List<Reservation> recentReservations = (List<Reservation>) request.getAttribute("recentReservations");
    if (availableRooms == null) availableRooms = 0L;
    if (confirmedReservations == null) confirmedReservations = 0L;
    if (todayCheckIns == null) todayCheckIns = 0L;
    if (totalGuests == null) totalGuests = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Receptionist Dashboard - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>🌊 Ocean View Resort</h3>
                <p>Welcome, <%= user.getFullName() != null ? user.getFullName() : user.getUsername() %></p>
                <p><small>Receptionist</small></p>
            </div>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/receptionist/dashboard" class="active">📊 Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/receptionist/add-reservation">➕ New Reservation</a></li>
                <li><a href="${pageContext.request.contextPath}/receptionist/view-reservation">🔍 View Reservation</a></li>
                <li><a href="${pageContext.request.contextPath}/receptionist/calculate-bill">💰 Calculate Bill</a></li>
                <li><a href="${pageContext.request.contextPath}/receptionist/search">🔎 Search</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h2>Receptionist Dashboard</h2>
                <p><%= new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy").format(new java.util.Date()) %></p>
            </div>

            <!-- Stats -->
            <div class="stats-cards">
                <div class="stat-card">
                    <h3>Available Rooms</h3>
                    <p class="stat-number"><%= availableRooms %></p>
                    <p>Ready to book</p>
                </div>
                <div class="stat-card">
                    <h3>Active Reservations</h3>
                    <p class="stat-number"><%= confirmedReservations %></p>
                    <p>Confirmed bookings</p>
                </div>
                <div class="stat-card">
                    <h3>Today's Check-ins</h3>
                    <p class="stat-number"><%= todayCheckIns %></p>
                    <p>Arriving today</p>
                </div>
                <div class="stat-card">
                    <h3>Total Guests</h3>
                    <p class="stat-number"><%= totalGuests %></p>
                    <p>Registered guests</p>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="details-card">
                <h3>Quick Actions</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-top: 15px;">
                    <a href="${pageContext.request.contextPath}/receptionist/add-reservation" class="btn-primary" style="text-align:center; padding:20px; text-decoration:none; border-radius:10px; display:block;">
                        ➕<br><strong>New Reservation</strong>
                    </a>
                    <a href="${pageContext.request.contextPath}/receptionist/view-reservation" class="btn-secondary" style="text-align:center; padding:20px; text-decoration:none; border-radius:10px; display:block;">
                        🔍<br><strong>View / Update</strong>
                    </a>
                    <a href="${pageContext.request.contextPath}/receptionist/calculate-bill" class="btn-success" style="text-align:center; padding:20px; text-decoration:none; border-radius:10px; display:block;">
                        💰<br><strong>Calculate Bill</strong>
                    </a>
                    <a href="${pageContext.request.contextPath}/receptionist/search" style="background:linear-gradient(135deg,#f093fb,#f5576c); color:white; text-align:center; padding:20px; text-decoration:none; border-radius:10px; display:block;">
                        🔎<br><strong>Search Guests</strong>
                    </a>
                </div>
            </div>

            <!-- Recent Reservations -->
            <% if (recentReservations != null && !recentReservations.isEmpty()) { %>
            <div class="details-card">
                <h3>Recent Reservations</h3>
                <table class="data-table" style="margin-top:15px;">
                    <thead>
                        <tr>
                            <th>Reservation #</th>
                            <th>Guest Name</th>
                            <th>Room</th>
                            <th>Check-in</th>
                            <th>Check-out</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Reservation r : recentReservations) { %>
                        <tr>
                            <td><strong>#<%= r.getReservationNo() %></strong></td>
                            <td><%= r.getGuestName() != null ? r.getGuestName() : "-" %></td>
                            <td><%= r.getRoomNumber() != null ? r.getRoomNumber() : "-" %></td>
                            <td><%= r.getCheckInDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(r.getCheckInDate()) : "-" %></td>
                            <td><%= r.getCheckOutDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(r.getCheckOutDate()) : "-" %></td>
                            <td><span class="status <%= r.getStatus() %>"><%= r.getStatus() %></span></td>
                            <td><a href="${pageContext.request.contextPath}/receptionist/view-reservation?reservationNo=<%= r.getReservationNo() %>" class="btn-small">View</a></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>