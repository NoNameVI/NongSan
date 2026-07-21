package controller;

import dao.DonHangDAO;
import entity.NguoiDung;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. KIỂM TRA QUYỀN ĐĂNG NHẬP + VAI TRÒ (Bảo mật cho trang Admin)
        HttpSession session = request.getSession(false);
        NguoiDung user = session == null ? null : (NguoiDung) session.getAttribute("user");

        if (user == null || user.getMaVaiTro() == null || user.getMaVaiTro().getMaVaiTro() == null) {
            if (session != null) {
                session.setAttribute("err", "Vui lòng đăng nhập để tiếp tục.");
            }
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Integer roleId = user.getMaVaiTro().getMaVaiTro();
        boolean hasValidRole = roleId == 2 || roleId == 3;

        if (!hasValidRole) {
            if (session != null) {
                session.setAttribute("err", "Bạn không có quyền truy cập trang này.");
            }
            response.sendRedirect(request.getContextPath() + "/home");
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
