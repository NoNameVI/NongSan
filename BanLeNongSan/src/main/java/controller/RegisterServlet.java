package controller;

import dao.NguoiDungDAO;
import entity.NguoiDung;
import entity.VaiTro;
import java.io.IOException;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String hoTen = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String sdt = request.getParameter("sdt");
        String diaChi = request.getParameter("diaChi");
        String pass = request.getParameter("pass");
        String repass = request.getParameter("repass");

        if (!pass.equals(repass)) {
            request.setAttribute("err", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            NguoiDungDAO dao = new NguoiDungDAO();

            NguoiDung nd = new NguoiDung();
            nd.setHoTen(hoTen);
            nd.setEmail(email);
            nd.setSdt(sdt);
            nd.setDiaChi(diaChi);
            nd.setMatKhau(dao.hashMD5(pass));

            nd.setNgayTao(new Date());
            nd.setTrangThai("Hoat dong");

            VaiTro vaiTro = new VaiTro(1);
            nd.setMaVaiTro(vaiTro);

            dao.registerUser(nd);

            request.setAttribute("msg", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("err", "Đăng ký thất bại, email có thể đã tồn tại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Register Servlet for Nông Sản Web";
    }
}
