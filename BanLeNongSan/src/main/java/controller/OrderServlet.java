/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author asus
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OrderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        processRequest(request, response);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("USER_SESSION");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String diaChiGiao = request.getParameter("diaChiGiao");
        double tongTien = Double.parseDouble(request.getParameter("tongTien"));

        @SuppressWarnings("unchecked")
        List<ChiTietDonHang> listChiTiet = (List<ChiTietDonHang>) session.getAttribute("CART_ITEMS");

        if (listChiTiet == null || listChiTiet.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        DonHang dh = new DonHang();
        dh.setMaKhachHang(user.getMaND());
        dh.setDiaChiGiao(diaChiGiao);
        dh.setTongTien(tongTien);

        DonHangDAO dao = new DonHangDAO();
        boolean isSuccess = dao.createOrder(dh, listChiTiet);

        if (isSuccess) {
            session.removeAttribute("CART_ITEMS"); // Xóa session giỏ hàng sau khi đặt thành công
            response.sendRedirect("OrderHistoryServlet");
        } else {
            request.setAttribute("error", "Lỗi trong quá trình tạo đơn hàng!");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }

/**
 * Returns a short description of the servlet.
 *
 * @return a String containing servlet description
 */
@Override
public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
