<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <% User user=(User) session.getAttribute("user"); if (user==null || !"accountant".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login" ); return; } Double totalRevenue=(Double)
            request.getAttribute("totalRevenue"); Double pendingPayments=(Double)
            request.getAttribute("pendingPayments"); Integer totalBills=(Integer) request.getAttribute("totalBills");
            Integer paidCount=(Integer) request.getAttribute("paidCount"); Integer pendingCount=(Integer)
            request.getAttribute("pendingCount"); if (totalRevenue==null) totalRevenue=0.0; if (pendingPayments==null)
            pendingPayments=0.0; if (totalBills==null) totalBills=0; if (paidCount==null) paidCount=0; if
            (pendingCount==null) pendingCount=0; %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Accountant Dashboard - Ocean View Resort</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <div class="dashboard">
                    <div class="sidebar">
                        <div class="sidebar-header">
                            <h3>🌊 Ocean View Resort</h3>
                            <p>Welcome, <%= user.getFullName() !=null ? user.getFullName() : user.getUsername() %>
                            </p>
                            <p><small>Accountant</small></p>
                        </div>
                        <ul class="nav-menu">
                            <li><a href="${pageContext.request.contextPath}/accountant/dashboard" class="active">📊
                                    Dashboard</a></li>
                            <li><a href="${pageContext.request.contextPath}/accountant/view-bills">💰 View Bills</a>
                            </li>
                            <li><a href="${pageContext.request.contextPath}/accountant/revenue-report">📈 Revenue
                                    Report</a></li>
                            <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
                        </ul>
                    </div>

                    <div class="main-content">
                        <div class="header">
                            <h2>Accountant Dashboard</h2>
                            <p>
                                <%= new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy").format(new java.util.Date())
                                    %>
                            </p>
                        </div>

                        <div class="stats-cards">
                            <div class="stat-card">
                                <h3>Total Revenue</h3>
                                <p class="stat-number">LKR <%= String.format("%,.0f", totalRevenue) %>
                                </p>
                                <p>All time earnings</p>
                            </div>
                            <div class="stat-card">
                                <h3>Pending Payments</h3>
                                <p class="stat-number">LKR <%= String.format("%,.0f", pendingPayments) %>
                                </p>
                                <p>Outstanding</p>
                            </div>
                            <div class="stat-card">
                                <h3>Total Bills</h3>
                                <p class="stat-number">
                                    <%= totalBills %>
                                </p>
                                <p>All invoices</p>
                            </div>
                            <div class="stat-card">
                                <h3>Paid Bills</h3>
                                <p class="stat-number">
                                    <%= paidCount %>
                                </p>
                                <p>
                                    <%= pendingCount %> pending
                                </p>
                            </div>
                        </div>

                        <div class="details-card">
                            <h3>Quick Navigation</h3>
                            <div
                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-top: 15px;">
                                <a href="${pageContext.request.contextPath}/accountant/view-bills" class="btn-primary"
                                    style="text-align:center; padding:20px; text-decoration:none; border-radius:10px; display:block;">
                                    💰<br><strong>View All Bills</strong>
                                </a>
                                <a href="${pageContext.request.contextPath}/accountant/revenue-report"
                                    class="btn-success"
                                    style="text-align:center; padding:20px; text-decoration:none; border-radius:10px; display:block;">
                                    📈<br><strong>Revenue Report</strong>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </body>

            </html>