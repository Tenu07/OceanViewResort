package com.oceanview.model;

public class Guest {
    private int guestId;
    private String name;
    private String address;
    private String contactNo;
    private String email;

    public Guest() {}

    public Guest(int guestId, String name, String address, String contactNo, String email) {
        this.guestId = guestId;
        this.name = name;
        this.address = address;
        this.contactNo = contactNo;
        this.email = email;
    }

    // Getters and Setters
    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getContactNo() { return contactNo; }
    public void setContactNo(String contactNo) { this.contactNo = contactNo; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}