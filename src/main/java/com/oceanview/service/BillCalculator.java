package com.oceanview.service;

import com.oceanview.model.Bill;
import com.oceanview.model.Reservation;

public class BillCalculator {
    private static final double TAX_RATE = 0.10; // 10% tax

    public Bill calculateBill(Reservation reservation, double discount) {
        Bill bill = new Bill();

        // Calculate number of nights
        ReservationValidator validator = new ReservationValidator();
        int nights = validator.calculateNights(
                reservation.getCheckInDate(),
                reservation.getCheckOutDate()
        );

        // Calculate total amount
        double roomTotal = reservation.getRoomRate() * nights;
        double taxAmount = roomTotal * TAX_RATE;
        double totalAmount = roomTotal + taxAmount;
        double discountAmount = totalAmount * (discount / 100);
        double finalAmount = totalAmount - discountAmount;

        bill.setReservationNo(reservation.getReservationNo());
        bill.setTotalAmount(roomTotal);
        bill.setDiscount(discountAmount);
        bill.setTaxAmount(taxAmount);
        bill.setFinalAmount(finalAmount);
        bill.setNumNights(nights);

        return bill;
    }

    public Bill applyDiscount(Bill bill, double discountPercent) {
        double currentFinal = bill.getFinalAmount();
        double discountAmount = currentFinal * (discountPercent / 100);
        bill.setFinalAmount(currentFinal - discountAmount);
        bill.setDiscount(bill.getDiscount() + discountAmount);
        return bill;
    }
}