package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {
    private static DatabaseConnection instance;
    private Connection connection;
    private String url = "jdbc:mysql://localhost:3306/ocean_view_resort?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&autoReconnect=true&failOverReadOnly=false&maxReconnects=10";
    private String username = "root";
    private String password = "tenu@123";
    private boolean isConnected = false;

    private DatabaseConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            initializeConnection();
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    private void initializeConnection() {
        try {
            createNewConnection();
            isConnected = true;
            System.out.println("Database connection created successfully");
        } catch (SQLException e) {
            isConnected = false;
            System.err.println("Failed to create database connection: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void createNewConnection() throws SQLException {
        // Set connection properties for better stability
        Properties props = new Properties();
        props.setProperty("user", username);
        props.setProperty("password", password);
        props.setProperty("useSSL", "false");
        props.setProperty("autoReconnect", "true");
        props.setProperty("failOverReadOnly", "false");
        props.setProperty("maxReconnects", "10");
        props.setProperty("connectTimeout", "5000");
        props.setProperty("socketTimeout", "30000");

        // Try to establish connection
        this.connection = DriverManager.getConnection(url, props);
    }

    public static DatabaseConnection getInstance() {
        if (instance == null) {
            synchronized (DatabaseConnection.class) {
                if (instance == null) {
                    instance = new DatabaseConnection();
                }
            }
        }
        return instance;
    }

    public Connection getConnection() {
        try {
            // Check if connection exists and is valid
            if (connection == null) {
                System.out.println("Connection is null. Creating new connection...");
                initializeConnection();
            } else if (connection.isClosed()) {
                System.out.println("Connection is closed. Creating new connection...");
                initializeConnection();
            } else {
                // Test if connection is valid
                try {
                    if (!connection.isValid(2)) {
                        System.out.println("Connection is invalid. Creating new connection...");
                        initializeConnection();
                    }
                } catch (SQLException e) {
                    System.out.println("Connection validation failed. Creating new connection...");
                    initializeConnection();
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking connection state: " + e.getMessage());
            // Attempt to reconnect
            initializeConnection();
        }

        return connection;
    }

    public boolean isConnected() {
        try {
            return connection != null && !connection.isClosed() && connection.isValid(2);
        } catch (SQLException e) {
            return false;
        }
    }

    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Database connection closed");
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Test the connection
    public static void main(String[] args) {
        System.out.println("Testing database connection...");
        DatabaseConnection db = DatabaseConnection.getInstance();

        if (db.isConnected()) {
            System.out.println("✅ Database connection successful!");
            System.out.println("Connection info: " + db.getConnection());
        } else {
            System.out.println("❌ Database connection failed!");
        }
    }
}