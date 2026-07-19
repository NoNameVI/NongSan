package controller;

import dao.DanhGiaDAO;
import dao.SanPhamDAO;
import entity.DanhGia;
import entity.SanPham;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import entity.HinhAnhSanPham;
import dao.HinhAnhSanPhamDAO;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {

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
        String idRaw = request.getParameter("id");
        if (idRaw != null) {
            int maSP = Integer.parseInt(idRaw);

            SanPhamDAO sanPhamDAO = new SanPhamDAO();
            HinhAnhSanPhamDAO hinhAnhDAO = new HinhAnhSanPhamDAO();
            DanhGiaDAO danhGiaDAO = new DanhGiaDAO();

            // 1. Lấy thông tin sản phẩm
            SanPham sanPham = sanPhamDAO.getProductById(maSP);

            // 2. Lấy danh sách hình ảnh kèm theo
            List<HinhAnhSanPham> listImages = hinhAnhDAO.getImagesByProductId(maSP);

            // 3. Lấy danh sách đánh giá
            List<DanhGia> listReviews = danhGiaDAO.getReviewsByProduct(maSP);

            // Gửi tất cả sang trang JSP
            request.setAttribute("product", sanPham);
            request.setAttribute("listImages", listImages);
            request.setAttribute("listReviews", listReviews);

            request.getRequestDispatcher("productdetail.jsp").forward(request, response);
        } else {
            response.sendRedirect("products"); // Nếu không có ID thì đẩy về trang danh sách
        }
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
