package com.oceanview.dao;

import com.oceanview.model.Guest;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuestDAO {

    public int addGuest(Guest guest) {
        String sql = "INSERT INTO guests (name, address, contact_no, email) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, guest.getName());
            pstmt.setString(2, guest.getAddress());
            pstmt.setString(3, guest.getContactNo());
            pstmt.setString(4, guest.getEmail());

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

    public Guest getGuestById(int guestId) {
        String sql = "SELECT * FROM guests WHERE guest_id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, guestId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Guest guest = new Guest();
                guest.setGuestId(rs.getInt("guest_id"));
                guest.setName(rs.getString("name"));
                guest.setAddress(rs.getString("address"));
                guest.setContactNo(rs.getString("contact_no"));
                guest.setEmail(rs.getString("email"));
                return guest;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Guest> getAllGuests() {
        List<Guest> guests = new ArrayList<>();
        String sql = "SELECT * FROM guests ORDER BY guest_id DESC";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Guest guest = new Guest();
                guest.setGuestId(rs.getInt("guest_id"));
                guest.setName(rs.getString("name"));
                guest.setAddress(rs.getString("address"));
                guest.setContactNo(rs.getString("contact_no"));
                guest.setEmail(rs.getString("email"));
                guests.add(guest);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guests;
    }

    public boolean updateGuest(Guest guest) {
        String sql = "UPDATE guests SET name = ?, address = ?, contact_no = ?, email = ? WHERE guest_id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, guest.getName());
            pstmt.setString(2, guest.getAddress());
            pstmt.setString(3, guest.getContactNo());
            pstmt.setString(4, guest.getEmail());
            pstmt.setInt(5, guest.getGuestId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}