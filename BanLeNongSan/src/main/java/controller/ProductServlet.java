package controller;

import dao.DanhMucDAO;
import dao.SanPhamDAO;
import entity.DanhMuc;
import entity.SanPham;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
public class ProductServlet extends HttpServlet {

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
        SanPhamDAO sanPhamDAO = new SanPhamDAO();
        DanhMucDAO danhMucDAO = new DanhMucDAO();

        // Lấy danh sách toàn bộ danh mục để làm Menu lọc bên trái
        List<DanhMuc> listCategories = danhMucDAO.getAllCategories();
        request.setAttribute("listCategories", listCategories);

        // Lấy tham số categoryId từ URL (ví dụ: /products?categoryId=2)
        String categoryIdRaw = request.getParameter("categoryId");
        List<SanPham> listProducts;

        if (categoryIdRaw != null && !categoryIdRaw.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdRaw);
            listProducts = sanPhamDAO.getProductsByCategory(categoryId);
            request.setAttribute("tag", categoryId); // Để giữ trạng thái active trên menu
        } else {
            listProducts = sanPhamDAO.getAllProductsAvailable();
        }

        request.setAttribute("listProducts", listProducts);
        request.getRequestDispatcher("products.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        SanPhamDAO sanPhamDAO = new SanPhamDAO();
        DanhMucDAO danhMucDAO = new DanhMucDAO();

        // Luôn nạp danh sách danh mục để hiển thị Sidebar
        request.setAttribute("listCategories", danhMucDAO.getAllCategories()); // (Hàm lấy toàn bộ danh mục của bạn)

        if ("search".equals(action)) {
            String searchKeyword = request.getParameter("search");

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                searchKeyword = searchKeyword.trim();

                // Gọi DAO để tìm kiếm theo tên có chứa từ khoá (contains)
                List<SanPham> listProducts = sanPhamDAO.search(searchKeyword);

                request.setAttribute("listProducts", listProducts);
                // Trả về keyword để giữ lại trên thanh tìm kiếm & hiển thị thông báo rỗng
                request.setAttribute("searchKeyword", searchKeyword);
            } else {
                // Nếu người dùng submit ô tìm kiếm rỗng -> tải lại toàn bộ sản phẩm
                request.setAttribute("listProducts", sanPhamDAO.getAllProductsAvailable());
            }

            // Forward về trang products.jsp để hiển thị kết quả
            request.getRequestDispatcher("products.jsp").forward(request, response);

        } else {
            doGet(request, response);
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
