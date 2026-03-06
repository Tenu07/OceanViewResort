package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.model.*;
import com.oceanview.service.ReservationValidator;
import com.oceanview.service.BillCalculator;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/reservation/*")
public class ReservationServlet extends HttpServlet {
    private GuestDAO guestDAO;
    private RoomDAO roomDAO;
    private ReservationDAO reservationDAO;
    private BillDAO billDAO;
    private ReservationValidator validator;
    private BillCalculator billCalculator;

    @Override
    public void init() {
        guestDAO = new GuestDAO();
        roomDAO = new RoomDAO();
        reservationDAO = new ReservationDAO();
        billDAO = new BillDAO();
        validator = new ReservationValidator();
        billCalculator = new BillCalculator();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getPathInfo();

        if (path == null || path.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
        } else if (path.equals("/check-availability")) {
            checkAvailability(request, response);
        } else if (path.equals("/view")) {
            viewReservation(request, response);
        } else if (path.equals("/search")) {
            searchReservations(request, response);
        } else if (path.equals("/cancel")) {
            cancelReservation(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getPathInfo();
        if (path == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (path.equals("/create")) {
            createReservation(request, response);
        } else if (path.equals("/update")) {
            updateReservation(request, response);
        } else if (path.equals("/calculate-bill")) {
            calculateBill(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Check room availability for given dates — returns JSON
     */
    private void checkAvailability(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String checkInStr = request.getParameter("checkInDate");
            String checkOutStr = request.getParameter("checkOutDate");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date checkInDate = sdf.parse(checkInStr);
            Date checkOutDate = sdf.parse(checkOutStr);

            if (!validator.validateDates(checkInDate, checkOutDate)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"error\": \"Invalid dates\"}");
                return;
            }

            List<Room> availableRooms = roomDAO.getAvailableRooms(checkInDate, checkOutDate);

            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < availableRooms.size(); i++) {
                Room room = availableRooms.get(i);
                json.append("{");
                json.append("\"roomId\":").append(room.getRoomId()).append(",");
                json.append("\"roomNumber\":\"").append(room.getRoomNumber()).append("\",");
                json.append("\"roomType\":\"").append(room.getRoomTypeName()).append("\",");
                json.append("\"ratePerNight\":").append(room.getRatePerNight()).append(",");
                json.append("\"floorNumber\":").append(room.getFloorNumber());
                json.append("}");
                if (i < availableRooms.size() - 1)
                    json.append(",");
            }
            json.append("]");

            response.setContentType("application/json");
            response.getWriter().write(json.toString());

        } catch (ParseException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Date parsing error\"}");
        }
    }

    /**
     * Create a new reservation
     */
    private void createReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String guestIdStr = request.getParameter("guestId");
            String roomIdStr = request.getParameter("roomId");
            String checkInStr = request.getParameter("checkInDate");
            String checkOutStr = request.getParameter("checkOutDate");
            String numGuestsStr = request.getParameter("numGuests");
            String specialRequests = request.getParameter("specialRequests");

            if (guestIdStr == null || guestIdStr.isEmpty() ||
                    roomIdStr == null || roomIdStr.isEmpty() ||
                    checkInStr == null || checkInStr.isEmpty() ||
                    checkOutStr == null || checkOutStr.isEmpty()) {
                request.setAttribute("error", "All required fields must be filled.");
                forwardToAddPage(request, response);
                return;
            }

            int guestId = Integer.parseInt(guestIdStr);
            int roomId = Integer.parseInt(roomIdStr);
            int numGuests = (numGuestsStr != null && !numGuestsStr.isEmpty()) ? Integer.parseInt(numGuestsStr) : 1;

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date checkInDate = sdf.parse(checkInStr);
            Date checkOutDate = sdf.parse(checkOutStr);

            if (!validator.validateDates(checkInDate, checkOutDate)) {
                request.setAttribute("error", "Invalid dates. Check-in must be today or future and before check-out.");
                forwardToAddPage(request, response);
                return;
            }

            if (!validator.validateAvailability(roomId, checkInDate, checkOutDate)) {
                request.setAttribute("error", "Selected room is not available for those dates.");
                forwardToAddPage(request, response);
                return;
            }

            Reservation reservation = new Reservation();
            reservation.setGuestId(guestId);
            reservation.setRoomId(roomId);
            reservation.setCheckInDate(checkInDate);
            reservation.setCheckOutDate(checkOutDate);
            reservation.setStatus("confirmed");
            reservation.setNumGuests(numGuests);
            reservation.setSpecialRequests(specialRequests);

            int reservationNo = reservationDAO.createReservation(reservation);

            if (reservationNo > 0) {
                roomDAO.updateRoomStatus(roomId, false);
                request.setAttribute("success", "✅ Reservation created! Reservation Number: " + reservationNo);
                request.setAttribute("reservationNo", reservationNo);
            } else {
                request.setAttribute("error", "Failed to create reservation. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating reservation: " + e.getMessage());
        }

        forwardToAddPage(request, response);
    }

    /**
     * View reservation details
     */
    private void viewReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reservationNoStr = request.getParameter("reservationNo");

        if (reservationNoStr != null && !reservationNoStr.isEmpty()) {
            try {
                int reservationNo = Integer.parseInt(reservationNoStr);
                Reservation reservation = reservationDAO.getReservationByNo(reservationNo);

                if (reservation != null) {
                    request.setAttribute("reservation", reservation);
                    Bill bill = billDAO.getBillByReservationNo(reservationNo);
                    if (bill != null) {
                        request.setAttribute("bill", bill);
                    }
                } else {
                    request.setAttribute("error", "No reservation found with number: " + reservationNo);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid reservation number format.");
            }
        }

        request.getRequestDispatcher("/receptionist/viewReservation.jsp").forward(request, response);
    }

    /**
     * Update existing reservation
     */
    private void updateReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int reservationNo = Integer.parseInt(request.getParameter("reservationNo"));
            String checkInStr = request.getParameter("checkInDate");
            String checkOutStr = request.getParameter("checkOutDate");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date checkInDate = sdf.parse(checkInStr);
            Date checkOutDate = sdf.parse(checkOutStr);

            Reservation reservation = reservationDAO.getReservationByNo(reservationNo);

            if (reservation == null) {
                request.setAttribute("error", "Reservation not found.");
                viewReservation(request, response);
                return;
            }

            if (!validator.validateDates(checkInDate, checkOutDate)) {
                request.setAttribute("error", "Invalid dates provided.");
                viewReservation(request, response);
                return;
            }

            // Update via status; full update would require extra DAO method
            boolean updated = reservationDAO.updateReservationDates(reservationNo, checkInDate, checkOutDate);
            if (updated) {
                request.setAttribute("success", "Reservation details updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update reservation. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating reservation: " + e.getMessage());
        }

        viewReservation(request, response);
    }

    /**
     * Cancel reservation
     */
    private void cancelReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reservationNoStr = request.getParameter("reservationNo");

        if (reservationNoStr != null && !reservationNoStr.isEmpty()) {
            try {
                int reservationNo = Integer.parseInt(reservationNoStr);
                Reservation reservation = reservationDAO.getReservationByNo(reservationNo);

                if (reservation != null) {
                    boolean cancelled = reservationDAO.cancelReservation(reservationNo);
                    if (cancelled) {
                        roomDAO.updateRoomStatus(reservation.getRoomId(), true);
                        request.setAttribute("success", "Reservation #" + reservationNo + " cancelled successfully.");
                    } else {
                        request.setAttribute("error", "Failed to cancel the reservation.");
                    }
                } else {
                    request.setAttribute("error", "Reservation not found.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid reservation number.");
            }
        }

        viewReservation(request, response);
    }

    /**
     * Search reservations by guest name or reservation number
     */
    private void searchReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchTerm = request.getParameter("searchTerm");
        List<Reservation> results = reservationDAO.getAllReservations();

        if (searchTerm != null && !searchTerm.isEmpty()) {
            final String term = searchTerm.toLowerCase().trim();
            results.removeIf(r -> !String.valueOf(r.getReservationNo()).contains(term) &&
                    (r.getGuestName() == null || !r.getGuestName().toLowerCase().contains(term)));
        }

        request.setAttribute("reservations", results);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("/receptionist/searchResults.jsp").forward(request, response);
    }

    /**
     * Calculate bill for a reservation
     */
    private void calculateBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String reservationNoStr = request.getParameter("reservationNo");
            String discountStr = request.getParameter("discount");
            String paymentMethod = request.getParameter("paymentMethod");

            if (reservationNoStr == null || reservationNoStr.isEmpty()) {
                request.setAttribute("error", "Reservation number is required.");
                request.getRequestDispatcher("/receptionist/calculateBill.jsp").forward(request, response);
                return;
            }

            int reservationNo = Integer.parseInt(reservationNoStr);
            double discount = (discountStr != null && !discountStr.isEmpty()) ? Double.parseDouble(discountStr) : 0.0;

            Reservation reservation = reservationDAO.getReservationByNo(reservationNo);

            if (reservation == null) {
                request.setAttribute("error", "Reservation #" + reservationNo + " not found.");
                request.getRequestDispatcher("/receptionist/calculateBill.jsp").forward(request, response);
                return;
            }

            // Check if bill already exists
            Bill existingBill = billDAO.getBillByReservationNo(reservationNo);
            if (existingBill != null) {
                existingBill.setGuestName(reservation.getGuestName());
                existingBill.setRoomNumber(reservation.getRoomNumber());
                request.setAttribute("bill", existingBill);
                request.setAttribute("reservation", reservation);
                request.setAttribute("info", "Bill already generated for this reservation.");
                request.getRequestDispatcher("/receptionist/calculateBill.jsp").forward(request, response);
                return;
            }

            Bill bill = billCalculator.calculateBill(reservation, discount);
            bill.setPaymentMethod(paymentMethod != null ? paymentMethod : "cash");
            bill.setPaymentStatus("paid");

            int billId = billDAO.createBill(bill);

            if (billId > 0) {
                bill.setBillId(billId);
                bill.setGuestName(reservation.getGuestName());
                bill.setRoomNumber(reservation.getRoomNumber());
                request.setAttribute("bill", bill);
                request.setAttribute("reservation", reservation);
                request.setAttribute("success", "✅ Bill generated successfully!");
                reservationDAO.updateReservationStatus(reservationNo, "completed");
            } else {
                request.setAttribute("error", "Failed to generate bill. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error calculating bill: " + e.getMessage());
        }

        request.getRequestDispatcher("/receptionist/calculateBill.jsp").forward(request, response);
    }

    /**
     * Helper: load guests and forward to add reservation page
     */
    private void forwardToAddPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Guest> guests = guestDAO.getAllGuests();
        request.setAttribute("guests", guests);
        request.getRequestDispatcher("/receptionist/addReservation.jsp").forward(request, response);
    }
}