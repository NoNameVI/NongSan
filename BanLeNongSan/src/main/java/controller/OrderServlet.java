package controller;

import dao.DonHangDAO;
import dao.ThanhToanDAO;
import entity.DonHang;
import entity.NguoiDung;
import entity.ChiTietDonHang;
import entity.ChiTietGioHang;
import entity.ThanhToan;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;

@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer maND = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("maND")) {
                    try {
                        maND = Integer.parseInt(c.getValue());
                    } catch (NumberFormatException e) {
                        maND = null;
                    }
                    break;
                }
            }
        }

        if (maND == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. KHỞI TẠO ĐƠN HÀNG VÀ GÁN DỮ LIỆU
        // Lấy đúng tham số "address" thay vì "diaChiGiao"
        String diaChiGiao = request.getParameter("address");

        double tongTien = 0;
        try {
            // Check null an toàn trước khi ép kiểu
            String tongTienParam = request.getParameter("tongTien");
            if (tongTienParam != null && !tongTienParam.isEmpty()) {
                tongTien = Double.parseDouble(tongTienParam);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        DonHang donHang = new DonHang();
        donHang.setDiaChiGiao(diaChiGiao);
        donHang.setTongTien(BigDecimal.valueOf(tongTien));

        NguoiDung khachHang = new NguoiDung();
        khachHang.setMaND(maND);
        donHang.setMaKhachHang(khachHang);

        // 3. LẤY DANH SÁCH CHI TIẾT TỪ SESSION
        List<ChiTietGioHang> listChiTiet = (List<ChiTietGioHang>) request.getSession().getAttribute("cartItems");

        DonHangDAO dao = new DonHangDAO();
        boolean isSuccess = dao.createOrder(donHang, listChiTiet);

        // 4. GHI NHẬN THANH TOÁN & ĐIỀU HƯỚNG
        if (isSuccess) {

//            // Gọi phương thức thanh toán từ request
            String paymentMethod = request.getParameter("paymentMethod");
//
//            // Khởi tạo bill ThanhToan
            ThanhToan tt = new ThanhToan();
            tt.setMaDH(donHang); // donHang lúc này đã tự động được gán MaDH từ Database sau hàm persist
            tt.setPhuongThuc(paymentMethod != null ? paymentMethod : "COD");
            tt.setSoTien(BigDecimal.valueOf(tongTien));
            tt.setNgayThanhToan(new Date());
            tt.setTrangThai("chua thanh toan");
//
//            // Lưu record thanh toán
            ThanhToanDAO ttDAO = new ThanhToanDAO();
            ttDAO.createPayment(tt);
//
//            // Xóa giỏ hàng tạm trong session
            request.getSession().removeAttribute("cartItems");
            request.setAttribute("msg", "Đặt hàng thành công!");
            request.getRequestDispatcher("orderhistory.jsp").forward(request, response);
        } else {
            request.setAttribute("err", "Lỗi hệ thống! Vui lòng thử lại.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}
