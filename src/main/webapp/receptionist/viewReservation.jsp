<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Reservation" %>
            <%@ page import="com.oceanview.model.Bill" %>
                <%@ page import="java.text.SimpleDateFormat" %>
                    <% User user=(User) session.getAttribute("user"); if (user==null ||
                        !"receptionist".equals(user.getRole())) { response.sendRedirect(request.getContextPath()
                        + "/login" ); return; } Reservation reservation=(Reservation)
                        request.getAttribute("reservation"); Bill bill=(Bill) request.getAttribute("bill"); String
                        error=(String) request.getAttribute("error"); String success=(String)
                        request.getAttribute("success"); SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd"); %>
                        <!DOCTYPE html>
                        <html>

                        <head>
                            <meta charset="UTF-8">
                            <title>View Reservation - Ocean View Resort</title>
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                        </head>

                        <body>
                            <div class="dashboard">
                                <!-- Sidebar -->
                                <div class="sidebar">
                                    <div class="sidebar-header">
                                        <h3>🌊 Ocean View</h3>
                                        <p>Welcome, <%= user.getFullName() !=null ? user.getFullName() :
                                                user.getUsername() %>
                                        </p>
                                    </div>
                                    <ul class="nav-menu">
                                        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard">📊
                                                Dashboard</a></li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/add-reservation">➕
                                                New Reservation</a></li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/view-reservation"
                                                class="active">🔍 View Reservation</a></li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/calculate-bill">💰
                                                Calculate Bill</a></li>
                                        <li><a href="#" onclick="showHelp()">❓ Help</a></li>
                                        <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
                                    </ul>
                                </div>

                                <!-- Main Content -->
                                <div class="main-content">
                                    <div class="header">
                                        <h2>View Reservation Details</h2>
                                    </div>

                                    <% if (error !=null) { %>
                                        <div class="error-message">
                                            <%= error %>
                                        </div>
                                        <% } %>

                                            <% if (success !=null) { %>
                                                <div class="success-message">
                                                    <%= success %>
                                                </div>
                                                <% } %>

                                                    <!-- Search Box -->
                                                    <div class="search-box">
                                                        <form
                                                            action="${pageContext.request.contextPath}/receptionist/view-reservation"
                                                            method="get">
                                                            <div class="form-row">
                                                                <% String rNo=request.getParameter("reservationNo");
                                                                    rNo=rNo !=null ? rNo : "" ; %>
                                                                    <div class="form-group" style="flex: 3;">
                                                                        <label for="reservationNo">Enter Reservation
                                                                            Number:</label>
                                                                        <input type="number" id="reservationNo"
                                                                            name="reservationNo" value="<%= rNo %>"
                                                                            placeholder="e.g., 1001" required>
                                                                    </div>
                                                                    <div class="form-group"
                                                                        style="flex: 1; align-self: flex-end;">
                                                                        <button type="submit" class="btn-primary"
                                                                            style="width: 100%;">Search</button>
                                                                    </div>
                                                            </div>
                                                        </form>

                                                        <div style="text-align: center; margin: 10px 0;">
                                                            <span style="color: #666;">OR</span>
                                                        </div>

                                                        <form
                                                            action="${pageContext.request.contextPath}/receptionist/search"
                                                            method="get">
                                                            <div class="form-row">
                                                                <div class="form-group" style="flex: 3;">
                                                                    <label for="searchTerm">Search by Guest
                                                                        Name:</label>
                                                                    <input type="text" id="searchTerm" name="searchTerm"
                                                                        placeholder="Enter guest name">
                                                                </div>
                                                                <div class="form-group"
                                                                    style="flex: 1; align-self: flex-end;">
                                                                    <button type="submit" class="btn-secondary"
                                                                        style="width: 100%;">Search</button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>

                                                    <!-- Reservation Details -->
                                                    <% if (reservation !=null) { %>
                                                        <div class="details-card">
                                                            <div
                                                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                                                                <h3>Reservation #<%= reservation.getReservationNo() %>
                                                                </h3>
                                                                <span class="status <%= reservation.getStatus() %>"
                                                                    style="font-size: 1rem; padding: 8px 20px;">
                                                                    <%= reservation.getStatus().toUpperCase() %>
                                                                </span>
                                                            </div>

                                                            <div class="details-grid">
                                                                <!-- Guest Information -->
                                                                <div class="detail-item">
                                                                    <label>Guest Information</label>
                                                                    <p><strong>Name:</strong>
                                                                        <%= reservation.getGuestName() %>
                                                                    </p>
                                                                    <p><strong>Guest ID:</strong>
                                                                        <%= reservation.getGuestId() %>
                                                                    </p>
                                                                </div>

                                                                <!-- Room Information -->
                                                                <div class="detail-item">
                                                                    <label>Room Information</label>
                                                                    <p><strong>Room:</strong>
                                                                        <%= reservation.getRoomNumber() %>
                                                                    </p>
                                                                    <p><strong>Rate:</strong> LKR <%=
                                                                            String.format("%,.2f",
                                                                            reservation.getRoomRate()) %>/night</p>
                                                                </div>

                                                                <!-- Dates -->
                                                                <div class="detail-item">
                                                                    <label>Stay Dates</label>
                                                                    <p><strong>Check-in:</strong>
                                                                        <%= sdf.format(reservation.getCheckInDate()) %>
                                                                    </p>
                                                                    <p><strong>Check-out:</strong>
                                                                        <%= sdf.format(reservation.getCheckOutDate()) %>
                                                                    </p>
                                                                    <p><strong>Nights:</strong>
                                                                        <% long
                                                                            diff=reservation.getCheckOutDate().getTime()
                                                                            - reservation.getCheckInDate().getTime();
                                                                            int nights=(int) (diff / (1000 * 60 * 60 *
                                                                            24)); out.print(nights); %>
                                                                    </p>
                                                                </div>

                                                                <!-- Additional Info -->
                                                                <div class="detail-item">
                                                                    <label>Additional Information</label>
                                                                    <p><strong>Number of Guests:</strong>
                                                                        <%= reservation.getNumGuests() %>
                                                                    </p>
                                                                    <p><strong>Special Requests:</strong>
                                                                        <%= reservation.getSpecialRequests() !=null ?
                                                                            reservation.getSpecialRequests() : "None" %>
                                                                    </p>
                                                                </div>
                                                            </div>

                                                            <!-- Action Buttons -->
                                                            <div
                                                                style="display: flex; gap: 15px; margin-top: 30px; justify-content: center;">
                                                                <% if (!"cancelled".equals(reservation.getStatus()) &&
                                                                    !"completed".equals(reservation.getStatus())) { %>
                                                                    <a href="${pageContext.request.contextPath}/receptionist/calculate-bill?reservationNo=<%= reservation.getReservationNo() %>"
                                                                        class="btn-primary">Generate Bill</a>
                                                                    <button
                                                                        onclick="cancelReservation(<%= reservation.getReservationNo() %>)"
                                                                        class="btn-danger">Cancel Reservation</button>
                                                                    <% } %>

                                                                        <% if (bill !=null) { %>
                                                                            <a href="${pageContext.request.contextPath}/receptionist/calculate-bill?reservationNo=<%= reservation.getReservationNo() %>"
                                                                                class="btn-success">View Bill</a>
                                                                            <% } %>

                                                                                <button onclick="window.print()"
                                                                                    class="btn-secondary">Print
                                                                                    Details</button>
                                                            </div>
                                                        </div>

                                                        <!-- Bill Summary (if exists) -->
                                                        <% if (bill !=null) { %>
                                                            <div class="details-card">
                                                                <h3>Bill Summary</h3>
                                                                <table class="bill-table">
                                                                    <tr>
                                                                        <td>Bill ID:</td>
                                                                        <td>BILL<%= String.format("%04d",
                                                                                bill.getBillId()) %>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Total Amount:</td>
                                                                        <td>LKR <%= String.format("%,.2f",
                                                                                bill.getFinalAmount()) %>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Payment Status:</td>
                                                                        <td><span
                                                                                class="status <%= bill.getPaymentStatus() %>">
                                                                                <%= bill.getPaymentStatus() %>
                                                                            </span></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Payment Method:</td>
                                                                        <td>
                                                                            <%= bill.getPaymentMethod() !=null ?
                                                                                bill.getPaymentMethod() : "-" %>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Bill Date:</td>
                                                                        <td>
                                                                            <%= sdf.format(bill.getBillDate()) %>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                            <% } %>
                                                                <% } %>
                                </div>
                            </div>

                            <script>
                                function showHelp() {
                                    alert('View Reservation:\n\n1. Enter reservation number and click Search\n2. View complete reservation details\n3. Generate bill for check-out\n4. Cancel reservation if needed\n5. Print details for records');
                                }

                                function cancelReservation(reservationNo) {
                                    if (confirm('Are you sure you want to cancel this reservation? This action cannot be undone.')) {
                                        // In production, this would make an AJAX call
                                        window.location.href = '${pageContext.request.contextPath}/reservation/cancel?reservationNo=' + reservationNo;
                                    }
                                }
                            </script>
                        </body>

                        </html>