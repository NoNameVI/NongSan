/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.NguoiDungDAO;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import entity.NguoiDung;

/**
 *
 * @author asus
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

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
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        NguoiDungDAO dao = new NguoiDungDAO();
        NguoiDung u = dao.login(email, pass);
        if (u == null) {
            request.setAttribute("err", "Email hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            //dung banh quy
            Cookie cookieFullname = new Cookie("fullname", u.getHoTen().replaceAll("\\s+", "_"));
            cookieFullname.setMaxAge(60 * 60);
            response.addCookie(cookieFullname);
            // 2. BỔ SUNG: Cookie lưu MaND để định danh cho các Servlet khác dùng chung[cite: 1]
            Cookie cookieMaND = new Cookie("maND", String.valueOf(u.getMaND()));
            cookieMaND.setMaxAge(60 * 60); // Tồn tại trong 1 giờ
            response.addCookie(cookieMaND);
            response.sendRedirect("home");
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
