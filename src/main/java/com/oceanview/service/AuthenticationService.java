package com.oceanview.service;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

public class AuthenticationService {
    private UserDAO userDAO;

    public AuthenticationService() {
        this.userDAO = new UserDAO();
        System.out.println("AuthenticationService initialized");
    }

    public User authenticate(String username, String password) {
        // Validate credentials
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            System.out.println("Authentication failed: Empty username or password");
            return null;
        }

        System.out.println("Attempting to authenticate user: " + username);

        try {
            User user = userDAO.validateUser(username, password);

            if (user != null) {
                System.out.println("Authentication successful for: " + username);
            } else {
                System.out.println("Authentication failed for: " + username);
            }

            return user;
        } catch (Exception e) {
            System.out.println("Exception during authentication: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        // Validate password strength
        if (newPassword == null || newPassword.length() < 6) {
            System.out.println("Password change failed: New password too short");
            return false;
        }

        System.out.println("Attempting to change password for user ID: " + userId);
        boolean result = userDAO.changePassword(userId, oldPassword, newPassword);

        if (result) {
            System.out.println("Password changed successfully for user ID: " + userId);
        } else {
            System.out.println("Password change failed for user ID: " + userId);
        }

        return result;
    }
}