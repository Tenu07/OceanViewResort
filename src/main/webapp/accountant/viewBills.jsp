<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Bill" %>
            <%@ page import="java.util.List" %>
                <% User user=(User) session.getAttribute("user"); if (user==null ||
                    !"accountant".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login" );
                    return; } List<Bill> bills = (List<Bill>) request.getAttribute("bills");
                        String error = (String) request.getAttribute("error");
                        %>
                        <!DOCTYPE html>
                        <html>

                        <head>
                            <meta charset="UTF-8">
                            <title>View Bills - Ocean View Resort</title>
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
                                        <p><small>Accountant</small></p>
                                    </div>
                                    <ul class="nav-menu">
                                        <li><a href="${pageContext.request.contextPath}/accountant/dashboard">📊
                                                Dashboard</a></li>
                                        <li><a href="${pageContext.request.contextPath}/accountant/view-bills"
                                                class="active">💰 View Bills</a></li>
                                        <li><a href="${pageContext.request.contextPath}/accountant/revenue-report">📈
                                                Revenue Report</a></li>
                                        <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
                                    </ul>
                                </div>

                                <div class="main-content">
                                    <div class="header">
                                        <h2>All Bills</h2>
                                    </div>

                                    <% if (error !=null) { %>
                                        <div class="error-message">
                                            <%= error %>
                                        </div>
                                        <% } %>

                                            <div class="details-card">
                                                <table class="data-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Bill ID</th>
                                                            <th>Reservation #</th>
                                                            <th>Guest Name</th>
                                                            <th>Room</th>
                                                            <th>Nights</th>
                                                            <th>Total (LKR)</th>
                                                            <th>Discount (LKR)</th>
                                                            <th>Tax (LKR)</th>
                                                            <th>Final (LKR)</th>
                                                            <th>Payment</th>
                                                            <th>Status</th>
                                                            <th>Date</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% if (bills !=null && !bills.isEmpty()) { for (Bill b : bills)
                                                            { %>
                                                            <tr>
                                                                <td>BILL<%= String.format("%04d", b.getBillId()) %>
                                                                </td>
                                                                <td>#<%= b.getReservationNo() %>
                                                                </td>
                                                                <td>
                                                                    <%= b.getGuestName() !=null ? b.getGuestName() : "-"
                                                                        %>
                                                                </td>
                                                                <td>
                                                                    <%= b.getRoomNumber() !=null ? b.getRoomNumber()
                                                                        : "-" %>
                                                                </td>
                                                                <td>
                                                                    <%= b.getNumNights() %>
                                                                </td>
                                                                <td>
                                                                    <%= String.format("%,.2f", b.getTotalAmount()) %>
                                                                </td>
                                                                <td>
                                                                    <%= String.format("%,.2f", b.getDiscount()) %>
                                                                </td>
                                                                <td>
                                                                    <%= String.format("%,.2f", b.getTaxAmount()) %>
                                                                </td>
                                                                <td><strong>
                                                                        <%= String.format("%,.2f", b.getFinalAmount())
                                                                            %>
                                                                    </strong></td>
                                                                <td>
                                                                    <%= b.getPaymentMethod() !=null ?
                                                                        b.getPaymentMethod() : "-" %>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class='status <%= "paid".equals(b.getPaymentStatus()) ? "confirmed" : "pending" %>'>
                                                                        <%= b.getPaymentStatus() %>
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <%= b.getBillDate() !=null ? new
                                                                        java.text.SimpleDateFormat("yyyy-MM-dd").format(b.getBillDate())
                                                                        : "-" %>
                                                                </td>
                                                            </tr>
                                                            <% } } else { %>
                                                                <tr>
                                                                    <td colspan="12" class="text-center">No bills found.
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <% if (bills !=null && !bills.isEmpty()) { double totalFinal=0; for (Bill b
                                                : bills) totalFinal +=b.getFinalAmount(); %>
                                                <div class="details-card" style="text-align:right;">
                                                    <strong>Grand Total Collected: LKR <%= String.format("%,.2f",
                                                            totalFinal) %></strong>
                                                </div>
                                                <% } %>
                                </div>
                            </div>
                        </body>

                        </html>