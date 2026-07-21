package filler;

import entity.NguoiDung;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Centralizes access control for management pages. The role is read from the
 * server-side session, never from a client-controlled cookie.
 */
@WebFilter(urlPatterns = {"/dashboard", "/admin/*"})
public class AuthorizationFilter implements Filter {

    private static final int USER = 1;
    private static final int EMPLOYEE = 2;
    private static final int ADMIN = 3;

    @Override
    public void doFilter(jakarta.servlet.ServletRequest request,
            jakarta.servlet.ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        NguoiDung user = session == null ? null : (NguoiDung) session.getAttribute("user");

        if (user == null || user.getMaVaiTro() == null
                || user.getMaVaiTro().getMaVaiTro() == null) {
            if (session == null) {
                session = httpRequest.getSession(true);
            }
            session.setAttribute("err", "Vui lòng đăng nhập để tiếp tục.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
            return;
        }

        int roleId = user.getMaVaiTro().getMaVaiTro();
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        boolean allowed = true;
        if (path.equals("/dashboard")) {
            allowed = roleId == EMPLOYEE || roleId == ADMIN;
        } else if (path.equals("/admin/products") || path.equals("/admin/orders") || path.startsWith("/admin/products/") || path.startsWith("/admin/orders/")) {
            allowed = roleId == EMPLOYEE || roleId == ADMIN;
        } else if (path.equals("/admin/users") || path.startsWith("/admin/users/")) {
            allowed = roleId == ADMIN;
        } else if (path.equals("/admin") || path.startsWith("/admin/")) {
            allowed = roleId == ADMIN;
        }

        if (!allowed) {
            session.setAttribute("err", "Bạn không có quyền truy cập trang này.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
            return;
        }

        chain.doFilter(request, response);
    }
}
