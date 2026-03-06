package com.oceanview.model;

public class Receptionist extends User {
    public Receptionist() {
        this.role = "receptionist";
    }

    public Receptionist(int userId, String username, String password, String fullName) {
        super(userId, username, password, "receptionist", fullName);
    }

    @Override
    public String getDashboardPage() {
        return "/receptionist/dashboard"; // Changed from .jsp to servlet path
    }
}