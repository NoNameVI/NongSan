package controller;

import dao.DonHangDAO;
import entity.ChiTietDonHang;
import entity.DonHang;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/orderhistory"})
public class OrderHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = getUserIdFromCookie(request);
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        DonHangDAO dao = new DonHangDAO();
        request.setAttribute("orderHistory", dao.getOrdersByUser(userId));

        String successMessage = (String) request.getSession().getAttribute("orderSuccess");
        if (successMessage != null) {
            request.setAttribute("msg", successMessage);
            request.getSession().removeAttribute("orderSuccess");
        }

        if ("detail".equals(request.getParameter("action"))) {
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                DonHang selectedOrder = dao.getOrderByIdAndUser(orderId, userId);
                if (selectedOrder == null) {
                    request.setAttribute("err", "Không tìm thấy đơn hàng hoặc bạn không có quyền xem đơn này.");
                } else {
                    List<ChiTietDonHang> details = dao.getOrderDetails(orderId);
                    request.setAttribute("selectedOrder", selectedOrder);
                    request.setAttribute("orderDetails", details);
                }
            } catch (NumberFormatException ex) {
                request.setAttribute("err", "Mã đơn hàng không hợp lệ.");
            }
        }

        request.getRequestDispatcher("orderhistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private Integer getUserIdFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return null;
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
