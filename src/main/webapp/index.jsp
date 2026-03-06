<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            text-align: center;
            padding: 50px 0;
            color: white;
        }

        .header h1 {
            font-size: 3.5em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .header p {
            font-size: 1.3em;
            opacity: 0.95;
        }

        .role-selection {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin: 30px 0;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .role-selection h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .role-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 1px solid #e2e8f0;
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .card .icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }

        .card h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 1.8rem;
        }

        .card p {
            color: #666;
            margin-bottom: 25px;
            min-height: 60px;
        }

        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
        }

        .help-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-top: 30px;
            text-align: center;
        }

        .help-section h3 {
            color: #333;
            margin-bottom: 15px;
        }

        .help-section a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .help-section a:hover {
            text-decoration: underline;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 30px;
            border-radius: 20px;
            width: 90%;
            max-width: 600px;
            position: relative;
        }

        .close {
            position: absolute;
            right: 25px;
            top: 15px;
            font-size: 28px;
            font-weight: bold;
            color: #999;
            cursor: pointer;
        }

        .close:hover {
            color: #f56565;
        }

        .help-content {
            padding: 20px;
        }

        .help-content h3 {
            color: #667eea;
            margin: 20px 0 10px;
        }

        .help-content ul {
            list-style: none;
            padding-left: 20px;
        }

        .help-content li {
            margin-bottom: 10px;
            position: relative;
        }

        .help-content li:before {
            content: "•";
            color: #667eea;
            font-weight: bold;
            position: absolute;
            left: -15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🌊 Ocean View Resort</h1>
            <p>Galle's Premier Beachside Hotel</p>
        </div>

        <div class="role-selection">
            <h2>Select Your Role to Login</h2>

            <div class="role-cards">
                <!-- Receptionist Card -->
                <div class="card">
                    <div class="icon">👨‍💼</div>
                    <h3>Receptionist</h3>
                    <p>Manage reservations, check-ins, and guest services</p>
                    <a href="${pageContext.request.contextPath}/login?role=receptionist" class="btn">Login as Receptionist</a>
                </div>

                <!-- Administrator Card -->
                <div class="card">
                    <div class="icon">👑</div>
                    <h3>Administrator</h3>
                    <p>Manage rooms, users, and system settings</p>
                    <a href="${pageContext.request.contextPath}/login?role=admin" class="btn">Login as Admin</a>
                </div>

                <!-- Accountant Card -->
                <div class="card">
                    <div class="icon">💰</div>
                    <h3>Accountant</h3>
                    <p>View bills, revenue reports, and payment tracking</p>
                    <a href="${pageContext.request.contextPath}/login?role=accountant" class="btn">Login as Accountant</a>
                </div>
            </div>
        </div>

        <div class="help-section">
            <h3>📘 New Staff Member?</h3>
            <p>Check our <a href="#" onclick="showHelp()">Help Section</a> for guidelines on using the system.</p>
        </div>
    </div>

    <!-- Help Modal -->
    <div id="helpModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeHelp()">&times;</span>
            <h2>System Guidelines</h2>
            <div class="help-content">
                <h3>For Receptionists:</h3>
                <ul>
                    <li>Use "Add New Reservation" to book rooms for guests</li>
                    <li>Always verify guest details before creating reservation</li>
                    <li>Check room availability before confirming booking</li>
                    <li>Generate bills at check-out time</li>
                </ul>

                <h3>For Administrators:</h3>
                <ul>
                    <li>Manage room details and rates</li>
                    <li>Add or remove user accounts</li>
                    <li>View system usage reports</li>
                </ul>

                <h3>For Accountants:</h3>
                <ul>
                    <li>View all bills and payment status</li>
                    <li>Generate monthly revenue reports</li>
                    <li>Track pending payments</li>
                </ul>

                <h3>Demo Credentials:</h3>
                <ul>
                    <li><strong>Admin:</strong> username: admin, password: admin123</li>
                    <li><strong>Receptionist:</strong> username: receptionist1, password: rec123</li>
                    <li><strong>Accountant:</strong> username: accountant1, password: acc123</li>
                </ul>
            </div>
        </div>
    </div>

    <script>
        function showHelp() {
            document.getElementById('helpModal').style.display = 'block';
        }

        function closeHelp() {
            document.getElementById('helpModal').style.display = 'none';
        }

        window.onclick = function(event) {
            var modal = document.getElementById('helpModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
</html>