package controller;

import dao.DanhMucDAO;
import dao.NhaCungCapDAO;
import dao.SanPhamDAO;
import entity.DanhMuc;
import entity.NhaCungCap;
import entity.SanPham;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ProductManageServlet", urlPatterns = {"/admin/products"})
public class ProductManageServlet extends HttpServlet {

    // ================= XỬ LÝ HIỂN THỊ GIAO DIỆN =================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SanPhamDAO sanPhamDAO = new SanPhamDAO();
        DanhMucDAO danhMucDAO = new DanhMucDAO();
        NhaCungCapDAO nhaCungCapDAO = new NhaCungCapDAO();

        // 1. Kiểm tra xem có yêu cầu XÓA từ URL không (ví dụ: /admin/products?action=delete&id=1)
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int idXoa = Integer.parseInt(request.getParameter("id"));
                sanPhamDAO.deleteProduct(idXoa); // Gọi hàm xóa mềm (cập nhật trạng thái)
            } catch (Exception e) {
                e.printStackTrace();
            }
            // Xóa xong thì load lại trang
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        // 2. Lấy dữ liệu đẩy lên trang adminproducts.jsp
        List<SanPham> listSanPham = sanPhamDAO.getAllProducts();
        List<DanhMuc> listDanhMuc = danhMucDAO.getAllCategories();
        List<NhaCungCap> listNCC = nhaCungCapDAO.getAllSuppliers();

        request.setAttribute("listProducts", listSanPham);

        // Gửi danh sách Danh Mục & Nhà Cung Cấp để đổ vào thẻ <select> trong form Thêm/Sửa
        request.setAttribute("listCategories", listDanhMuc);
        request.setAttribute("listSuppliers", listNCC);

        request.getRequestDispatcher("/adminproducts.jsp").forward(request, response);
    }

    // ================= XỬ LÝ FORM THÊM / SỬA (SUBMIT BẰNG POST) =================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cấu hình UTF-8 để không bị lỗi font tiếng Việt khi nhập form
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        SanPhamDAO sanPhamDAO = new SanPhamDAO();

        try {
            // Lấy các tham số chung từ form gửi lên
            String tenSP = request.getParameter("tenSP");
            BigDecimal donGia = new BigDecimal(request.getParameter("donGia"));
            String donViTinh = request.getParameter("donViTinh");
            int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));
            String moTa = request.getParameter("moTa");
            String hinhAnh = request.getParameter("hinhAnh");
            String trangThai = request.getParameter("trangThai");

            int idDanhMuc = Integer.parseInt(request.getParameter("maDanhMuc"));
            int idNCC = Integer.parseInt(request.getParameter("maNCC"));

            // Tạo đối tượng SanPham để hứng dữ liệu
            SanPham sp = new SanPham();
            sp.setTenSP(tenSP);
            sp.setDonGia(donGia);
            sp.setDonViTinh(donViTinh);
            sp.setSoLuongTon(soLuongTon);
            sp.setMoTa(moTa);
            sp.setHinhAnh(hinhAnh);
            sp.setTrangThai(trangThai != null ? trangThai : "HoatDong");
            sp.setNgayNhap(new Date()); // Gắn ngày nhập là ngày hiện tại

            // Khởi tạo đối tượng DanhMuc và NhaCungCap để set vào SanPham (chuẩn JPA)
            DanhMuc dm = new DanhMuc();
            dm.setMaDanhMuc(idDanhMuc);
            sp.setMaDanhMuc(dm);

            NhaCungCap ncc = new NhaCungCap();
            ncc.setMaNCC(idNCC);
            sp.setMaNCC(ncc);

            // Phân nhánh xử lý theo Action
            if ("add".equals(action)) {
                // THÊM MỚI
                sanPhamDAO.insertProduct(sp);

            } else if ("update".equals(action)) {
                // CẬP NHẬT
                int maSP = Integer.parseInt(request.getParameter("maSP"));
                sp.setMaSP(maSP);
                sanPhamDAO.updateProduct(sp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi khi thêm/sửa sản phẩm: " + e.getMessage());
        }

        // Sau khi xử lý xong, điều hướng về lại danh sách
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}
