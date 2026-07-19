package controller;

import dao.DonHangDAO;
import entity.DonHang;
import entity.ChiTietDonHang;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/orderhistory"})
public class OrderHistoryServlet extends HttpServlet {

    // Hàm hỗ trợ lấy mã người dùng từ Cookie
    private Integer getMaNDFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("maND")) {
                    try {
                        return Integer.parseInt(c.getValue());
                    } catch (NumberFormatException e) {
                        return null;
                    }
                }
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy maND từ Cookie thay vì dùng Session[cite: 17]
        Integer maND = getMaNDFromCookie(request);

        // Kiểm tra đăng nhập[cite: 17]
        if (maND == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        DonHangDAO dao = new DonHangDAO();
        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            // Xem chi tiết đơn hàng[cite: 17]
            int orderId = Integer.parseInt(request.getParameter("id"));
            List<ChiTietDonHang> details = dao.getOrderDetails(orderId);

            request.setAttribute("orderDetails", details);
            request.getRequestDispatcher("order-detail-view.jsp").forward(request, response);
        } else {
            // Xem lịch sử mua hàng[cite: 17]
            List<DonHang> orders = dao.getOrdersByUser(maND);

            request.setAttribute("orderHistory", orders);
            request.getRequestDispatcher("orderhistory.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Lịch sử mua hàng của khách hàng";
    }
}
