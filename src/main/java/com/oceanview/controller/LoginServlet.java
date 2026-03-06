package com.oceanview.controller;

import com.oceanview.model.User;
import com.oceanview.service.AuthenticationService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private AuthenticationService authService;

    @Override
    public void init() {
        authService = new AuthenticationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        request.setAttribute("selectedRole", role);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username == null || password == null || role == null) {
            request.setAttribute("error", "All fields are required");
            request.setAttribute("selectedRole", role);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = authService.authenticate(username, password);

        if (user != null) {
            String dbRole = user.getRole().toLowerCase();
            String uiRole = role.toLowerCase();

            boolean roleMatch = false;

            if (uiRole.equals("admin") && dbRole.equals("administrator")) {
                roleMatch = true;
            } else if (uiRole.equals("receptionist") && dbRole.equals("receptionist")) {
                roleMatch = true;
            } else if (uiRole.equals("accountant") && dbRole.equals("accountant")) {
                roleMatch = true;
            }

            if (roleMatch) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userRole", user.getRole());
                session.setMaxInactiveInterval(30 * 60);

                // Redirect to the servlet URL, not directly to JSP
                String dashboardPath = "";
                if (dbRole.equals("administrator")) {
                    dashboardPath = "/admin/dashboard";
                } else if (dbRole.equals("receptionist")) {
                    dashboardPath = "/receptionist/dashboard";
                } else if (dbRole.equals("accountant")) {
                    dashboardPath = "/accountant/dashboard";
                }

                response.sendRedirect(request.getContextPath() + dashboardPath);
            } else {
                request.setAttribute("error", "Invalid role for this user");
                request.setAttribute("selectedRole", role);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("selectedRole", role);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}