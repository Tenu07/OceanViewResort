package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public int createReservation(Reservation reservation) {
        String sql = "INSERT INTO reservations (guest_id, room_id, check_in_date, check_out_date, " +
                "status, num_guests, special_requests) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, reservation.getGuestId());
            pstmt.setInt(2, reservation.getRoomId());
            pstmt.setDate(3, new java.sql.Date(reservation.getCheckInDate().getTime()));
            pstmt.setDate(4, new java.sql.Date(reservation.getCheckOutDate().getTime()));
            pstmt.setString(5, reservation.getStatus());
            pstmt.setInt(6, reservation.getNumGuests());
            pstmt.setString(7, reservation.getSpecialRequests());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public Reservation getReservationByNo(int reservationNo) {
        String sql = "SELECT r.*, g.name as guest_name, rm.room_number, rm.rate_per_night " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE r.reservation_no = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationNo);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, g.name as guest_name, rm.room_number, rm.rate_per_night " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "ORDER BY r.created_at DESC";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public List<Reservation> getReservationsByGuestId(int guestId) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, g.name as guest_name, rm.room_number, rm.rate_per_night " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE r.guest_id = ? " +
                "ORDER BY r.created_at DESC";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, guestId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public boolean updateReservationStatus(int reservationNo, String status) {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_no = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, reservationNo);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelReservation(int reservationNo) {
        return updateReservationStatus(reservationNo, "cancelled");
    }

    public boolean updateReservationDates(int reservationNo, java.util.Date checkInDate, java.util.Date checkOutDate) {
        String sql = "UPDATE reservations SET check_in_date = ?, check_out_date = ? WHERE reservation_no = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, new java.sql.Date(checkInDate.getTime()));
            pstmt.setDate(2, new java.sql.Date(checkOutDate.getTime()));
            pstmt.setInt(3, reservationNo);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setReservationNo(rs.getInt("reservation_no"));
        reservation.setGuestId(rs.getInt("guest_id"));
        reservation.setRoomId(rs.getInt("room_id"));
        reservation.setCheckInDate(rs.getDate("check_in_date"));
        reservation.setCheckOutDate(rs.getDate("check_out_date"));
        reservation.setStatus(rs.getString("status"));
        reservation.setNumGuests(rs.getInt("num_guests"));
        reservation.setSpecialRequests(rs.getString("special_requests"));
        reservation.setGuestName(rs.getString("guest_name"));
        reservation.setRoomNumber(rs.getString("room_number"));
        reservation.setRoomRate(rs.getDouble("rate_per_night"));
        return reservation;
    }
}