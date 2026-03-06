package com.oceanview.model;

public class Administrator extends User {
    public Administrator() {
        this.role = "administrator";
    }

    public Administrator(int userId, String username, String password, String fullName) {
        super(userId, username, password, "administrator", fullName);
    }

    @Override
    public String getDashboardPage() {
        return "/admin/dashboard.jsp";
    }
}