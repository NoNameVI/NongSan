package controller;

import dao.DonHangDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. KIỂM TRA QUYỀN ĐĂNG NHẬP + VAI TRÒ (Bảo mật cho trang Admin)
        // SỬA LỖI BẢO MẬT: trước đây chỉ cần có cookie "maND" hợp lệ là vào được
        // Dashboard, kể cả tài khoản Khách hàng. Nay bắt buộc phải là
        // Nhân viên (maVaiTro = 2) hoặc Quản lý (maVaiTro = 3).
        Integer maND = null;
        String maVaiTro = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("maND")) {
                    try {
                        maND = Integer.parseInt(c.getValue());
                    } catch (NumberFormatException e) {
                        maND = null;
                    }
                }
                if (c.getName().equals("maVaiTro")) {
                    maVaiTro = c.getValue();
                }
            }
        }

        boolean hasValidRole = "2".equals(maVaiTro) || "3".equals(maVaiTro);

        // Nếu chưa đăng nhập hoặc không đủ quyền, đẩy về trang login
        if (maND == null || !hasValidRole) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. LẤY DỮ LIỆU THỐNG KÊ
        DonHangDAO dao = new DonHangDAO(); //

        List<Double[]> revenueList = dao.getRevenueByMonth(); //[cite: 12]
        List<Object[]> topProducts = dao.getTopSellingProducts(); //[cite: 12]

        request.setAttribute("revenueList", revenueList); //[cite: 12]
        request.setAttribute("topProducts", topProducts); //[cite: 12]

        // 3. ĐIỀU HƯỚNG SANG GIAO DIỆN
        // Đã bỏ dấu "/" ở đầu để tránh lỗi đường dẫn tuyệt đối
        request.getRequestDispatcher("admindashboard.jsp").forward(request, response); //[cite: 12]
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đảm bảo request POST cũng sẽ load được giao diện Dashboard thay vì gọi processRequest[cite: 12]
        doGet(request, response);
    }
}
