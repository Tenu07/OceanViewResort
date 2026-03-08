# 🌊 Ocean View Resort Management System

The **Ocean View Resort Management System** is a Java-based web application designed to manage daily operations of a resort.
The system helps staff efficiently handle **room reservations, guest management, billing, and user roles** through a structured and secure platform.

This project demonstrates the use of **Java Servlets, MVC architecture, and Object-Oriented Programming (OOP)** concepts.

---

## 📌 Features

### 🔐 Authentication System

* Secure login and logout functionality
* Password handling and validation
* Role-based access control

### 👨‍💼 Administrator

* Manage system users
* Monitor system operations
* Administrative control over the resort system

### 🧑‍💻 Receptionist

* Handle guest check-ins and check-outs
* Manage room reservations
* View available rooms

### 💰 Accountant

* Manage guest bills
* Calculate payments
* Maintain financial records

### 🏨 Reservation Management

* Create and manage reservations
* Assign rooms to guests
* Generate reservation numbers automatically

### 🧾 Billing System

* Generate guest bills
* Calculate total charges
* Maintain billing records

---

## 🛠 Technologies Used

* **Java**
* **Java Servlets**
* **JSP (Java Server Pages)**
* **JDBC**
* **MySQL Database**
* **HTML / CSS**
* **MVC Architecture**

---

## 📂 Project Structure

```
OceanViewResort
│
├── src/main/java/com/oceanview
│
│   ├── controller
│   │   ├── LoginServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── AdminServlet.java
│   │   ├── ReceptionistServlet.java
│   │   ├── AccountantServlet.java
│   │   └── ReservationServlet.java
│
│   ├── dao
│   │   ├── UserDAO.java
│   │   ├── RoomDAO.java
│   │   ├── GuestDAO.java
│   │   ├── ReservationDAO.java
│   │   └── BillDAO.java
│
│   ├── model
│   │   ├── User.java
│   │   ├── Guest.java
│   │   ├── Room.java
│   │   ├── Reservation.java
│   │   ├── Bill.java
│   │   └── RoomType.java
│
│   ├── service
│   │   ├── AuthenticationService.java
│   │   ├── BillCalculator.java
│   │   ├── ReservationValidator.java
│   │   └── ReservationNumberGenerator.java
│
│   └── util
│       ├── DatabaseConnection.java
│       └── PasswordUtils.java
│
└── webapp (JSP pages, frontend files)
```

---

## 🚀 How to Run the Project

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-username/OceanViewResort.git
```

### 2️⃣ Open the Project

Open the project using an IDE such as:

* **IntelliJ IDEA**
* **Eclipse**
* **NetBeans**

### 3️⃣ Configure the Database

1. Create a **MySQL database**
2. Import the database schema (if provided)
3. Update the database credentials inside:

```
DatabaseConnection.java
```

Example:

```java
String url = "jdbc:mysql://localhost:3306/oceanviewresort";
String username = "root";
String password = "yourpassword";
```

### 4️⃣ Deploy the Application

Deploy the project on a **Servlet container**, such as:

* Apache Tomcat

### 5️⃣ Run the Application

Start the server and access the application through your browser:

```
http://localhost:8080/OceanViewResort
```

---

## 🎯 Learning Objectives

This project demonstrates:

* Java **MVC architecture**
* **Servlet-based web development**
* **Database integration using JDBC**
* **Role-based system design**
* Clean **object-oriented design patterns**

---

## 👨‍💻 Author

**Tenu Liyansa**

---

## 📜 License

This project is created for **educational purposes** and can be used for learning and academic demonstrations.
