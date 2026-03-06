<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Guest" %>
            <%@ page import="java.util.List" %>
                <% User user=(User) session.getAttribute("user"); if (user==null ||
                    !"receptionist".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"
                    ); return; } List<Guest> guests = (List<Guest>) request.getAttribute("guests");
                        String error = (String) request.getAttribute("error");
                        String success = (String) request.getAttribute("success");
                        Integer newGuestId = (Integer) request.getAttribute("newGuestId");
                        Integer confirmedResNo = (Integer) request.getAttribute("reservationNo");
                        %>
                        <!DOCTYPE html>
                        <html>

                        <head>
                            <meta charset="UTF-8">
                            <title>New Reservation - Ocean View Resort</title>
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                            <style>
                                .room-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                                    gap: 15px;
                                    margin: 15px 0;
                                }

                                .room-card {
                                    border: 2px solid var(--border-color, #ddd);
                                    border-radius: 10px;
                                    padding: 15px;
                                    cursor: pointer;
                                    transition: all .3s;
                                }

                                .room-card:hover {
                                    border-color: #667eea;
                                    transform: translateY(-2px);
                                    box-shadow: 0 4px 15px rgba(0, 0, 0, .1);
                                }

                                .room-card.selected {
                                    border-color: #48bb78;
                                    background: #f0fff4;
                                }

                                .room-card h4 {
                                    margin: 0 0 8px;
                                    color: #2d3748;
                                }

                                .room-card .price {
                                    font-size: 1.1rem;
                                    color: #667eea;
                                    font-weight: 700;
                                }

                                .room-card .type {
                                    color: #718096;
                                    font-size: .9rem;
                                }

                                .step-card {
                                    background: #fff;
                                    border-radius: 15px;
                                    padding: 25px;
                                    margin-bottom: 20px;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, .05);
                                }

                                .step-card h3 {
                                    color: #667eea;
                                    margin-bottom: 20px;
                                    padding-bottom: 10px;
                                    border-bottom: 2px solid #e9ecef;
                                }
                            </style>
                        </head>

                        <body>
                            <div class="dashboard">
                                <div class="sidebar">
                                    <div class="sidebar-header">
                                        <h3>🌊 Ocean View Resort</h3>
                                        <p>Welcome, <%= user.getFullName() !=null ? user.getFullName() :
                                                user.getUsername() %>
                                        </p>
                                        <p><small>Receptionist</small></p>
                                    </div>
                                    <ul class="nav-menu">
                                        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard">📊
                                                Dashboard</a></li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/add-reservation"
                                                class="active">➕ New Reservation</a></li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/view-reservation">🔍
                                                View Reservation</a></li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/calculate-bill">💰
                                                Calculate Bill</a></li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/search">🔎
                                                Search</a></li>
                                        <li><a href="${pageContext.request.contextPath}/logout">🚪 Logout</a></li>
                                    </ul>
                                </div>

                                <div class="main-content">
                                    <div class="header">
                                        <h2>Create New Reservation</h2>
                                    </div>

                                    <% if (error !=null) { %>
                                        <div class="error-message">
                                            <%= error %>
                                        </div>
                                        <% } %>
                                            <% if (success !=null) { %>
                                                <div class="success-message">
                                                    <%= success %>
                                                </div>
                                                <% } %>

                                                    <!-- Step 1: Guest -->
                                                    <div class="step-card">
                                                        <h3>Step 1: Select or Register Guest</h3>
                                                        <div
                                                            style="display:flex; gap:20px; align-items:flex-end; flex-wrap:wrap;">
                                                            <div style="flex:2; min-width:200px;">
                                                                <label for="guestSelect">Select Existing Guest:</label>
                                                                <select id="guestSelect" onchange="onGuestSelect()"
                                                                    style="width:100%; padding:10px; margin-top:8px;">
                                                                    <option value="">-- Select Guest --</option>
                                                                    <% if (guests !=null) { for (Guest g : guests) { %>
                                                                        <option value="<%= g.getGuestId() %>"
                                                                            data-name="<%= g.getName() %>"
                                                                            data-contact="<%= g.getContactNo() %>"
                                                                            <%=(newGuestId !=null &&
                                                                            newGuestId==g.getGuestId()) ? "selected"
                                                                            : "" %>>
                                                                            <%= g.getName() %> - <%= g.getContactNo() %>
                                                                        </option>
                                                                        <% } } %>
                                                                </select>
                                                            </div>
                                                            <div style="flex:1; min-width:120px; align-self:flex-end;">
                                                                <button type="button" class="btn-primary"
                                                                    onclick="document.getElementById('guestModal').style.display='block'">➕
                                                                    New Guest</button>
                                                            </div>
                                                        </div>
                                                        <div id="guestInfo"
                                                            style="display:none; background:#f8f9fa; padding:15px; border-radius:8px; margin-top:15px;">
                                                            <p><strong>Selected Guest:</strong></p>
                                                            <p id="guestInfoName"></p>
                                                            <p id="guestInfoContact"></p>
                                                        </div>
                                                    </div>

                                                    <!-- Step 2: Dates -->
                                                    <div class="step-card" id="stepDates" style="display:none;">
                                                        <h3>Step 2: Select Stay Dates</h3>
                                                        <div class="form-row">
                                                            <% String todayStr=new
                                                                java.text.SimpleDateFormat("yyyy-MM-dd").format(new
                                                                java.util.Date()); %>
                                                                <div class="form-group">
                                                                    <label for="checkInDate">Check-in Date:</label>
                                                                    <input type="date" id="checkInDate"
                                                                        min="<%= todayStr %>" onchange="validateDates()"
                                                                        required>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="checkOutDate">Check-out Date:</label>
                                                                    <input type="date" id="checkOutDate"
                                                                        onchange="validateDates()" required>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="numGuests">Number of Guests:</label>
                                                                    <input type="number" id="numGuests" min="1" max="6"
                                                                        value="2" required>
                                                                </div>
                                                        </div>
                                                        <div id="dateError"
                                                            style="color:red; font-size:0.9rem; display:none;">
                                                            ⚠ Check-out date must be after check-in date.
                                                        </div>
                                                        <div style="margin-top:15px;">
                                                            <button type="button" class="btn-primary"
                                                                onclick="checkAvailability()">🔍 Check
                                                                Availability</button>
                                                        </div>
                                                    </div>

                                                    <!-- Step 3: Rooms -->
                                                    <div class="step-card" id="stepRooms" style="display:none;">
                                                        <h3>Step 3: Select Available Room</h3>
                                                        <div id="loadingRooms"
                                                            style="text-align:center; padding:30px; display:none;">
                                                            <p>⏳ Checking availability...</p>
                                                        </div>
                                                        <div id="noRoomsMsg"
                                                            style="display:none; text-align:center; color:#666; padding:20px;">
                                                            😞 No rooms available for selected dates.
                                                        </div>
                                                        <div id="roomGrid" class="room-grid"></div>
                                                    </div>

                                                    <!-- Step 4: Special Requests + Submit -->
                                                    <div class="step-card" id="stepSubmit" style="display:none;">
                                                        <h3>Step 4: Finalize & Submit</h3>
                                                        <form id="reservationForm" method="post"
                                                            action="${pageContext.request.contextPath}/reservation/create">
                                                            <input type="hidden" id="hiddenGuestId" name="guestId">
                                                            <input type="hidden" id="hiddenRoomId" name="roomId">
                                                            <input type="hidden" id="hiddenCheckIn" name="checkInDate">
                                                            <input type="hidden" id="hiddenCheckOut"
                                                                name="checkOutDate">
                                                            <input type="hidden" id="hiddenNumGuests" name="numGuests">

                                                            <div id="reviewBox"
                                                                style="background:#f7f8fc; padding:15px; border-radius:8px; margin-bottom:15px;">
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="specialRequests">Special Requests
                                                                    (Optional):</label>
                                                                <textarea id="specialRequests" name="specialRequests"
                                                                    rows="3"
                                                                    placeholder="e.g., Extra pillow, ocean-facing room, early check-in..."
                                                                    style="width:100%; padding:10px;"></textarea>
                                                            </div>
                                                            <div class="form-actions">
                                                                <button type="submit" class="btn-primary">✅ Confirm
                                                                    Reservation</button>
                                                                <button type="button" class="btn-secondary"
                                                                    onclick="resetWizard()">🔄 Start Over</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                </div>
                            </div>

                            <!-- New Guest Modal -->
                            <div id="guestModal" class="modal" style="display:none;">
                                <div class="modal-content">
                                    <span class="close"
                                        onclick="document.getElementById('guestModal').style.display='none'">&times;</span>
                                    <h3>Register New Guest</h3>
                                    <form method="post"
                                        action="${pageContext.request.contextPath}/receptionist/add-reservation">
                                        <input type="hidden" name="action" value="add-guest">
                                        <div class="form-group">
                                            <label>Full Name: *</label>
                                            <input type="text" name="guestName" placeholder="e.g., Nimal Perera"
                                                required>
                                        </div>
                                        <div class="form-group">
                                            <label>Address: *</label>
                                            <textarea name="guestAddress" rows="2"
                                                placeholder="No. 5, Galle Road, Colombo" required></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label>Contact Number: *</label>
                                            <input type="tel" name="guestContact" placeholder="0771234567" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Email:</label>
                                            <input type="email" name="guestEmail" placeholder="guest@email.com">
                                        </div>
                                        <div class="form-actions">
                                            <button type="submit" class="btn-primary">Register Guest</button>
                                            <button type="button"
                                                onclick="document.getElementById('guestModal').style.display='none'"
                                                class="btn-secondary">Cancel</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <script>
                                let selectedGuestId = null;
                                let selectedRoomId = null;

    // Auto-select if a new guest was just registered
    <% if (newGuestId != null) { %>
                                    window.onload = function() {
                                        const sel = document.getElementById('guestSelect');
                                        for (let i = 0; i < sel.options.length; i++) {
                                            if (sel.options[i].value == '<%= newGuestId %>') {
                                                sel.selectedIndex = i;
                                                onGuestSelect();
                                                break;
                                            }
                                        }
                                    };
    <% } %>

                                    function onGuestSelect() {
                                        const sel = document.getElementById('guestSelect');
                                        const opt = sel.options[sel.selectedIndex];
                                        if (sel.value) {
                                            selectedGuestId = sel.value;
                                            document.getElementById('guestInfoName').textContent = 'Name: ' + (opt.dataset.name || opt.text.split(' - ')[0]);
                                            document.getElementById('guestInfoContact').textContent = 'Contact: ' + (opt.dataset.contact || opt.text.split(' - ')[1]);
                                            document.getElementById('guestInfo').style.display = 'block';
                                            document.getElementById('stepDates').style.display = 'block';
                                        } else {
                                            selectedGuestId = null;
                                            document.getElementById('guestInfo').style.display = 'none';
                                            document.getElementById('stepDates').style.display = 'none';
                                            document.getElementById('stepRooms').style.display = 'none';
                                            document.getElementById('stepSubmit').style.display = 'none';
                                        }
                                    }

                                function validateDates() {
                                    const ci = document.getElementById('checkInDate').value;
                                    const co = document.getElementById('checkOutDate').value;
                                    const err = document.getElementById('dateError');
                                    if (ci && co && new Date(co) <= new Date(ci)) {
                                        err.style.display = 'block';
                                        return false;
                                    }
                                    err.style.display = 'none';
                                    return true;
                                }

                                function checkAvailability() {
                                    const ci = document.getElementById('checkInDate').value;
                                    const co = document.getElementById('checkOutDate').value;
                                    if (!ci || !co) { alert('Please fill in both check-in and check-out dates.'); return; }
                                    if (!validateDates()) { alert('Check-out must be after check-in.'); return; }

                                    document.getElementById('stepRooms').style.display = 'block';
                                    document.getElementById('loadingRooms').style.display = 'block';
                                    document.getElementById('roomGrid').innerHTML = '';
                                    document.getElementById('noRoomsMsg').style.display = 'none';
                                    document.getElementById('stepSubmit').style.display = 'none';

                                    fetch('${pageContext.request.contextPath}/reservation/check-availability?checkInDate=' + ci + '&checkOutDate=' + co)
                                        .then(r => r.json())
                                        .then(rooms => {
                                            document.getElementById('loadingRooms').style.display = 'none';
                                            if (!rooms || rooms.length === 0) {
                                                document.getElementById('noRoomsMsg').style.display = 'block';
                                                return;
                                            }
                                            let html = '';
                                            rooms.forEach(room => {
                                                html += `<div class="room-card" id="rc-\${room.roomId}" onclick="selectRoom(\${room.roomId},'\${room.roomNumber}',\${room.ratePerNight})">
                        <h4>Room \${room.roomNumber}</h4>
                        <p class="type">\${room.roomType} &mdash; Floor \${room.floorNumber}</p>
                        <p class="price">LKR \${room.ratePerNight.toLocaleString()}/night</p>
                    </div>`;
                                            });
                                            document.getElementById('roomGrid').innerHTML = html;
                                        })
                                        .catch(() => {
                                            document.getElementById('loadingRooms').style.display = 'none';
                                            document.getElementById('roomGrid').innerHTML = '<p style="color:red;">Failed to fetch available rooms. Please try again.</p>';
                                        });
                                }

                                function selectRoom(roomId, roomNumber, rate) {
                                    selectedRoomId = roomId;
                                    document.querySelectorAll('.room-card').forEach(c => c.classList.remove('selected'));
                                    document.getElementById('rc-' + roomId).classList.add('selected');

                                    const ci = document.getElementById('checkInDate').value;
                                    const co = document.getElementById('checkOutDate').value;
                                    const nights = Math.round((new Date(co) - new Date(ci)) / 86400000);
                                    const total = rate * nights;

                                    document.getElementById('hiddenGuestId').value = selectedGuestId;
                                    document.getElementById('hiddenRoomId').value = roomId;
                                    document.getElementById('hiddenCheckIn').value = ci;
                                    document.getElementById('hiddenCheckOut').value = co;
                                    document.getElementById('hiddenNumGuests').value = document.getElementById('numGuests').value;

                                    document.getElementById('reviewBox').innerHTML =
                                        `<strong>Booking Summary</strong><br>
             Room: <strong>\${roomNumber}</strong> &mdash; LKR \${rate.toLocaleString()}/night<br>
             Duration: <strong>\${nights} night\${nights !== 1 ? 's' : ''}</strong><br>
             Estimated Total: <strong>LKR \${total.toLocaleString()}</strong>`;

                                    document.getElementById('stepSubmit').style.display = 'block';
                                    document.getElementById('stepSubmit').scrollIntoView({ behavior: 'smooth' });
                                }

                                function resetWizard() {
                                    selectedGuestId = null;
                                    selectedRoomId = null;
                                    document.getElementById('guestSelect').value = '';
                                    document.getElementById('guestInfo').style.display = 'none';
                                    document.getElementById('stepDates').style.display = 'none';
                                    document.getElementById('stepRooms').style.display = 'none';
                                    document.getElementById('stepSubmit').style.display = 'none';
                                    document.getElementById('checkInDate').value = '';
                                    document.getElementById('checkOutDate').value = '';
                                }
                            </script>
                        </body>

                        </html>