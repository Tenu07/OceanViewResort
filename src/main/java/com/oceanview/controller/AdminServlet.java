package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.model.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {
        "/admin/dashboard",
        "/admin/manage-rooms",
        "/admin/manage-users",
        "/admin/reports"
})
public class AdminServlet extends HttpServlet {

    private RoomDAO roomDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"administrator".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/dashboard".equals(path)) {
            showDashboard(request, response);
        } else if ("/admin/manage-rooms".equals(path)) {
            showManageRooms(request, response);
        } else if ("/admin/manage-users".equals(path)) {
            showManageUsers(request, response);
        } else if ("/admin/reports".equals(path)) {
            showReports(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"administrator".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String action = request.getParameter("action");

        if ("/admin/manage-rooms".equals(path)) {
            if ("add".equals(action)) {
                addRoom(request, response);
            } else if ("delete".equals(action)) {
                deleteRoom(request, response);
            } else if ("toggle".equals(action)) {
                toggleRoomStatus(request, response);
            } else {
                showManageRooms(request, response);
            }
        } else if ("/admin/manage-users".equals(path)) {
            if ("add".equals(action)) {
                addUser(request, response);
            } else if ("delete".equals(action)) {
                deleteUser(request, response);
            } else if ("reset-password".equals(action)) {
                resetPassword(request, response);
            } else {
                showManageUsers(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Room> rooms = roomDAO.getAllRooms();
            List<User> users = userDAO.getAllUsers();

            long availableRooms = rooms.stream().filter(Room::isAvailabilityStatus).count();
            long occupiedRooms = rooms.size() - availableRooms;

            request.setAttribute("totalRooms", rooms.size());
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("occupiedRooms", occupiedRooms);
            request.setAttribute("totalUsers", users.size());
        } catch (Exception e) {
            System.err.println("Error loading dashboard stats: " + e.getMessage());
            request.setAttribute("totalRooms", 0);
            request.setAttribute("availableRooms", 0);
            request.setAttribute("occupiedRooms", 0);
            request.setAttribute("totalUsers", 0);
        }
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private void showManageRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Room> rooms = roomDAO.getAllRooms();
            List<RoomType> roomTypes = roomDAO.getAllRoomTypes();
            request.setAttribute("rooms", rooms);
            request.setAttribute("roomTypes", roomTypes);
        } catch (Exception e) {
            System.err.println("Error loading rooms: " + e.getMessage());
            request.setAttribute("error", "Failed to load room data: " + e.getMessage());
        }
        request.getRequestDispatcher("/admin/manageRooms.jsp").forward(request, response);
    }

    private void showManageUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
        } catch (Exception e) {
            System.err.println("Error loading users: " + e.getMessage());
            request.setAttribute("error", "Failed to load user data: " + e.getMessage());
        }
        request.getRequestDispatcher("/admin/manageUsers.jsp").forward(request, response);
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Room> rooms = roomDAO.getAllRooms();
            long availableRooms = rooms.stream().filter(Room::isAvailabilityStatus).count();
            int totalRooms = rooms.size();
            int occupancyPct = totalRooms > 0 ? (int) ((totalRooms - availableRooms) * 100 / totalRooms) : 0;
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("occupancyPct", occupancyPct);
        } catch (Exception e) {
            System.err.println("Error loading reports: " + e.getMessage());
        }
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String roomNumber = request.getParameter("roomNumber");
            int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
            double rate = Double.parseDouble(request.getParameter("ratePerNight"));
            int floor = Integer.parseInt(request.getParameter("floorNumber"));

            if (roomNumber == null || roomNumber.trim().isEmpty()) {
                request.setAttribute("error", "Room number is required.");
            } else {
                Room room = new Room();
                room.setRoomNumber(roomNumber.trim());
                room.setRoomTypeId(roomTypeId);
                room.setRatePerNight(rate);
                room.setFloorNumber(floor);
                room.setAvailabilityStatus(true);

                boolean success = roomDAO.addRoom(room);
                if (success) {
                    request.setAttribute("success", "Room " + roomNumber + " added successfully!");
                } else {
                    request.setAttribute("error", "Failed to add room. Room number may already exist.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error adding room: " + e.getMessage());
        }
        showManageRooms(request, response);
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            boolean success = roomDAO.deleteRoom(roomId);
            if (success) {
                request.setAttribute("success", "Room deleted successfully.");
            } else {
                request.setAttribute("error", "Failed to delete room. It may have active reservations.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error deleting room: " + e.getMessage());
        }
        showManageRooms(request, response);
    }

    private void toggleRoomStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));
            boolean newStatus = !currentStatus;
            roomDAO.updateRoomStatus(roomId, newStatus);
            request.setAttribute("success", "Room status updated to " + (newStatus ? "Available" : "Occupied") + ".");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating room status: " + e.getMessage());
        }
        showManageRooms(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");

            if (username == null || username.trim().isEmpty() ||
                    password == null || password.trim().isEmpty() ||
                    fullName == null || fullName.trim().isEmpty() ||
                    role == null || role.trim().isEmpty()) {
                request.setAttribute("error", "All fields are required.");
            } else if (password.length() < 6) {
                request.setAttribute("error", "Password must be at least 6 characters.");
            } else {
                boolean success = userDAO.addUser(username.trim(), password, fullName.trim(), role.trim());
                if (success) {
                    request.setAttribute("success", "User '" + username + "' added successfully!");
                } else {
                    request.setAttribute("error", "Failed to add user. Username may already exist.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error adding user: " + e.getMessage());
        }
        showManageUsers(request, response);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            // Prevent deleting admin with ID 1
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("user");
            if (userId == currentUser.getUserId()) {
                request.setAttribute("error", "You cannot delete your own account.");
            } else {
                boolean success = userDAO.deleteUser(userId);
                if (success) {
                    request.setAttribute("success", "User deleted successfully.");
                } else {
                    request.setAttribute("error", "Failed to delete user.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error deleting user: " + e.getMessage());
        }
        showManageUsers(request, response);
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String newPassword = request.getParameter("newPassword");
            if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("error", "New password must be at least 6 characters.");
            } else {
                boolean success = userDAO.resetPassword(userId, newPassword);
                if (success) {
                    request.setAttribute("success", "Password reset successfully.");
                } else {
                    request.setAttribute("error", "Failed to reset password.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error resetting password: " + e.getMessage());
        }
        showManageUsers(request, response);
    }
}