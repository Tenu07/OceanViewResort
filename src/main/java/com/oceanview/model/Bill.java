package com.oceanview.model;

import java.util.Date;

public class Bill {
    private int billId;
    private int reservationNo;
    private double totalAmount;
    private double discount;
    private double taxAmount;
    private double finalAmount;
    private String paymentStatus;
    private String paymentMethod;
    private Date billDate;

    // Additional fields
    private String guestName;
    private String roomNumber;
    private int numNights;

    public Bill() {}

    // Getters and Setters
    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getReservationNo() { return reservationNo; }
    public void setReservationNo(int reservationNo) { this.reservationNo = reservationNo; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }

    public double getTaxAmount() { return taxAmount; }
    public void setTaxAmount(double taxAmount) { this.taxAmount = taxAmount; }

    public double getFinalAmount() { return finalAmount; }
    public void setFinalAmount(double finalAmount) { this.finalAmount = finalAmount; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public Date getBillDate() { return billDate; }
    public void setBillDate(Date billDate) { this.billDate = billDate; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public int getNumNights() { return numNights; }
    public void setNumNights(int numNights) { this.numNights = numNights; }
}