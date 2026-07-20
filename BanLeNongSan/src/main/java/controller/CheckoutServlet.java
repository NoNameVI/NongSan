package controller;

import dao.GioHangDAO;
import dao.NguoiDungDAO;
import entity.ChiTietGioHang;
import entity.NguoiDung;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author asus
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    // Hàm hỗ trợ đọc Cookie để lấy mã người dùng
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GioHangDAO cartDAO = new GioHangDAO();
        NguoiDungDAO userDAO = new NguoiDungDAO(); // Khởi tạo thêm DAO người dùng

        Integer userId = getMaNDFromCookie(request);

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Lấy thông tin user để fill vào form
        NguoiDung user = userDAO.getUserProfile(userId);
        request.setAttribute("user", user);

        // 2. Lấy giỏ hàng
        List<ChiTietGioHang> cartItems = cartDAO.getCartItems(userId);
        request.setAttribute("cartItems", cartItems);

        // 3. Lấy tổng tiền (nếu có từ URL)
        String tongTien = request.getParameter("tongTien");
        request.setAttribute("tongTien", tongTien);

        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Kiểm tra bảo mật: Đảm bảo người dùng đã đăng nhập trước khi submit form thanh toán
        Integer userId = getMaNDFromCookie(request);
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Thu thập thông tin giao hàng
        String shippingAddress = request.getParameter("address");
        String shippingPhone = request.getParameter("phone");

        // 2. Thu thập phương thức thanh toán (ví dụ: COD, VNPay, Momo...)
        String paymentMethod = request.getParameter("paymentMethod");

        // 3. Đóng gói dữ liệu vào request attribute để chuyển giao
        request.setAttribute("shippingAddress", shippingAddress);
        request.setAttribute("shippingPhone", shippingPhone);
        request.setAttribute("paymentMethod", paymentMethod);

        // Chuyển tiếp toàn bộ request sang OrderServlet (Do Thành viên khác làm)
        // OrderServlet sẽ lấy thông tin này tạo DonHang, lấy danh sách giỏ hàng để tạo ChiTietDonHang,
        // và gọi ThanhToanDAO.createPayment() của bạn để tạo record thanh toán.
        request.getRequestDispatcher("/order").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Checkout Servlet with Cookie Authentication";
    }// </editor-fold>

}
