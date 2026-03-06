<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Room" %>
            <%@ page import="com.oceanview.model.RoomType" %>
                <%@ page import="java.util.List" %>
                    <% User user=(User) session.getAttribute("user"); if (user==null ||
                        !"administrator".equals(user.getRole())) { response.sendRedirect(request.getContextPath()
                        + "/login" ); return; } List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                            List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
                                    String error = (String) request.getAttribute("error");
                                    String success = (String) request.getAttribute("success");
                                    %>
                                    <!DOCTYPE html>
                                    <html>

                                    <head>
                                        <meta charset="UTF-8">
                                        <title>Manage Rooms - Ocean View Resort</title>
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
                                                    <p><small>Administrator</small></p>
                                                </div>
                                                <ul class="nav-menu">
                                                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">📊
                                                            Dashboard</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/admin/manage-rooms"
                                                            class="active">🏨 Manage Rooms</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/admin/manage-users">👥
                                                            Manage Users</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/admin/reports">📈
                                                            Reports</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/logout">🚪
                                                            Logout</a></li>
                                                </ul>
                                            </div>

                                            <div class="main-content">
                                                <div class="header">
                                                    <h2>Manage Rooms</h2>
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

                                                                <div class="quick-actions">
                                                                    <button
                                                                        onclick="document.getElementById('addRoomModal').style.display='block'"
                                                                        class="btn-primary">➕ Add New Room</button>
                                                                </div>

                                                                <table class="data-table">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Room ID</th>
                                                                            <th>Room Number</th>
                                                                            <th>Room Type</th>
                                                                            <th>Rate/Night (LKR)</th>
                                                                            <th>Floor</th>
                                                                            <th>Status</th>
                                                                            <th>Actions</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% if (rooms !=null && !rooms.isEmpty()) { %>
                                                                            <% for (Room room : rooms) { %>
                                                                                <tr>
                                                                                    <td>
                                                                                        <%= room.getRoomId() %>
                                                                                    </td>
                                                                                    <td><strong>
                                                                                            <%= room.getRoomNumber() %>
                                                                                        </strong></td>
                                                                                    <td>
                                                                                        <%= room.getRoomTypeName() %>
                                                                                    </td>
                                                                                    <td>LKR <%= String.format("%,.2f",
                                                                                            room.getRatePerNight()) %>
                                                                                    </td>
                                                                                    <td>Floor <%= room.getFloorNumber()
                                                                                            %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span
                                                                                            class='status <%= room.isAvailabilityStatus() ? "confirmed" : "cancelled" %>'>
                                                                                            <%= room.isAvailabilityStatus()
                                                                                                ? "Available"
                                                                                                : "Occupied" %>
                                                                                        </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <form method="post"
                                                                                            action="${pageContext.request.contextPath}/admin/manage-rooms"
                                                                                            style="display:inline;">
                                                                                            <input type="hidden"
                                                                                                name="action"
                                                                                                value="toggle">
                                                                                            <input type="hidden"
                                                                                                name="roomId"
                                                                                                value="<%= room.getRoomId() %>">
                                                                                            <input type="hidden"
                                                                                                name="currentStatus"
                                                                                                value="<%= room.isAvailabilityStatus() %>">
                                                                                            <button type="submit"
                                                                                                class="btn-small">
                                                                                                <%= room.isAvailabilityStatus()
                                                                                                    ? "Mark Occupied"
                                                                                                    : "Mark Available"
                                                                                                    %>
                                                                                            </button>
                                                                                        </form>
                                                                                        <form method="post"
                                                                                            action="${pageContext.request.contextPath}/admin/manage-rooms"
                                                                                            style="display:inline;"
                                                                                            onsubmit="return confirm('Delete this room?');">
                                                                                            <input type="hidden"
                                                                                                name="action"
                                                                                                value="delete">
                                                                                            <input type="hidden"
                                                                                                name="roomId"
                                                                                                value="<%= room.getRoomId() %>">
                                                                                            <button type="submit"
                                                                                                class="btn-danger btn-small">Delete</button>
                                                                                        </form>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } %>
                                                                                    <% } else { %>
                                                                                        <tr>
                                                                                            <td colspan="7"
                                                                                                class="text-center">No
                                                                                                rooms found. Add your
                                                                                                first room!</td>
                                                                                        </tr>
                                                                                        <% } %>
                                                                    </tbody>
                                                                </table>
                                            </div>
                                        </div>

                                        <!-- Add Room Modal -->
                                        <div id="addRoomModal" class="modal" style="display:none;">
                                            <div class="modal-content">
                                                <span class="close"
                                                    onclick="document.getElementById('addRoomModal').style.display='none'">&times;</span>
                                                <h3>Add New Room</h3>
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/manage-rooms">
                                                    <input type="hidden" name="action" value="add">
                                                    <div class="form-group">
                                                        <label for="roomNumber">Room Number: *</label>
                                                        <input type="text" id="roomNumber" name="roomNumber"
                                                            placeholder="e.g., 101" required>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="roomTypeId">Room Type: *</label>
                                                        <select id="roomTypeId" name="roomTypeId" required>
                                                            <option value="">-- Select Type --</option>
                                                            <% if (roomTypes !=null) { for (RoomType rt : roomTypes) {
                                                                %>
                                                                <option value="<%= rt.getTypeId() %>">
                                                                    <%= rt.getTypeName() %> (Base: LKR <%=
                                                                            String.format("%,.0f", rt.getBaseRate()) %>)
                                                                </option>
                                                                <% }} %>
                                                                    <% if (roomTypes==null || roomTypes.isEmpty()) { %>
                                                                        <option value="1">Standard</option>
                                                                        <option value="2">Deluxe</option>
                                                                        <option value="3">Suite</option>
                                                                        <% } %>
                                                        </select>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="ratePerNight">Rate per Night (LKR): *</label>
                                                        <input type="number" id="ratePerNight" name="ratePerNight"
                                                            min="0" step="100" placeholder="e.g., 5000" required>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="floorNumber">Floor Number: *</label>
                                                        <input type="number" id="floorNumber" name="floorNumber" min="1"
                                                            max="20" placeholder="e.g., 1" required>
                                                    </div>
                                                    <div class="form-actions">
                                                        <button type="submit" class="btn-primary">Add Room</button>
                                                        <button type="button"
                                                            onclick="document.getElementById('addRoomModal').style.display='none'"
                                                            class="btn-secondary">Cancel</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </body>

                                    </html>