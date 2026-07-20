package controller;

import dao.DonHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect("checkout");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Integer userId = getUserIdFromCookie(request);
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");
        if (address == null || address.trim().isEmpty()) {
            request.getSession().setAttribute("checkoutError", "Địa chỉ giao hàng không được để trống.");
            response.sendRedirect("checkout");
            return;
        }

        boolean success = new DonHangDAO().createOrder(userId, address.trim(), paymentMethod);
        if (success) {
            // Session chỉ phục vụ giao diện; giỏ dùng để tạo đơn luôn lấy từ DB.
            request.getSession().removeAttribute("cartItems");
            request.getSession().setAttribute("orderSuccess", "Đặt hàng thành công!");
            response.sendRedirect("orderhistory");
        } else {
            request.getSession().setAttribute("checkoutError",
                    "Đặt hàng không thành công. Giỏ hàng có thể trống, tồn kho không đủ hoặc phương thức thanh toán không hợp lệ.");
            response.sendRedirect("checkout");
        }
    }

    private Integer getUserIdFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if ("maND".equals(cookie.getName())) {
                try {
                    return Integer.valueOf(cookie.getValue());
                } catch (NumberFormatException ex) {
                    return null;
                }
            }
        }
        return null;
    }
}
