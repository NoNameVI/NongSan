package controller;

import dao.DonHangDAO;
import entity.DonHang;
import entity.NguoiDung;
import entity.ChiTietDonHang;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;

@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. ĐỌC COOKIE ĐỂ LẤY MÃ NGƯỜI DÙNG (maND)
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

        // Nếu không có Cookie (chưa đăng nhập), đẩy về trang Login
        if (maND == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. KHỞI TẠO ĐƠN HÀNG VÀ GÁN DỮ LIỆU
        String diaChiGiao = request.getParameter("diaChiGiao");
        // Giả sử tổng tiền bạn lấy từ tham số hoặc tính toán từ List chi tiết
        double tongTien = Double.parseDouble(request.getParameter("tongTien"));

        DonHang donHang = new DonHang();
        donHang.setDiaChiGiao(diaChiGiao);
        donHang.setTongTien(BigDecimal.valueOf(tongTien));

        // --- CHÚ Ý CHỖ NÀY ---
        // Tùy vào việc Entity DonHang của bạn cấu hình Khóa Ngoại MaKhachHang là kiểu int hay đối tượng NguoiDung
        // Trừờng hợp 1: Nếu MaKhachHang là kiểu đối tượng NguoiDung
        NguoiDung khachHang = new NguoiDung();
        khachHang.setMaND(maND);
        donHang.setMaKhachHang(khachHang);

        // Trường hợp 2: Nếu MaKhachHang là kiểu int
        // donHang.setMaKhachHang(maND);
        // 3. LẤY DANH SÁCH CHI TIẾT TỪ SESSION HOẶC FORM VÀ GỌI DAO
        // (Đây là dữ liệu mẫu giả định bạn đã lấy được danh sách item khách hàng muốn mua)
        List<ChiTietDonHang> listChiTiet = (List<ChiTietDonHang>) request.getSession().getAttribute("cartItems");

        DonHangDAO dao = new DonHangDAO();
        boolean isSuccess = dao.createOrder(donHang, listChiTiet);

        // 4. CHUYỂN HƯỚNG DỰA TRÊN KẾT QUẢ
        if (isSuccess) {
            // Xóa giỏ hàng tạm trong session (vì DAO đã xóa trong DB rồi)
            request.getSession().removeAttribute("cartItems");
            request.setAttribute("msg", "Đặt hàng thành công!");
            request.getRequestDispatcher("orderhistory.jsp").forward(request, response);
        } else {
            request.setAttribute("err", "Lỗi hệ thống! Vui lòng thử lại.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}
