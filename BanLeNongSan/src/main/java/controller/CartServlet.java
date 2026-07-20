package controller;

import dao.GioHangDAO;
import dao.SanPhamDAO;
import entity.ChiTietGioHang;
import entity.SanPham;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Iterator;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    // Hàm đọc Cookie để lấy mã người dùng
    private Integer getMaNDFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("maND")) {
                    try {
                        return Integer.valueOf(c.getValue());
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

        // 1. Kiểm tra đăng nhập (Bắt buộc đăng nhập mới cho dùng giỏ hàng)
        Integer userId = getMaNDFromCookie(request);
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Lấy giỏ hàng từ Session. Nếu chưa có thì khởi tạo List mới.
        List<ChiTietGioHang> cartItems = (List<ChiTietGioHang>) session.getAttribute("cartItems");
        if (cartItems == null) {
            cartItems = new ArrayList<>();
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
                    boolean found = false;

                    // Kiểm tra xem sản phẩm đã có trong giỏ chưa
                    for (ChiTietGioHang item : cartItems) {
                        if (item.getSanPham().getMaSP() == productIdAdd) {
                            item.setSoLuong(item.getSoLuong() + quantityAdd);
                            found = true;
                            break;
                        }
                    }

                    // Nếu chưa có, tạo mới và add vào List
                    if (!found) {
                        SanPhamDAO spDAO = new SanPhamDAO();
                        SanPham sp = spDAO.getProductById(productIdAdd);
                        if (sp != null) {
                            ChiTietGioHang newItem = new ChiTietGioHang();
                            newItem.setSanPham(sp);
                            newItem.setSoLuong(quantityAdd);
                            cartItems.add(newItem);
                        }
                    }
                    break;

                case "update":
                    int productIdUpdate = Integer.parseInt(request.getParameter("productId"));
                    int quantityUpdate = Integer.parseInt(request.getParameter("quantity"));
                    Iterator<ChiTietGioHang> iterUpdate = cartItems.iterator();

                    while (iterUpdate.hasNext()) {
                        ChiTietGioHang item = iterUpdate.next();
                        if (item.getSanPham().getMaSP() == productIdUpdate) {
                            if (quantityUpdate <= 0) {
                                iterUpdate.remove(); // Xóa nếu số lượng <= 0
                            } else {
                                item.setSoLuong(quantityUpdate);
                            }
                            break;
                        }
                    }
                    break;

                case "remove":
                    int productIdRemove = Integer.parseInt(request.getParameter("productId"));
                    Iterator<ChiTietGioHang> iterRemove = cartItems.iterator();

                    while (iterRemove.hasNext()) {
                        ChiTietGioHang item = iterRemove.next();
                        if (item.getSanPham().getMaSP() == productIdRemove) {
                            iterRemove.remove();
                            break;
                        }
                    }
                    break;

                case "clear":
                    cartItems.clear();
                    break;
            }
        } catch (NumberFormatException e) {
            // Bỏ qua lỗi ép kiểu nếu parameter không hợp lệ
        }

        // 3. Cập nhật lại List mới lên Session
        session.setAttribute("cartItems", cartItems);

        // 4. Điều hướng
        if ("view".equals(action)) {
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } else {
            response.sendRedirect("cart"); // Tránh lỗi resubmit form khi ấn F5
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
