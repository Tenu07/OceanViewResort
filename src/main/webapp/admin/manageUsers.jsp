<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="java.util.List" %>
            <% User user=(User) session.getAttribute("user"); if (user==null || !"administrator".equals(user.getRole()))
                { response.sendRedirect(request.getContextPath() + "/login" ); return; } List<User> users = (List<User>)
                    request.getAttribute("users");
                    String error = (String) request.getAttribute("error");
                    String success = (String) request.getAttribute("success");
                    %>
                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <title>Manage Users - Ocean View Resort</title>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    </head>

                    <body>
                        <div class="dashboard">
                            <div class="sidebar">
                                <div class="sidebar-header">
                                    <h3>🌊 Ocean View Resort</h3>
                                    <p>Welcome, <%= user.getFullName() !=null ? user.getFullName() : user.getUsername()
                                            %>
                                    </p>
                                    <p><small>Administrator</small></p>
                                </div>
                                <ul class="nav-menu">
                                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">📊 Dashboard</a>
                                    </li>
                                    <li><a href="${pageContext.request.contextPath}/admin/manage-rooms">🏨 Manage
                                            Rooms</a></li>
                                    <li><a href="${pageContext.request.contextPath}/admin/manage-users"
                                            class="active">👥 Manage Users</a></li>
                                    <li><a href="${pageContext.request.contextPath}/admin/reports">📈 Reports</a></li>
                                    <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
                                </ul>
                            </div>

                            <div class="main-content">
                                <div class="header">
                                    <h2>Manage Users</h2>
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
                                                        onclick="document.getElementById('addUserModal').style.display='block'"
                                                        class="btn-primary">➕ Add New User</button>
                                                </div>

                                                <table class="data-table">
                                                    <thead>
                                                        <tr>
                                                            <th>User ID</th>
                                                            <th>Username</th>
                                                            <th>Full Name</th>
                                                            <th>Role</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% if (users !=null && !users.isEmpty()) { %>
                                                            <% for (User u : users) { %>
                                                                <tr>
                                                                    <td>
                                                                        <%= u.getUserId() %>
                                                                    </td>
                                                                    <td><strong>
                                                                            <%= u.getUsername() %>
                                                                        </strong></td>
                                                                    <td>
                                                                        <%= u.getFullName() !=null ? u.getFullName()
                                                                            : "-" %>
                                                                    </td>
                                                                    <td><span class="status confirmed">
                                                                            <%= u.getRole() %>
                                                                        </span></td>
                                                                    <td>
                                                                        <button
                                                                            onclick="showResetPassword(<%= u.getUserId() %>, '<%= u.getUsername() %>')"
                                                                            class="btn-small">Reset Password</button>
                                                                        <% if (u.getUserId() !=user.getUserId()) { %>
                                                                            <form method="post"
                                                                                action="${pageContext.request.contextPath}/admin/manage-users"
                                                                                style="display:inline;"
                                                                                onsubmit="return confirm('Delete user <%= u.getUsername() %>?');">
                                                                                <input type="hidden" name="action"
                                                                                    value="delete">
                                                                                <input type="hidden" name="userId"
                                                                                    value="<%= u.getUserId() %>">
                                                                                <button type="submit"
                                                                                    class="btn-danger btn-small">Delete</button>
                                                                            </form>
                                                                            <% } %>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                                    <% } else { %>
                                                                        <tr>
                                                                            <td colspan="5" class="text-center">No users
                                                                                found.</td>
                                                                        </tr>
                                                                        <% } %>
                                                    </tbody>
                                                </table>
                            </div>
                        </div>

                        <!-- Add User Modal -->
                        <div id="addUserModal" class="modal" style="display:none;">
                            <div class="modal-content">
                                <span class="close"
                                    onclick="document.getElementById('addUserModal').style.display='none'">&times;</span>
                                <h3>Add New User</h3>
                                <form method="post" action="${pageContext.request.contextPath}/admin/manage-users">
                                    <input type="hidden" name="action" value="add">
                                    <div class="form-group">
                                        <label>Username: *</label>
                                        <input type="text" name="username" placeholder="e.g., receptionist2" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Password: * (min 6 chars)</label>
                                        <input type="password" name="password" placeholder="Enter password" required
                                            minlength="6">
                                    </div>
                                    <div class="form-group">
                                        <label>Full Name: *</label>
                                        <input type="text" name="fullName" placeholder="e.g., John Smith" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Role: *</label>
                                        <select name="role" required>
                                            <option value="">-- Select Role --</option>
                                            <option value="receptionist">Receptionist</option>
                                            <option value="accountant">Accountant</option>
                                            <option value="administrator">Administrator</option>
                                        </select>
                                    </div>
                                    <div class="form-actions">
                                        <button type="submit" class="btn-primary">Add User</button>
                                        <button type="button"
                                            onclick="document.getElementById('addUserModal').style.display='none'"
                                            class="btn-secondary">Cancel</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Reset Password Modal -->
                        <div id="resetPwdModal" class="modal" style="display:none;">
                            <div class="modal-content">
                                <span class="close"
                                    onclick="document.getElementById('resetPwdModal').style.display='none'">&times;</span>
                                <h3>Reset Password</h3>
                                <p>Resetting password for: <strong id="resetUserName"></strong></p>
                                <form method="post" action="${pageContext.request.contextPath}/admin/manage-users">
                                    <input type="hidden" name="action" value="reset-password">
                                    <input type="hidden" name="userId" id="resetUserId">
                                    <div class="form-group">
                                        <label>New Password: * (min 6 chars)</label>
                                        <input type="password" name="newPassword" placeholder="Enter new password"
                                            required minlength="6">
                                    </div>
                                    <div class="form-actions">
                                        <button type="submit" class="btn-primary">Reset Password</button>
                                        <button type="button"
                                            onclick="document.getElementById('resetPwdModal').style.display='none'"
                                            class="btn-secondary">Cancel</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <script>
                            function showResetPassword(userId, username) {
                                document.getElementById('resetUserId').value = userId;
                                document.getElementById('resetUserName').textContent = username;
                                document.getElementById('resetPwdModal').style.display = 'block';
                            }
                        </script>
                    </body>

                    </html>