<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <% User user=(User) session.getAttribute("user"); if (user==null || !"administrator".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login" ); return; } Integer totalRooms=(Integer)
            request.getAttribute("totalRooms"); Long availableRooms=(Long) request.getAttribute("availableRooms");
            Integer occupancyPct=(Integer) request.getAttribute("occupancyPct"); if (totalRooms==null) totalRooms=0; if
            (availableRooms==null) availableRooms=0L; if (occupancyPct==null) occupancyPct=0; %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Reports - Ocean View Resort</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <style>
                    .chart-container {
                        background: #fff;
                        border-radius: 15px;
                        padding: 20px;
                        margin: 20px 0;
                        height: 350px;
                    }

                    .report-filters {
                        background: #fff;
                        border-radius: 15px;
                        padding: 20px;
                        margin-bottom: 20px;
                    }
                </style>
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
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard">📊 Dashboard</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/manage-rooms">🏨 Manage Rooms</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/manage-users">👥 Manage Users</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/reports" class="active">📈 Reports</a>
                            </li>
                            <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
                        </ul>
                    </div>

                    <div class="main-content">
                        <div class="header">
                            <h2>System Reports</h2>
                        </div>

                        <div class="stats-cards">
                            <div class="stat-card">
                                <h3>Total Rooms</h3>
                                <p class="stat-number">
                                    <%= totalRooms %>
                                </p>
                                <p>Managed rooms</p>
                            </div>
                            <div class="stat-card">
                                <h3>Available Rooms</h3>
                                <p class="stat-number">
                                    <%= availableRooms %>
                                </p>
                                <p>Ready for booking</p>
                            </div>
                            <div class="stat-card">
                                <h3>Occupancy Rate</h3>
                                <p class="stat-number">
                                    <%= occupancyPct %>%
                                </p>
                                <p>Current</p>
                            </div>
                            <div class="stat-card">
                                <h3>System Date</h3>
                                <p class="stat-number" style="font-size:1rem;">
                                    <%= new java.text.SimpleDateFormat("MMM yyyy").format(new java.util.Date()) %>
                                </p>
                                <p>Current period</p>
                            </div>
                        </div>

                        <div class="report-filters">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Report Type:</label>
                                    <select id="reportType" onchange="updateChart()">
                                        <option value="occupancy">Room Occupancy</option>
                                        <option value="reservations">Reservation Trends</option>
                                    </select>
                                </div>
                                <button class="btn-primary" onclick="window.print()">🖨 Print Report</button>
                            </div>
                        </div>

                        <div class="chart-container">
                            <canvas id="reportChart"></canvas>
                        </div>

                        <div class="details-card">
                            <h3>Room Occupancy Summary</h3>
                            <table class="data-table" style="margin-top:15px;">
                                <thead>
                                    <tr>
                                        <th>Metric</th>
                                        <th>Value</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Total Rooms</td>
                                        <td><strong>
                                                <%= totalRooms %>
                                            </strong></td>
                                    </tr>
                                    <tr>
                                        <td>Available Now</td>
                                        <td><strong>
                                                <%= availableRooms %>
                                            </strong></td>
                                    </tr>
                                    <tr>
                                        <td>Occupied Now</td>
                                        <td><strong>
                                                <%= totalRooms - availableRooms %>
                                            </strong></td>
                                    </tr>
                                    <tr>
                                        <td>Occupancy Rate</td>
                                        <td><strong>
                                                <%= occupancyPct %>%
                                            </strong></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <script>
                    var myChart;
                    function updateChart() {
                        const type = document.getElementById('reportType').value;
                        const ctx = document.getElementById('reportChart').getContext('2d');
                        if (myChart) myChart.destroy();

                        const occupied = <%= totalRooms - availableRooms %>;
                        const available = <%= availableRooms %>;

                        if (type === 'occupancy') {
                            myChart = new Chart(ctx, {
                                type: 'doughnut',
                                data: {
                                    labels: ['Occupied', 'Available'],
                                    datasets: [{
                                        data: [occupied, available],
                                        backgroundColor: ['#667eea', '#48bb78'], borderWidth: 0
                                    }]
                                },
                                options: {
                                    responsive: true, maintainAspectRatio: false,
                                    plugins: { legend: { position: 'bottom' } }
                                }
                            });
                        } else {
                            myChart = new Chart(ctx, {
                                type: 'bar',
                                data: {
                                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                                    datasets: [{
                                        label: 'Reservations', data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                        backgroundColor: 'rgba(102,126,234,0.7)', borderRadius: 5
                                    }]
                                },
                                options: {
                                    responsive: true, maintainAspectRatio: false,
                                    scales: { y: { beginAtZero: true } }
                                }
                            });
                        }
                    }
                    window.onload = updateChart;
                </script>
            </body>

            </html>