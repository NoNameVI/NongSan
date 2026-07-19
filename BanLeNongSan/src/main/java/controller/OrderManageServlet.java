package controller;

import dao.DonHangDAO;
import entity.DonHang;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "OrderManageServlet", urlPatterns = {"/admin/orders"})
public class OrderManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DonHangDAO dao = new DonHangDAO();

        // Lấy danh sách toàn bộ đơn hàng[cite: 16]
        List<DonHang> list = dao.getAllOrders();
        request.setAttribute("orderList", list);

        // Điều hướng sang giao diện adminorders.jsp[cite: 16]
        request.getRequestDispatcher("/adminorders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Lấy thông tin cập nhật từ form[cite: 16]
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        // Gọi DAO để cập nhật trạng thái[cite: 16]
        DonHangDAO dao = new DonHangDAO();
        dao.updateOrderStatus(orderId, status);

        // Chuyển hướng lại trang danh sách đơn hàng[cite: 16]
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    @Override
    public String getServletInfo() {
        return "Quản lý đơn hàng cho Admin";
    }
}
