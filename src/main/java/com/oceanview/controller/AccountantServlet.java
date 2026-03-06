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
        "/accountant/dashboard",
        "/accountant/view-bills",
        "/accountant/revenue-report"
})
public class AccountantServlet extends HttpServlet {

    private BillDAO billDAO;

    @Override
    public void init() {
        billDAO = new BillDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"accountant".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        if ("/accountant/dashboard".equals(path)) {
            showDashboard(request, response);
        } else if ("/accountant/view-bills".equals(path)) {
            showViewBills(request, response);
        } else if ("/accountant/revenue-report".equals(path)) {
            showRevenueReport(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/accountant/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Bill> bills = billDAO.getAllBills();

            double totalRevenue = 0;
            double pendingPayments = 0;
            int paidCount = 0;
            int pendingCount = 0;

            for (Bill b : bills) {
                if ("paid".equals(b.getPaymentStatus())) {
                    totalRevenue += b.getFinalAmount();
                    paidCount++;
                } else {
                    pendingPayments += b.getFinalAmount();
                    pendingCount++;
                }
            }

            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("pendingPayments", pendingPayments);
            request.setAttribute("totalBills", bills.size());
            request.setAttribute("paidCount", paidCount);
            request.setAttribute("pendingCount", pendingCount);

        } catch (Exception e) {
            System.err.println("Error loading accountant dashboard: " + e.getMessage());
            request.setAttribute("totalRevenue", 0.0);
            request.setAttribute("pendingPayments", 0.0);
            request.setAttribute("totalBills", 0);
            request.setAttribute("paidCount", 0);
            request.setAttribute("pendingCount", 0);
        }
        request.getRequestDispatcher("/accountant/dashboard.jsp").forward(request, response);
    }

    private void showViewBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Bill> bills = billDAO.getAllBills();
            request.setAttribute("bills", bills);
        } catch (Exception e) {
            System.err.println("Error loading bills: " + e.getMessage());
            request.setAttribute("error", "Failed to load bills: " + e.getMessage());
        }
        request.getRequestDispatcher("/accountant/viewBills.jsp").forward(request, response);
    }

    private void showRevenueReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Bill> bills = billDAO.getAllBills();

            double totalRevenue = 0;
            double totalTax = 0;
            double totalDiscount = 0;
            int[] monthlyCount = new int[12];
            double[] monthlyRevenue = new double[12];

            java.util.Calendar cal = java.util.Calendar.getInstance();
            for (Bill b : bills) {
                totalRevenue += b.getFinalAmount();
                totalTax += b.getTaxAmount();
                totalDiscount += b.getDiscount();
                if (b.getBillDate() != null) {
                    cal.setTime(b.getBillDate());
                    int month = cal.get(java.util.Calendar.MONTH);
                    monthlyCount[month]++;
                    monthlyRevenue[month] += b.getFinalAmount();
                }
            }

            request.setAttribute("bills", bills);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalTax", totalTax);
            request.setAttribute("totalDiscount", totalDiscount);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("monthlyCount", monthlyCount);

        } catch (Exception e) {
            System.err.println("Error loading revenue report: " + e.getMessage());
            request.setAttribute("error", "Failed to load revenue data: " + e.getMessage());
        }
        request.getRequestDispatcher("/accountant/revenueReport.jsp").forward(request, response);
    }
}