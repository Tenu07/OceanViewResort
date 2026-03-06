package com.oceanview.dao;

import com.oceanview.model.Room;
import com.oceanview.model.RoomType;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

public class RoomDAO {

    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name FROM rooms r " +
                "JOIN room_types rt ON r.room_type_id = rt.type_id " +
                "ORDER BY r.room_number";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                rooms.add(mapRoom(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public List<RoomType> getAllRoomTypes() {
        List<RoomType> types = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY type_name";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setTypeId(rs.getInt("type_id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setBaseRate(rs.getDouble("base_rate"));
                rt.setDescription(rs.getString("description"));
                types.add(rt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return types;
    }

    public List<Room> getAvailableRooms(Date checkIn, Date checkOut) {
        List<Room> availableRooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name FROM rooms r " +
                "JOIN room_types rt ON r.room_type_id = rt.type_id " +
                "WHERE r.room_id NOT IN (" +
                "   SELECT room_id FROM reservations " +
                "   WHERE status != 'cancelled' " +
                "   AND ((check_in_date BETWEEN ? AND ?) " +
                "        OR (check_out_date BETWEEN ? AND ?) " +
                "        OR (check_in_date <= ? AND check_out_date >= ?)))";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, new java.sql.Date(checkIn.getTime()));
            pstmt.setDate(2, new java.sql.Date(checkOut.getTime()));
            pstmt.setDate(3, new java.sql.Date(checkIn.getTime()));
            pstmt.setDate(4, new java.sql.Date(checkOut.getTime()));
            pstmt.setDate(5, new java.sql.Date(checkIn.getTime()));
            pstmt.setDate(6, new java.sql.Date(checkOut.getTime()));
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Room room = mapRoom(rs);
                room.setAvailabilityStatus(true);
                availableRooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return availableRooms;
    }

    public boolean isRoomAvailable(int roomId, Date checkIn, Date checkOut) {
        String sql = "SELECT COUNT(*) FROM reservations " +
                "WHERE room_id = ? AND status != 'cancelled' " +
                "AND ((check_in_date BETWEEN ? AND ?) " +
                "     OR (check_out_date BETWEEN ? AND ?) " +
                "     OR (check_in_date <= ? AND check_out_date >= ?))";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            pstmt.setDate(2, new java.sql.Date(checkIn.getTime()));
            pstmt.setDate(3, new java.sql.Date(checkOut.getTime()));
            pstmt.setDate(4, new java.sql.Date(checkIn.getTime()));
            pstmt.setDate(5, new java.sql.Date(checkOut.getTime()));
            pstmt.setDate(6, new java.sql.Date(checkIn.getTime()));
            pstmt.setDate(7, new java.sql.Date(checkOut.getTime()));
            ResultSet rs = pstmt.executeQuery();
            if (rs.next())
                return rs.getInt(1) == 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRoomStatus(int roomId, boolean available) {
        String sql = "UPDATE rooms SET availability_status = ? WHERE room_id = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBoolean(1, available);
            pstmt.setInt(2, roomId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addRoom(Room room) {
        String sql = "INSERT INTO rooms (room_number, room_type_id, rate_per_night, floor_number, availability_status) "
                +
                "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, room.getRoomNumber());
            pstmt.setInt(2, room.getRoomTypeId());
            pstmt.setDouble(3, room.getRatePerNight());
            pstmt.setInt(4, room.getFloorNumber());
            pstmt.setBoolean(5, room.isAvailabilityStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding room: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting room: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Room getRoomById(int roomId) {
        String sql = "SELECT r.*, rt.type_name FROM rooms r " +
                "JOIN room_types rt ON r.room_type_id = rt.type_id " +
                "WHERE r.room_id = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next())
                return mapRoom(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Room mapRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomTypeId(rs.getInt("room_type_id"));
        room.setRoomTypeName(rs.getString("type_name"));
        room.setRatePerNight(rs.getDouble("rate_per_night"));
        room.setAvailabilityStatus(rs.getBoolean("availability_status"));
        room.setFloorNumber(rs.getInt("floor_number"));
        return room;
    }
}