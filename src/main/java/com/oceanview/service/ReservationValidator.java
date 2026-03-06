package com.oceanview.service;

import com.oceanview.dao.RoomDAO;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class ReservationValidator {
    private RoomDAO roomDAO;

    public ReservationValidator() {
        this.roomDAO = new RoomDAO();
    }

    public boolean validateDates(Date checkIn, Date checkOut) {
        if (checkIn == null || checkOut == null) {
            return false;
        }

        // Check-in must be before check-out
        if (checkIn.after(checkOut) || checkIn.equals(checkOut)) {
            return false;
        }

        // Check-in must be today or in future
        Date today = new Date();
        if (checkIn.before(today)) {
            return false;
        }

        return true;
    }

    public boolean validateAvailability(int roomId, Date checkIn, Date checkOut) {
        return roomDAO.isRoomAvailable(roomId, checkIn, checkOut);
    }

    public int calculateNights(Date checkIn, Date checkOut) {
        long diffInMillies = Math.abs(checkOut.getTime() - checkIn.getTime());
        return (int) TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
    }
}