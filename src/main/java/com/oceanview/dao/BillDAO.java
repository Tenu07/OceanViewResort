package com.oceanview.dao;

import com.oceanview.model.Bill;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    public int createBill(Bill bill) {
        String sql = "INSERT INTO bills (reservation_no, total_amount, discount, tax_amount, " +
                "final_amount, payment_status, payment_method) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, bill.getReservationNo());
            pstmt.setDouble(2, bill.getTotalAmount());
            pstmt.setDouble(3, bill.getDiscount());
            pstmt.setDouble(4, bill.getTaxAmount());
            pstmt.setDouble(5, bill.getFinalAmount());
            pstmt.setString(6, bill.getPaymentStatus());
            pstmt.setString(7, bill.getPaymentMethod());

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

    public Bill getBillById(int billId) {
        String sql = "SELECT b.*, r.guest_id, g.name as guest_name, rm.room_number, " +
                "DATEDIFF(r.check_out_date, r.check_in_date) as num_nights " +
                "FROM bills b " +
                "JOIN reservations r ON b.reservation_no = r.reservation_no " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE b.bill_id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, billId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToBill(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Bill getBillByReservationNo(int reservationNo) {
        String sql = "SELECT b.*, r.guest_id, g.name as guest_name, rm.room_number, " +
                "DATEDIFF(r.check_out_date, r.check_in_date) as num_nights " +
                "FROM bills b " +
                "JOIN reservations r ON b.reservation_no = r.reservation_no " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE b.reservation_no = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationNo);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToBill(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, r.guest_id, g.name as guest_name, rm.room_number, " +
                "DATEDIFF(r.check_out_date, r.check_in_date) as num_nights " +
                "FROM bills b " +
                "JOIN reservations r ON b.reservation_no = r.reservation_no " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "ORDER BY b.bill_date DESC";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                bills.add(mapResultSetToBill(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }

    public boolean updatePaymentStatus(int billId, String status, String paymentMethod) {
        String sql = "UPDATE bills SET payment_status = ?, payment_method = ? WHERE bill_id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, paymentMethod);
            pstmt.setInt(3, billId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Bill mapResultSetToBill(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setReservationNo(rs.getInt("reservation_no"));
        bill.setTotalAmount(rs.getDouble("total_amount"));
        bill.setDiscount(rs.getDouble("discount"));
        bill.setTaxAmount(rs.getDouble("tax_amount"));
        bill.setFinalAmount(rs.getDouble("final_amount"));
        bill.setPaymentStatus(rs.getString("payment_status"));
        bill.setPaymentMethod(rs.getString("payment_method"));
        bill.setBillDate(rs.getTimestamp("bill_date"));
        bill.setGuestName(rs.getString("guest_name"));
        bill.setRoomNumber(rs.getString("room_number"));
        bill.setNumNights(rs.getInt("num_nights"));
        return bill;
    }
}