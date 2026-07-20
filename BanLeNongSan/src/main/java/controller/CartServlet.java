package controller;

import dao.GioHangDAO;
import entity.ChiTietGioHang;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = getUserIdFromCookie(request);
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        GioHangDAO cartDAO = new GioHangDAO();
        String action = request.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "view";
        }

        try {
            switch (action) {
                case "add":
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    if (quantity > 0) {
                        cartDAO.addToCart(userId, productId, quantity);
                    }
                    response.sendRedirect("cart");
                    return;

                case "quickAdd":
                    cartDAO.addToCart(userId,
                            Integer.parseInt(request.getParameter("productId")), 1);
                    response.sendRedirect("cart");
                    return;

                case "update":
                    cartDAO.updateCartQuantity(userId,
                            Integer.parseInt(request.getParameter("productId")),
                            Integer.parseInt(request.getParameter("quantity")));
                    response.sendRedirect("cart");
                    return;

                case "remove":
                    cartDAO.removeFromCart(userId,
                            Integer.parseInt(request.getParameter("productId")));
                    response.sendRedirect("cart");
                    return;

                case "clear":
                    cartDAO.clearCart(userId);
                    response.sendRedirect("cart");
                    return;

                case "view":
                    List<ChiTietGioHang> cartItems = cartDAO.getCartItems(userId);
                    request.setAttribute("cartItems", cartItems);
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    return;

                default:
                    response.sendRedirect("cart");
            }
        } catch (NumberFormatException ex) {
            response.sendRedirect("cart");
        }
    }

    private Integer getUserIdFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }

        for (Cookie cookie : cookies) {
            if ("maND".equals(cookie.getName())) {
                try {
                    return Integer.valueOf(cookie.getValue());
                } catch (NumberFormatException ex) {
                    return null;
                }
            }
        }
        return null;
    }
}
