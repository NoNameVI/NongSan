package controller;

import dao.NguoiDungDAO;
import entity.NguoiDung;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    // Hàm dùng chung để lấy MaND từ Cookie
    private Integer getMaNDFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("maND")) { // Lấy ID theo quy ước[cite: 1]
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

        // Lấy mã người dùng từ Cookie
        Integer maND = getMaNDFromCookie(request);

        if (maND == null) {
            // Nếu không tìm thấy Cookie định danh, chuyển về trang đăng nhập
            response.sendRedirect("login.jsp");
            return;
        }

        // Gọi DAO để lấy thông tin chi tiết[cite: 10]
        NguoiDungDAO dao = new NguoiDungDAO();
        NguoiDung user = dao.getUserProfile(maND);

        if (user != null) {
            request.setAttribute("user", user);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy mã người dùng từ Cookie
        Integer maND = getMaNDFromCookie(request);

        if (maND == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin từ form gửi lên
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String diaChi = request.getParameter("diaChi");

        NguoiDungDAO dao = new NguoiDungDAO();

        // Lấy lại object hiện tại từ DB để bảo toàn các trường không bị thay đổi[cite: 10]
        NguoiDung currentUser = dao.getUserProfile(maND);

        if (currentUser != null) {
            currentUser.setHoTen(hoTen);
            currentUser.setSdt(sdt);
            currentUser.setDiaChi(diaChi);

            // Lưu thay đổi vào CSDL[cite: 10]
            boolean isUpdated = dao.updateProfile(currentUser);

            if (isUpdated) {
                request.setAttribute("msg", "Cập nhật thông tin thành công!");

                // Cập nhật lại Cookie fullname nếu người dùng đổi tên
                Cookie cookieFullname = new Cookie("fullname", hoTen.replaceAll("\\s+", "_"));
                cookieFullname.setMaxAge(60 * 60);
                cookieFullname.setPath("/"); // Thêm dòng này để tránh lỗi tương tự khi đổi tên
                response.addCookie(cookieFullname);
            } else {
                request.setAttribute("err", "Cập nhật thất bại. Vui lòng thử lại!");
            }

            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Profile Management Servlet using Cookies";
    }
}
