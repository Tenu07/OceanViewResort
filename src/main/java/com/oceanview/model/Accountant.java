package com.oceanview.model;

public class Accountant extends User {
    public Accountant() {
        this.role = "accountant";
    }

    public Accountant(int userId, String username, String password, String fullName) {
        super(userId, username, password, "accountant", fullName);
    }

    @Override
    public String getDashboardPage() {
        return "/accountant/dashboard.jsp";
    }
}