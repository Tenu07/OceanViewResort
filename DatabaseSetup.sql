-- ========================================================
-- Ocean View Resort - Database Setup Script
-- Run this script in MySQL to initialize the database.
-- ========================================================

-- Create and select database
CREATE DATABASE IF NOT EXISTS ocean_view_resort CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ocean_view_resort;

-- --------------------------------------------------------
-- Table: room_types
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS room_types (
    type_id    INT AUTO_INCREMENT PRIMARY KEY,
    type_name  VARCHAR(50) NOT NULL,
    base_rate  DECIMAL(10,2) NOT NULL,
    description TEXT
);

INSERT INTO room_types (type_name, base_rate, description) VALUES
    ('Standard',  5000.00, 'Comfortable room with basic amenities, garden view'),
    ('Deluxe',    8000.00, 'Spacious room with premium furnishings and partial ocean view'),
    ('Suite',    15000.00, 'Luxury suite with full ocean view, lounge area and premium facilities')
ON DUPLICATE KEY UPDATE type_name = type_name;

-- --------------------------------------------------------
-- Table: rooms
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS rooms (
    room_id             INT AUTO_INCREMENT PRIMARY KEY,
    room_number         VARCHAR(10) NOT NULL UNIQUE,
    room_type_id        INT NOT NULL,
    rate_per_night      DECIMAL(10,2) NOT NULL,
    availability_status BOOLEAN DEFAULT TRUE,
    floor_number        INT DEFAULT 1,
    FOREIGN KEY (room_type_id) REFERENCES room_types(type_id)
);

INSERT INTO rooms (room_number, room_type_id, rate_per_night, floor_number, availability_status) VALUES
    ('101', 1, 5000.00, 1, TRUE),
    ('102', 1, 5000.00, 1, TRUE),
    ('103', 1, 5200.00, 1, TRUE),
    ('201', 2, 8000.00, 2, TRUE),
    ('202', 2, 8000.00, 2, TRUE),
    ('203', 2, 8500.00, 2, TRUE),
    ('301', 3, 15000.00, 3, TRUE),
    ('302', 3, 15000.00, 3, TRUE),
    ('401', 3, 18000.00, 4, TRUE)
ON DUPLICATE KEY UPDATE room_number = room_number;

-- --------------------------------------------------------
-- Table: users
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id   INT AUTO_INCREMENT PRIMARY KEY,
    username  VARCHAR(50) NOT NULL UNIQUE,
    password  VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role      ENUM('administrator','receptionist','accountant') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Default users: admin/admin123 | receptionist1/rec123 | accountant1/acc123
-- NOTE: Passwords stored as plain text here for demo. Use hashing in production.
INSERT INTO users (username, password, full_name, role) VALUES
    ('admin',        'admin123', 'System Administrator', 'administrator'),
    ('receptionist1','rec123',   'Nimal Perera',        'receptionist'),
    ('receptionist2','rec123',   'Kamala Silva',        'receptionist'),
    ('accountant1',  'acc123',   'Saman Fernando',      'accountant')
ON DUPLICATE KEY UPDATE username = username;

-- --------------------------------------------------------
-- Table: guests
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS guests (
    guest_id   INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    address    TEXT NOT NULL,
    contact_no VARCHAR(15) NOT NULL,
    email      VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO guests (name, address, contact_no, email) VALUES
    ('Anura Kumara',    '45 Galle Road, Colombo 03',        '0711234567', 'anura@example.com'),
    ('Priya Mendis',    '12 Kandy Road, Peradeniya',        '0772345678', 'priya@example.com'),
    ('John Williams',   '8 Marine Drive, Galle',            '0763456789', 'john@example.com'),
    ('Fathima Hussain', '22 Station Road, Pettah, Colombo', '0754567890', 'fathima@example.com')
ON DUPLICATE KEY UPDATE name = name;

-- --------------------------------------------------------
-- Table: reservations
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS reservations (
    reservation_no INT AUTO_INCREMENT PRIMARY KEY,
    guest_id       INT NOT NULL,
    room_id        INT NOT NULL,
    check_in_date  DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status         ENUM('confirmed','checked_in','completed','cancelled') DEFAULT 'confirmed',
    num_guests     INT DEFAULT 1,
    special_requests TEXT,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id)  REFERENCES rooms(room_id)
);

-- --------------------------------------------------------
-- Table: bills
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS bills (
    bill_id        INT AUTO_INCREMENT PRIMARY KEY,
    reservation_no INT NOT NULL,
    total_amount   DECIMAL(10,2) NOT NULL,
    discount       DECIMAL(10,2) DEFAULT 0.00,
    tax_amount     DECIMAL(10,2) DEFAULT 0.00,
    final_amount   DECIMAL(10,2) NOT NULL,
    payment_status ENUM('paid','pending','partial') DEFAULT 'pending',
    payment_method VARCHAR(50) DEFAULT 'cash',
    bill_date      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_no) REFERENCES reservations(reservation_no)
);

-- ========================================================
-- Verification: Show tables and sample data
-- ========================================================
SHOW TABLES;
SELECT CONCAT('Room Types: ', COUNT(*)) AS summary FROM room_types
UNION ALL
SELECT CONCAT('Rooms: ',      COUNT(*)) FROM rooms
UNION ALL
SELECT CONCAT('Users: ',      COUNT(*)) FROM users
UNION ALL
SELECT CONCAT('Guests: ',     COUNT(*)) FROM guests;
