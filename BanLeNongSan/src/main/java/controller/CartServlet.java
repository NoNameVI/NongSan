package controller;

import dao.GioHangDAO;
import entity.ChiTietGioHang;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    // Hàm đọc Cookie để lấy mã người dùng
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        GioHangDAO cartDAO = new GioHangDAO();

        // 1. Lấy mã người dùng từ Cookie thay vì Session[cite: 22]
        Integer userId = getMaNDFromCookie(request);

        if (userId == null) {
            // Chưa đăng nhập thì bắt quay lại trang Login
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        try {
            switch (action) {
                case "add":
                    int productIdAdd = Integer.parseInt(request.getParameter("productId"));
                    int quantityAdd = Integer.parseInt(request.getParameter("quantity"));
                    // Gọi DAO xử lý lưu vào Database[cite: 21, 22]
                    cartDAO.addToCart(userId, productIdAdd, quantityAdd);
                    break;
                case "update":
                    int productIdUpdate = Integer.parseInt(request.getParameter("productId"));
                    int quantityUpdate = Integer.parseInt(request.getParameter("quantity"));
                    cartDAO.updateCartQuantity(userId, productIdUpdate, quantityUpdate);
                    break;
                case "remove":
                    int productIdRemove = Integer.parseInt(request.getParameter("productId"));
                    cartDAO.removeFromCart(userId, productIdRemove);
                    break;
                case "clear":
                    cartDAO.clearCart(userId);
                    break;
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // 2. Đồng bộ dữ liệu giỏ hàng mới nhất từ DB lên Session để các trang khác (như Header) dễ dàng hiển thị số lượng
        List<ChiTietGioHang> cartItems = cartDAO.getCartItems(userId);
        session.setAttribute("cartItems", cartItems);

        // 3. Phân luồng điều hướng
        if ("view".equals(action)) {
            // Chuyển tới trang JSP xem giỏ hàng
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } else {
            // Sau khi thêm/sửa/xóa, redirect lại trang cart (phương thức GET) để tránh lỗi resubmit form khi F5
            response.sendRedirect("cart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Gửi hết Post về Get để xử lý chung
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Quản lý Giỏ Hàng Servlet";
    }
}
