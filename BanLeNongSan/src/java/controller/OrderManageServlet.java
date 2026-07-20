package controller;

import dao.DonHangDAO;
import entity.DonHang;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "OrderManageServlet", urlPatterns = {"/admin/orders"})
public class OrderManageServlet extends HttpServlet {

    // Hàm kiểm tra quyền truy cập Admin qua Cookie
    // SỬA LỖI BẢO MẬT: trước đây chỉ kiểm tra cookie "maND" TỒN TẠI, nghĩa là
    // bất kỳ Khách hàng nào đã đăng nhập cũng vào được trang quản lý đơn hàng.
    // Nay kiểm tra thêm cookie "maVaiTro" phải là Nhân viên (2) hoặc Quản lý (3).
    private boolean checkAdminAccess(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return false;
        }
        boolean hasLogin = false;
        boolean hasValidRole = false;
        for (Cookie c : cookies) {
            if (c.getName().equals("maND")) {
                hasLogin = true;
            }
            if (c.getName().equals("maVaiTro")) {
                String role = c.getValue();
                if ("2".equals(role) || "3".equals(role)) {
                    hasValidRole = true;
                }
            }
        }
        return hasLogin && hasValidRole;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Kiểm tra bảo mật
        if (!checkAdminAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        DonHangDAO dao = new DonHangDAO();

        // 2. Lấy danh sách toàn bộ đơn hàng
        List<DonHang> list = dao.getAllOrders();
        request.setAttribute("orderList", list);

        // 3. Điều hướng sang giao diện (Sử dụng dấu / để chỉ định từ gốc thư mục)
        request.getRequestDispatcher("/adminorders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Kiểm tra bảo mật
        if (!checkAdminAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // Lấy và kiểm tra thông tin cập nhật từ form
            String orderIdStr = request.getParameter("orderId");
            String status = request.getParameter("status");

            if (orderIdStr != null && status != null) {
                int orderId = Integer.parseInt(orderIdStr);

                // Gọi DAO để cập nhật trạng thái
                DonHangDAO dao = new DonHangDAO();
                boolean isUpdated = dao.updateOrderStatus(orderId, status);

                if (isUpdated) {
                    session.setAttribute("msg", "Cập nhật trạng thái đơn hàng #" + orderId + " thành công!");
                } else {
                    session.setAttribute("err", "Cập nhật thất bại. Vui lòng kiểm tra lại hệ thống.");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("err", "Dữ liệu mã đơn hàng không hợp lệ!");
        } catch (Exception e) {
            session.setAttribute("err", "Lỗi hệ thống: " + e.getMessage());
        }

        // Chuyển hướng lại trang danh sách đơn hàng
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    @Override
    public String getServletInfo() {
        return "Quản lý đơn hàng cho Admin";
    }
}
