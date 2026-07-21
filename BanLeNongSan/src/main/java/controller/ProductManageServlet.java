package controller;

import dao.DanhMucDAO;
import dao.NhaCungCapDAO;
import dao.SanPhamDAO;
import entity.DanhMuc;
import entity.NhaCungCap;
import entity.SanPham;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ProductManageServlet", urlPatterns = {"/admin/products"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // Tối đa 10MB cho mỗi file
        maxRequestSize = 1024 * 1024 * 50 // Tối đa 50MB cho toàn bộ request
)
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

        // ================= XỬ LÝ RIÊNG: NGỪNG BÁN / MỞ BÁN (SOFT DELETE) =================
        // Form này chỉ gửi lên action, maSP, currentStatus -- KHÔNG có các trường tenSP, donGia...
        // Nên phải xử lý và return ngay tại đây, tuyệt đối không để rơi xuống đoạn code
        // parse form Thêm/Sửa bên dưới (sẽ gây NullPointerException khi new BigDecimal(null)).
        if ("toggleStatus".equals(action)) {
            try {
                int maSP = Integer.parseInt(request.getParameter("maSP"));
                String currentStatus = request.getParameter("currentStatus");

                // Nếu đang Ngừng bán / Hết hàng -> chuyển về Còn hàng, ngược lại -> Ngừng bán
                String newStatus = ("Ngung ban".equals(currentStatus) || "Het hang".equals(currentStatus))
                        ? "Con hang" : "Ngung ban";

                boolean ok = sanPhamDAO.updateStatus(maSP, newStatus);
                if (ok) {
                    request.getSession().setAttribute("msg", "Cập nhật trạng thái sản phẩm thành công!");
                } else {
                    request.getSession().setAttribute("err", "Không tìm thấy sản phẩm hoặc cập nhật thất bại.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("err", "Đã xảy ra lỗi khi cập nhật trạng thái: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        try {
            // 1. Lấy các tham số văn bản từ form
            String tenSP = request.getParameter("tenSP");
            BigDecimal donGia = new BigDecimal(request.getParameter("donGia"));
            String donViTinh = request.getParameter("donViTinh");
            int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));
            String moTa = request.getParameter("moTa");
            String trangThai = request.getParameter("trangThai");
            int idDanhMuc = Integer.parseInt(request.getParameter("maDanhMuc"));
            int idNhaCungCap = Integer.parseInt(request.getParameter("maNhaCungCap"));

            // Tạo đối tượng SanPham để hứng dữ liệu
            SanPham sp = new SanPham();
            sp.setTenSP(tenSP);
            sp.setDonGia(donGia);
            sp.setDonViTinh(donViTinh);
            sp.setSoLuongTon(soLuongTon);
            sp.setMoTa(moTa);
            sp.setTrangThai(trangThai != null ? trangThai : "Con hang"); // Mặc định khớp với Database

            DanhMuc dm = new DanhMuc();
            dm.setMaDanhMuc(idDanhMuc);
            sp.setMaDanhMuc(dm);

            NhaCungCap ncc = new NhaCungCap();
            ncc.setMaNCC(idNhaCungCap);
            sp.setMaNCC(ncc);

            // 2. XỬ LÝ UPLOAD FILE ẢNH
            String imagePath = null;
            Part filePart = request.getPart("hinhAnhFile"); // Lấy file từ thẻ <input type="file" name="hinhAnhFile">

            if (filePart != null && filePart.getSize() > 0) {
                // Lấy tên file gốc
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                // Xác định đường dẫn thư mục vật lý trên Server
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + "images" + File.separator + "products";

                // Tạo thư mục nếu chưa tồn tại
                File uploadDir = new File(uploadFilePath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Gắn thêm timestamp để tên file không bị trùng lặp khi người dùng up ảnh trùng tên
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

                // Ghi file vật lý vào ổ cứng Server
                filePart.write(uploadFilePath + File.separator + uniqueFileName);

                // Đường dẫn tương đối để lưu vào Database
                imagePath = "/images/products/" + uniqueFileName;
            }

            // 3. XỬ LÝ DATABASE THEO ACTION (THÊM / SỬA)
            if ("add".equals(action)) {
                // THÊM MỚI
                sp.setHinhAnh(imagePath != null ? imagePath : ""); // Lưu đường dẫn ảnh
                sp.setNgayNhap(new Date());

                sanPhamDAO.insertProduct(sp);
                request.getSession().setAttribute("msg", "Thêm sản phẩm thành công!");

            } else if ("update".equals(action)) {
                // CẬP NHẬT
                int maSP = Integer.parseInt(request.getParameter("maSP"));
                sp.setMaSP(maSP);

                // Nếu có chọn file ảnh mới thì cập nhật, nếu không thì giữ lại ảnh cũ từ Database
                if (imagePath != null) {
                    sp.setHinhAnh(imagePath);
                } else {
                    SanPham oldSp = sanPhamDAO.getProductById(maSP);
                    sp.setHinhAnh(oldSp != null ? oldSp.getHinhAnh() : "");
                }

                sanPhamDAO.updateProduct(sp);
                request.getSession().setAttribute("msg", "Cập nhật sản phẩm thành công!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("err", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
        }

        // 4. Điều hướng về danh sách
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}
