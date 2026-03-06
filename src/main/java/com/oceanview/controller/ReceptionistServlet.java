package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.model.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {
        "/receptionist/dashboard",
        "/receptionist/add-reservation",
        "/receptionist/view-reservation",
        "/receptionist/calculate-bill",
        "/receptionist/search"
})
public class ReceptionistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private GuestDAO guestDAO;
    private RoomDAO roomDAO;
    private ReservationDAO reservationDAO;
    private BillDAO billDAO;

    @Override
    public void init() {
        guestDAO = new GuestDAO();
        roomDAO = new RoomDAO();
        reservationDAO = new ReservationDAO();
        billDAO = new BillDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!"receptionist".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        if ("/receptionist/dashboard".equals(path)) {
            showDashboard(request, response);
        } else if ("/receptionist/add-reservation".equals(path)) {
            showAddReservation(request, response);
        } else if ("/receptionist/view-reservation".equals(path)) {
            showViewReservation(request, response);
        } else if ("/receptionist/calculate-bill".equals(path)) {
            showCalculateBill(request, response);
        } else if ("/receptionist/search".equals(path)) {
            showSearch(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null || !"receptionist".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String action = request.getParameter("action");

        if ("/receptionist/add-reservation".equals(path)) {
            if ("add-guest".equals(action)) {
                addGuest(request, response);
            } else {
                showAddReservation(request, response);
            }
        } else if ("/receptionist/view-reservation".equals(path)) {
            // Handle update form from viewReservation.jsp
            showViewReservation(request, response);
        } else if ("/receptionist/calculate-bill".equals(path)) {
            // Handle reservation number lookup before generating bill
            showCalculateBill(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Room> rooms = roomDAO.getAllRooms();
            List<Reservation> reservations = reservationDAO.getAllReservations();
            List<Guest> guests = guestDAO.getAllGuests();

            long availableRooms = rooms.stream().filter(Room::isAvailabilityStatus).count();
            long confirmedReservations = reservations.stream()
                    .filter(r -> "confirmed".equals(r.getStatus())).count();
            long todayCheckIns = reservations.stream().filter(r -> {
                if (r.getCheckInDate() == null)
                    return false;
                java.util.Calendar today = java.util.Calendar.getInstance();
                java.util.Calendar checkIn = java.util.Calendar.getInstance();
                checkIn.setTime(r.getCheckInDate());
                return today.get(java.util.Calendar.DAY_OF_YEAR) == checkIn.get(java.util.Calendar.DAY_OF_YEAR)
                        && today.get(java.util.Calendar.YEAR) == checkIn.get(java.util.Calendar.YEAR);
            }).count();

            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("confirmedReservations", confirmedReservations);
            request.setAttribute("todayCheckIns", todayCheckIns);
            request.setAttribute("totalGuests", guests.size());
            request.setAttribute("recentReservations",
                    reservations.size() > 5 ? reservations.subList(0, 5) : reservations);

        } catch (Exception e) {
            System.err.println("Error loading receptionist dashboard: " + e.getMessage());
            request.setAttribute("availableRooms", 0);
            request.setAttribute("confirmedReservations", 0);
            request.setAttribute("todayCheckIns", 0);
            request.setAttribute("totalGuests", 0);
        }
        request.getRequestDispatcher("/receptionist/dashboard.jsp").forward(request, response);
    }

    private void showAddReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Guest> guests = guestDAO.getAllGuests();
            request.setAttribute("guests", guests);
        } catch (Exception e) {
            System.err.println("Error loading guests: " + e.getMessage());
            request.setAttribute("error", "Failed to load guest list: " + e.getMessage());
        }
        request.getRequestDispatcher("/receptionist/addReservation.jsp").forward(request, response);
    }

    private void showViewReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reservationNoStr = request.getParameter("reservationNo");
        if (reservationNoStr != null && !reservationNoStr.isEmpty()) {
            try {
                int reservationNo = Integer.parseInt(reservationNoStr);
                Reservation reservation = reservationDAO.getReservationByNo(reservationNo);
                if (reservation != null) {
                    request.setAttribute("reservation", reservation);
                    Bill bill = billDAO.getBillByReservationNo(reservationNo);
                    if (bill != null)
                        request.setAttribute("bill", bill);
                } else {
                    request.setAttribute("error", "Reservation #" + reservationNo + " not found.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid reservation number.");
            }
        }
        request.getRequestDispatcher("/receptionist/viewReservation.jsp").forward(request, response);
    }

    private void showCalculateBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reservationNoStr = request.getParameter("reservationNo");
        if (reservationNoStr != null && !reservationNoStr.isEmpty()) {
            try {
                int reservationNo = Integer.parseInt(reservationNoStr);
                Reservation reservation = reservationDAO.getReservationByNo(reservationNo);
                if (reservation != null) {
                    request.setAttribute("reservation", reservation);
                    Bill existingBill = billDAO.getBillByReservationNo(reservationNo);
                    if (existingBill != null) {
                        existingBill.setGuestName(reservation.getGuestName());
                        existingBill.setRoomNumber(reservation.getRoomNumber());
                        request.setAttribute("bill", existingBill);
                        request.setAttribute("info", "A bill has already been generated for this reservation.");
                    }
                } else {
                    request.setAttribute("error", "Reservation #" + reservationNo + " not found.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid reservation number.");
            }
        }
        request.getRequestDispatcher("/receptionist/calculateBill.jsp").forward(request, response);
    }

    private void showSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("searchTerm");
        if (searchTerm != null && !searchTerm.isEmpty()) {
            try {
                List<Reservation> results = reservationDAO.getAllReservations();
                final String term = searchTerm.toLowerCase().trim();
                results.removeIf(r -> !String.valueOf(r.getReservationNo()).contains(term) &&
                        (r.getGuestName() == null || !r.getGuestName().toLowerCase().contains(term)));
                request.setAttribute("reservations", results);
                request.setAttribute("searchTerm", searchTerm);
            } catch (Exception e) {
                request.setAttribute("error", "Search error: " + e.getMessage());
            }
        }
        request.getRequestDispatcher("/receptionist/searchResults.jsp").forward(request, response);
    }

    private void addGuest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("guestName");
            String address = request.getParameter("guestAddress");
            String contactNo = request.getParameter("guestContact");
            String email = request.getParameter("guestEmail");

            if (name == null || name.trim().isEmpty() ||
                    address == null || address.trim().isEmpty() ||
                    contactNo == null || contactNo.trim().isEmpty()) {
                request.setAttribute("error", "Name, address, and contact number are required.");
            } else {
                Guest guest = new Guest();
                guest.setName(name.trim());
                guest.setAddress(address.trim());
                guest.setContactNo(contactNo.trim());
                guest.setEmail(email != null ? email.trim() : "");

                int guestId = guestDAO.addGuest(guest);
                if (guestId > 0) {
                    request.setAttribute("success",
                            "Guest '" + name + "' registered successfully! (Guest ID: " + guestId + ")");
                    request.setAttribute("newGuestId", guestId);
                } else {
                    request.setAttribute("error", "Failed to register guest.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error registering guest: " + e.getMessage());
        }
        showAddReservation(request, response);
    }
}