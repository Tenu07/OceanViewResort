package com.oceanview.model;

import java.util.Date;

public class Reservation {
    private int reservationNo;
    private int guestId;
    private int roomId;
    private Date checkInDate;
    private Date checkOutDate;
    private String status;
    private int numGuests;
    private String specialRequests;

    // Additional fields for display
    private String guestName;
    private String roomNumber;
    private double roomRate;

    public Reservation() {}

    // Getters and Setters
    public int getReservationNo() { return reservationNo; }
    public void setReservationNo(int reservationNo) { this.reservationNo = reservationNo; }

    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public Date getCheckInDate() { return checkInDate; }
    public void setCheckInDate(Date checkInDate) { this.checkInDate = checkInDate; }

    public Date getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(Date checkOutDate) { this.checkOutDate = checkOutDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getNumGuests() { return numGuests; }
    public void setNumGuests(int numGuests) { this.numGuests = numGuests; }

    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public double getRoomRate() { return roomRate; }
    public void setRoomRate(double roomRate) { this.roomRate = roomRate; }
}