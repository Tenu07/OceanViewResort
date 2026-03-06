<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Bill" %>
            <%@ page import="java.util.List" %>
                <% User user=(User) session.getAttribute("user"); if (user==null ||
                    !"accountant".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login" );
                    return; } Double totalRevenue=(Double) request.getAttribute("totalRevenue"); Double
                    totalTax=(Double) request.getAttribute("totalTax"); Double totalDiscount=(Double)
                    request.getAttribute("totalDiscount"); double[] monthlyRevenue=(double[])
                    request.getAttribute("monthlyRevenue"); int[] monthlyCount=(int[])
                    request.getAttribute("monthlyCount"); List<Bill> bills = (List<Bill>) request.getAttribute("bills");
                        if (totalRevenue == null) totalRevenue = 0.0;
                        if (totalTax == null) totalTax = 0.0;
                        if (totalDiscount == null) totalDiscount = 0.0;
                        String[] monthNames = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};

                        // Build monthly data JS array safely
                        StringBuilder monthDataJs = new StringBuilder("[");
                        for (int i = 0; i < 12; i++) { if (monthlyRevenue !=null) {
                            monthDataJs.append(monthlyRevenue[i]); } else { monthDataJs.append("0"); } if (i < 11)
                            monthDataJs.append(","); } monthDataJs.append("]"); %>
                            <!DOCTYPE html>
                            <html>

                            <head>
                                <meta charset="UTF-8">
                                <title>Revenue Report - Ocean View Resort</title>
                                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                                            <li><a href="${pageContext.request.contextPath}/accountant/view-bills">💰
                                                    View Bills</a></li>
                                            <li><a href="${pageContext.request.contextPath}/accountant/revenue-report"
                                                    class="active">📈 Revenue Report</a></li>
                                            <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
                                        </ul>
                                    </div>

                                    <div class="main-content">
                                        <div class="header">
                                            <h2>Monthly Revenue Report</h2>
                                        </div>

                                        <div class="stats-cards">
                                            <div class="stat-card">
                                                <h3>Total Revenue</h3>
                                                <p class="stat-number">LKR <%= String.format("%,.0f", totalRevenue) %>
                                                </p>
                                            </div>
                                            <div class="stat-card">
                                                <h3>Total Tax Collected</h3>
                                                <p class="stat-number">LKR <%= String.format("%,.0f", totalTax) %>
                                                </p>
                                            </div>
                                            <div class="stat-card">
                                                <h3>Total Discounts Given</h3>
                                                <p class="stat-number">LKR <%= String.format("%,.0f", totalDiscount) %>
                                                </p>
                                            </div>
                                            <div class="stat-card">
                                                <h3>Bills Generated</h3>
                                                <p class="stat-number">
                                                    <%= bills !=null ? bills.size() : 0 %>
                                                </p>
                                            </div>
                                        </div>

                                        <!-- Chart -->
                                        <div class="details-card" style="height:400px;">
                                            <canvas id="revenueChart"></canvas>
                                        </div>

                                        <!-- Monthly Breakdown Table -->
                                        <div class="details-card">
                                            <h3>Monthly Breakdown</h3>
                                            <table class="data-table" style="margin-top:15px;">
                                                <thead>
                                                    <tr>
                                                        <th>Month</th>
                                                        <th>Bills</th>
                                                        <th>Revenue (LKR)</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% boolean hasData=false; if (monthlyRevenue !=null) { for (int i=0;
                                                        i < 12; i++) { if (monthlyCount !=null && monthlyCount[i]> 0) {
                                                        hasData = true;
                                                        %>
                                                        <tr>
                                                            <td>
                                                                <%= monthNames[i] %>
                                                            </td>
                                                            <td>
                                                                <%= monthlyCount[i] %>
                                                            </td>
                                                            <td>LKR <%= String.format("%,.2f", monthlyRevenue[i]) %>
                                                            </td>
                                                        </tr>
                                                        <% }}} if (!hasData) { %>
                                                            <tr>
                                                                <td colspan="3" class="text-center">No revenue data yet.
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <script>
                                    var chartData = <%= monthDataJs.toString() %>;
                                    var ctx = document.getElementById('revenueChart').getContext('2d');
                                    new Chart(ctx, {
                                        type: 'bar',
                                        data: {
                                            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                                            datasets: [{
                                                label: 'Monthly Revenue (LKR)',
                                                data: chartData,
                                                backgroundColor: 'rgba(102,126,234,0.7)',
                                                borderColor: '#667eea',
                                                borderWidth: 2,
                                                borderRadius: 5
                                            }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: { legend: { display: true, position: 'top' } },
                                            scales: { y: { beginAtZero: true } }
                                        }
                                    });
                                </script>
                            </body>

                            </html>