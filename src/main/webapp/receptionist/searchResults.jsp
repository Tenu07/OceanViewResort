<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Reservation" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.text.SimpleDateFormat" %>
                    <% User user=(User) session.getAttribute("user"); if (user==null ||
                        !"receptionist".equals(user.getRole())) { response.sendRedirect(request.getContextPath()
                        + "/login" ); return; } List<Reservation> reservations = (List<Reservation>)
                            request.getAttribute("reservations");
                            String searchTerm = (String) request.getAttribute("searchTerm");
                            String error = (String) request.getAttribute("error");
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            %>
                            <!DOCTYPE html>
                            <html>

                            <head>
                                <meta charset="UTF-8">
                                <title>Search Results - Ocean View Resort</title>
                                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                            </head>

                            <body>
                                <div class="dashboard">
                                    <div class="sidebar">
                                        <div class="sidebar-header">
                                            <h3>🌊 Ocean View Resort</h3>
                                            <p>Welcome, <%= user.getFullName() !=null ? user.getFullName() :
                                                    user.getUsername() %>
                                            </p>
                                            <p><small>Receptionist</small></p>
                                        </div>
                                        <ul class="nav-menu">
                                            <li><a href="${pageContext.request.contextPath}/receptionist/dashboard">📊
                                                    Dashboard</a></li>
                                            <li><a
                                                    href="${pageContext.request.contextPath}/receptionist/add-reservation">➕
                                                    New Reservation</a></li>
                                            <li><a
                                                    href="${pageContext.request.contextPath}/receptionist/view-reservation">🔍
                                                    View Reservation</a></li>
                                            <li><a
                                                    href="${pageContext.request.contextPath}/receptionist/calculate-bill">💰
                                                    Calculate Bill</a></li>
                                            <li><a href="${pageContext.request.contextPath}/receptionist/search"
                                                    class="active">🔎 Search</a></li>
                                            <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
                                        </ul>
                                    </div>

                                    <div class="main-content">
                                        <div class="header">
                                            <h2>Search Reservations</h2>
                                        </div>

                                        <% if (error !=null) { %>
                                            <div class="error-message">
                                                <%= error %>
                                            </div>
                                            <% } %>

                                                <!-- Search Form -->
                                                <div class="details-card">
                                                    <form
                                                        action="${pageContext.request.contextPath}/receptionist/search"
                                                        method="get">
                                                        <div class="form-row">
                                                            <div class="form-group" style="flex:3;">
                                                                <label for="searchTerm">Search by Guest Name or
                                                                    Reservation Number:</label>
                                                                <input type="text" id="searchTerm" name="searchTerm"
                                                                    value="<%= searchTerm != null ? searchTerm : "" %>"
                                                                    placeholder="Enter guest name or reservation number..."
                                                                    style="width:100%;">
                                                            </div>
                                                            <div class="form-group"
                                                                style="flex:1; align-self:flex-end;">
                                                                <button type="submit" class="btn-primary"
                                                                    style="width:100%;">🔎 Search</button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>

                                                <!-- Results -->
                                                <% if (searchTerm !=null && !searchTerm.isEmpty()) { %>
                                                    <div class="details-card">
                                                        <h3>
                                                            Search Results for "<%= searchTerm %>"
                                                                <% if (reservations !=null) { %> — <%=
                                                                        reservations.size() %> result(s)<% } %>
                                                        </h3>

                                                        <table class="data-table" style="margin-top:15px;">
                                                            <thead>
                                                                <tr>
                                                                    <th>Res #</th>
                                                                    <th>Guest Name</th>
                                                                    <th>Room</th>
                                                                    <th>Check-in</th>
                                                                    <th>Check-out</th>
                                                                    <th>Guests</th>
                                                                    <th>Status</th>
                                                                    <th>Actions</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% if (reservations !=null && !reservations.isEmpty()) {
                                                                    for (Reservation r : reservations) { %>
                                                                    <tr>
                                                                        <td><strong>#<%= r.getReservationNo() %>
                                                                                    </strong></td>
                                                                        <td>
                                                                            <%= r.getGuestName() !=null ?
                                                                                r.getGuestName() : "-" %>
                                                                        </td>
                                                                        <td>
                                                                            <%= r.getRoomNumber() !=null ?
                                                                                r.getRoomNumber() : "-" %>
                                                                        </td>
                                                                        <td>
                                                                            <%= r.getCheckInDate() !=null ?
                                                                                sdf.format(r.getCheckInDate()) : "-" %>
                                                                        </td>
                                                                        <td>
                                                                            <%= r.getCheckOutDate() !=null ?
                                                                                sdf.format(r.getCheckOutDate()) : "-" %>
                                                                        </td>
                                                                        <td>
                                                                            <%= r.getNumGuests() %>
                                                                        </td>
                                                                        <td><span class="status <%= r.getStatus() %>">
                                                                                <%= r.getStatus() %>
                                                                            </span></td>
                                                                        <td>
                                                                            <a href="${pageContext.request.contextPath}/receptionist/view-reservation?reservationNo=<%= r.getReservationNo() %>"
                                                                                class="btn-small">View</a>
                                                                            <% if (!"cancelled".equals(r.getStatus()) &&
                                                                                !"completed".equals(r.getStatus())) { %>
                                                                                <a href="${pageContext.request.contextPath}/receptionist/calculate-bill?reservationNo=<%= r.getReservationNo() %>"
                                                                                    class="btn-small">Bill</a>
                                                                                <% } %>
                                                                        </td>
                                                                    </tr>
                                                                    <% } } else { %>
                                                                        <tr>
                                                                            <td colspan="8" class="text-center">No
                                                                                reservations found matching "<%=
                                                                                    searchTerm %>".</td>
                                                                        </tr>
                                                                        <% } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <% } else { %>
                                                        <div class="details-card"
                                                            style="text-align:center; color:#666; padding:40px;">
                                                            <p>🔎 Enter a search term above to find reservations.</p>
                                                        </div>
                                                        <% } %>
                                    </div>
                                </div>
                            </body>

                            </html>