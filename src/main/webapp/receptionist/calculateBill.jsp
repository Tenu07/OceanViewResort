<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Bill" %>
<%@ page import="com.oceanview.model.Reservation" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"receptionist".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Bill bill = (Bill) request.getAttribute("bill");
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String info = (String) request.getAttribute("info");
    String resNoParam = request.getParameter("reservationNo");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Calculate Bill - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .bill-box {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            margin: 15px 0;
        }
        .bill-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .bill-row:last-child {
            border-bottom: none;
            font-size: 1.2rem;
            font-weight: 700;
            color: #667eea;
        }
        @media print {
            .sidebar, .header, .btn-primary, .btn-secondary, form.calc-form {
                display: none !important;
            }
            .bill-print {
                display: block !important;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>🌊 Ocean View Resort</h3>
                <p>Welcome, <%= user.getFullName() != null ? user.getFullName() : user.getUsername() %></p>
                <p><small>Receptionist</small></p>
            </div>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/receptionist/dashboard">📊 Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/receptionist/add-reservation">➕ New Reservation</a></li>
                <li><a href="${pageContext.request.contextPath}/receptionist/view-reservation">🔍 View Reservation</a></li>
                <li><a href="${pageContext.request.contextPath}/receptionist/calculate-bill" class="active">💰 Calculate Bill</a></li>
                <li><a href="${pageContext.request.contextPath}/receptionist/search">🔎 Search</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
            </ul>
        </div>

        <div class="main-content">
            <div class="header">
                <h2>Calculate & Print Bill</h2>
            </div>

            <% if (error != null) { %>
                <div class="error-message"><%= error %></div>
            <% } %>

            <% if (success != null) { %>
                <div class="success-message"><%= success %></div>
            <% } %>

            <% if (info != null) { %>
                <div class="info-message" style="background:#e3f2fd; color:#1565c0; padding:15px; border-radius:8px; margin-bottom:15px;">
                    ℹ <%= info %>
                </div>
            <% } %>

            <!-- Step 1: Search for reservation (GET) -->
            <% if (bill == null) { %>
                <div class="details-card">
                    <h3>Step 1: Find Reservation</h3>
                    <form class="calc-form" action="${pageContext.request.contextPath}/receptionist/calculate-bill" method="get">
                        <div class="form-row">
                            <div class="form-group" style="flex:3;">
                                <label>Reservation Number: *</label>
                                <input type="number" name="reservationNo"
                                       value="<%= resNoParam != null ? resNoParam : "" %>"
                                       placeholder="e.g., 1001" required min="1">
                            </div>
                            <div class="form-group" style="flex:1; align-self:flex-end;">
                                <button type="submit" class="btn-secondary" style="width:100%;">🔍 Load Details</button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Step 2: Preview + Generate (POST) — only shown after reservation is loaded -->
                <% if (reservation != null) { %>
                    <div class="details-card">
                        <h3>Step 2: Review & Generate Bill</h3>
                        <form class="calc-form" action="${pageContext.request.contextPath}/reservation/calculate-bill" method="post">
                            <input type="hidden" name="reservationNo" value="<%= reservation.getReservationNo() %>">

                            <div class="bill-box">
                                <h4>Reservation Details</h4>
                                <div class="bill-row">
                                    <span>Reservation #</span>
                                    <span>#<%= reservation.getReservationNo() %></span>
                                </div>
                                <div class="bill-row">
                                    <span>Guest</span>
                                    <span><%= reservation.getGuestName() != null ? reservation.getGuestName() : "-" %></span>
                                </div>
                                <div class="bill-row">
                                    <span>Room</span>
                                    <span><%= reservation.getRoomNumber() != null ? reservation.getRoomNumber() : "-" %></span>
                                </div>
                                <div class="bill-row">
                                    <span>Check-in</span>
                                    <span>
                                        <%= reservation.getCheckInDate() != null ?
                                            new java.text.SimpleDateFormat("yyyy-MM-dd").format(reservation.getCheckInDate()) : "-" %>
                                    </span>
                                </div>
                                <div class="bill-row">
                                    <span>Check-out</span>
                                    <span>
                                        <%= reservation.getCheckOutDate() != null ?
                                            new java.text.SimpleDateFormat("yyyy-MM-dd").format(reservation.getCheckOutDate()) : "-" %>
                                    </span>
                                </div>
                                <%
                                    int nights = 0;
                                    if (reservation.getCheckInDate() != null && reservation.getCheckOutDate() != null) {
                                        long diff = reservation.getCheckOutDate().getTime() - reservation.getCheckInDate().getTime();
                                        nights = (int) (diff / (1000 * 60 * 60 * 24));
                                    }
                                %>
                                <div class="bill-row">
                                    <span>Nights</span>
                                    <span><%= nights %></span>
                                </div>
                                <div class="bill-row">
                                    <span>Rate/night</span>
                                    <span>LKR <%= String.format("%,.2f", reservation.getRoomRate()) %></span>
                                </div>
                                <div class="bill-row">
                                    <span>Subtotal</span>
                                    <span>LKR <%= String.format("%,.2f", nights * reservation.getRoomRate()) %></span>
                                </div>
                            </div>

                            <div class="form-row" style="margin-top:15px;">
                                <div class="form-group" style="flex:1;">
                                    <label>Discount (% off total):</label>
                                    <input type="number" name="discount" min="0" max="50" step="1" value="0" placeholder="e.g. 10 for 10%">
                                </div>
                                <div class="form-group" style="flex:1;">
                                    <label>Payment Method:</label>
                                    <select name="paymentMethod">
                                        <option value="cash">Cash</option>
                                        <option value="card">Card</option>
                                        <option value="bank_transfer">Bank Transfer</option>
                                        <option value="online">Online</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn-primary">💰 Generate Bill</button>
                            </div>
                        </form>
                    </div>
                <% } %>
            <% } %>

            <!-- Generated Bill -->
            <% if (bill != null) { %>
                <div class="details-card">
                    <div style="text-align:center; margin-bottom:20px;">
                        <h3>🏨 Ocean View Resort - Official Bill</h3>
                        <%
                            String billDateStr = "Today";
                            if (bill.getBillDate() != null) {
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                                billDateStr = sdf.format(bill.getBillDate());
                            }
                        %>
                        <p>Bill No: <strong>BILL<%= String.format("%04d", bill.getBillId()) %></strong>
                           &nbsp;|&nbsp; Date: <strong><%= billDateStr %></strong></p>
                    </div>

                    <div class="bill-box">
                        <div class="bill-row">
                            <span>Reservation #</span>
                            <span>#<%= bill.getReservationNo() %></span>
                        </div>

                        <% if (bill.getGuestName() != null) { %>
                            <div class="bill-row">
                                <span>Guest Name</span>
                                <span><%= bill.getGuestName() %></span>
                            </div>
                        <% } %>

                        <% if (bill.getRoomNumber() != null) { %>
                            <div class="bill-row">
                                <span>Room</span>
                                <span><%= bill.getRoomNumber() %></span>
                            </div>
                        <% } %>

                        <div class="bill-row">
                            <span>Number of Nights</span>
                            <span><%= bill.getNumNights() %></span>
                        </div>

                        <div class="bill-row">
                            <span>Room Charges</span>
                            <span>LKR <%= String.format("%,.2f", bill.getTotalAmount()) %></span>
                        </div>

                        <div class="bill-row">
                            <span>Tax (10%)</span>
                            <span>LKR <%= String.format("%,.2f", bill.getTaxAmount()) %></span>
                        </div>

                        <% if (bill.getDiscount() > 0) { %>
                            <div class="bill-row" style="color:green;">
                                <span>Discount</span>
                                <span>- LKR <%= String.format("%,.2f", bill.getDiscount()) %></span>
                            </div>
                        <% } %>

                        <div class="bill-row">
                            <span>TOTAL DUE</span>
                            <span>LKR <%= String.format("%,.2f", bill.getFinalAmount()) %></span>
                        </div>
                    </div>

                    <div style="margin-top:15px; display:flex; gap:10px; justify-content:center; flex-wrap:wrap;">
                        <p><strong>Payment:</strong>
                            <span class="status <%= bill.getPaymentStatus() %>"><%= bill.getPaymentStatus() %></span>
                            &nbsp; Method: <strong><%= bill.getPaymentMethod() != null ? bill.getPaymentMethod() : "-" %></strong>
                        </p>
                    </div>

                    <div style="display:flex; gap:15px; justify-content:center; margin-top:20px;">
                        <button onclick="window.print()" class="btn-primary">🖨 Print Bill</button>
                        <a href="${pageContext.request.contextPath}/receptionist/calculate-bill" class="btn-secondary">New Bill</a>
                        <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="btn-secondary">Dashboard</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>