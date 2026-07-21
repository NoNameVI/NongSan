package dao;

import entity.DonHang;
import entity.ChiTietDonHang;
import entity.ChiTietDonHangPK;
import entity.ChiTietGioHang;
import entity.SanPham;
import entity.NguoiDung;
import entity.ThanhToan;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.LockModeType;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

public class DonHangDAO {

    // SỬA LỖI TREO HỆ THỐNG:
    // Trước đây "emf" là biến instance, được khởi tạo lại MỖI LẦN "new DonHangDAO()"
    // được gọi (tức là ở MỖI request trong OrderManageServlet, DashboardServlet...).
    // EntityManagerFactory là đối tượng RẤT NẶNG - nó tự mở một connection pool
    // riêng tới SQL Server. Vì không bao giờ được đóng (emf.close()), mỗi request
    // sẽ rò rỉ thêm 1 pool kết nối, khiến số connection tới SQL Server tăng dần
    // không giới hạn -> sau một thời gian vượt quá giới hạn tối đa của SQL Server
    // -> các request tiếp theo bị TREO khi cố mở kết nối mới.
    //
    // Nay "emf" là static + final, khởi tạo DUY NHẤT MỘT LẦN cho toàn ứng dụng,
    // dùng chung cho mọi instance của DonHangDAO (và lý tưởng nhất là nên đặt ở
    // một class dùng chung, vd JPAUtil, cho TẤT CẢ các DAO khác cũng dùng lại).
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");

    /**
     * Tạo đơn hàng mới (Sử dụng Transaction để đảm bảo toàn vẹn dữ liệu)[cite:
     * 3]
     */
    public boolean createOrder(DonHang donHang, List<ChiTietDonHang> listChiTiet) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            // 1. Lưu DonHang[cite: 3]
            // SỬA LỖI: DB chỉ chấp nhận giá trị KHÔNG DẤU cho TrangThai
            // (ràng buộc CK_DonHang_TrangThai: 'Cho xac nhan','Dang giao','Da giao','Da huy').
            // Giá trị có dấu "Chờ xác nhận" sẽ vi phạm CHECK constraint và làm
            // toàn bộ transaction tạo đơn hàng bị ROLLBACK (createOrder() luôn trả về false).
            donHang.setTrangThai("Cho xac nhan");
            em.persist(donHang);
            em.flush();

            // 2. Lưu ChiTietDonHang và Trừ Tồn Kho[cite: 3]
            for (ChiTietDonHang ct : listChiTiet) {
                ChiTietDonHangPK pk = ct.getChiTietDonHangPK();
                if (pk != null) {
                    pk.setMaDH(donHang.getMaDH());
                } else {
                    int maSP = (ct.getSanPham() != null) ? ct.getSanPham().getMaSP() : 0;
                    pk = new ChiTietDonHangPK(donHang.getMaDH(), maSP);
                    ct.setChiTietDonHangPK(pk);
                }

                em.persist(ct);

                SanPham sp = em.find(SanPham.class, pk.getMaSP());
                if (sp != null) {
                    sp.setSoLuongTon(sp.getSoLuongTon() - ct.getSoLuong());
                    em.merge(sp);
                }
            }

            // 3. Xóa giỏ hàng bằng Native Query[cite: 3]
            int maKH = donHang.getMaKhachHang().getMaND();
            String sqlXoaGioHang = "DELETE FROM ChiTietGioHang WHERE MaGioHang = (SELECT MaGioHang FROM GioHang WHERE MaKhachHang = ?)";
            Query queryXoaGH = em.createNativeQuery(sqlXoaGioHang);
            queryXoaGH.setParameter(1, maKH);
            queryXoaGH.executeUpdate();

            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Tạo đơn, thanh toán và xóa giỏ trong một transaction duy nhất. Dữ liệu
     * giỏ, giá và tồn kho đều được đọc lại từ DB, không tin dữ liệu từ client.
     */
    public boolean createOrder(int userId, String deliveryAddress, String paymentMethod) {
        if (!Arrays.asList("COD", "Chuyển khoản", "Ví điện tử").contains(paymentMethod)) {
            return false;
        }

        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            NguoiDung customer = em.find(NguoiDung.class, userId);
            if (customer == null) {
                throw new IllegalArgumentException("Không tìm thấy khách hàng");
            }

            List<ChiTietGioHang> cartItems = em.createQuery(
                    "SELECT c FROM ChiTietGioHang c WHERE c.gioHang.maKhachHang.maND = :userId",
                    ChiTietGioHang.class).setParameter("userId", userId).getResultList();
            if (cartItems.isEmpty()) {
                throw new IllegalStateException("Giỏ hàng trống");
            }

            BigDecimal total = BigDecimal.ZERO;
            List<ChiTietDonHang> orderDetails = new ArrayList<>();
            for (ChiTietGioHang cartItem : cartItems) {
                if (cartItem.getSanPham() == null || cartItem.getSoLuong() <= 0) {
                    throw new IllegalStateException("Dữ liệu giỏ hàng không hợp lệ");
                }
                SanPham product = em.find(SanPham.class, cartItem.getSanPham().getMaSP(), LockModeType.PESSIMISTIC_WRITE);
                if (product == null || product.getDonGia() == null || product.getSoLuongTon() < cartItem.getSoLuong()) {
                    throw new IllegalStateException("Sản phẩm không đủ tồn kho");
                }

                BigDecimal lineTotal = product.getDonGia().multiply(BigDecimal.valueOf(cartItem.getSoLuong()));
                total = total.add(lineTotal);
                ChiTietDonHang detail = new ChiTietDonHang();
                detail.setSanPham(product);
                detail.setSoLuong(cartItem.getSoLuong());
                detail.setDonGia(product.getDonGia());
                orderDetails.add(detail);
            }

            DonHang order = new DonHang();
            order.setMaKhachHang(customer); // customer là managed entity, không phải object transient.
            order.setDiaChiGiao(deliveryAddress);
            order.setNgayDat(new Date());
            order.setTrangThai("Cho xac nhan");
            order.setTongTien(total);
            em.persist(order);
            em.flush();

            for (ChiTietDonHang detail : orderDetails) {
                int productId = detail.getSanPham().getMaSP();
                detail.setChiTietDonHangPK(new ChiTietDonHangPK(order.getMaDH(), productId));
                em.persist(detail);
                SanPham product = em.find(SanPham.class, productId);
                product.setSoLuongTon(product.getSoLuongTon() - detail.getSoLuong());
            }

            ThanhToan payment = new ThanhToan();
            payment.setMaDH(order);
            payment.setPhuongThuc(paymentMethod);
            payment.setSoTien(total);
            payment.setNgayThanhToan(new Date());
            payment.setTrangThai("chua thanh toan");
            em.persist(payment);

            em.createQuery("DELETE FROM ChiTietGioHang c WHERE c.gioHang.maKhachHang.maND = :userId")
                    .setParameter("userId", userId).executeUpdate();
            em.getTransaction().commit();
            return true;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            ex.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách đơn hàng theo người dùng[cite: 3]
     */
    public List<DonHang> getOrdersByUser(int userId) {
        EntityManager em = emf.createEntityManager();
        try {
            // Sửa lại truy vấn đúng chuẩn trỏ vào khóa chính của quan hệ maKhachHang
            String jpql = "SELECT d FROM DonHang d WHERE d.maKhachHang.maND = :userId ORDER BY d.ngayDat DESC";
            TypedQuery<DonHang> query = em.createQuery(jpql, DonHang.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return new ArrayList<>();
    }

    /** Lấy một đơn thuộc về đúng khách hàng, dùng cho màn hình lịch sử/chi tiết đơn. */
    public DonHang getOrderByIdAndUser(int orderId, int userId) {
        EntityManager em = emf.createEntityManager();
        try {
            List<DonHang> orders = em.createQuery(
                    "SELECT d FROM DonHang d WHERE d.maDH = :orderId "
                    + "AND d.maKhachHang.maND = :userId", DonHang.class)
                    .setParameter("orderId", orderId)
                    .setParameter("userId", userId)
                    .setMaxResults(1)
                    .getResultList();
            return orders.isEmpty() ? null : orders.get(0);
        } finally {
            em.close();
        }
    }

    /**
     * Lấy chi tiết của một đơn hàng cụ thể[cite: 3]
     */
    public List<ChiTietDonHang> getOrderDetails(int orderId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT c FROM ChiTietDonHang c JOIN FETCH c.sanPham "
                    + "WHERE c.chiTietDonHangPK.maDH = :orderId";
            TypedQuery<ChiTietDonHang> query = em.createQuery(jpql, ChiTietDonHang.class);
            query.setParameter("orderId", orderId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return new ArrayList<>();
    }

    /**
     * Lấy toàn bộ danh sách đơn hàng cho Admin[cite: 3]
     */
    public List<DonHang> getAllOrders() {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT d FROM DonHang d ORDER BY d.ngayDat DESC";
            TypedQuery<DonHang> query = em.createQuery(jpql, DonHang.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return new ArrayList<>();
    }

    /**
     * Cập nhật trạng thái đơn hàng (Có rollback tồn kho nếu hủy đơn)[cite: 3]
     */
    public boolean updateOrderStatus(int orderId, String status) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            DonHang dh = em.find(DonHang.class, orderId);
            if (dh != null) {
                dh.setTrangThai(status);
                em.merge(dh);

                // SỬA LỖI: so sánh phải dùng giá trị KHÔNG DẤU khớp với DB,
                // nếu không rollback tồn kho sẽ không bao giờ được thực thi
                // (vì "Đã hủy".equals("Da huy") luôn là false).
                if ("Da huy".equals(status)) {
                    String jpqlCT = "SELECT c FROM ChiTietDonHang c WHERE c.chiTietDonHangPK.maDH = :orderId";
                    TypedQuery<ChiTietDonHang> queryCT = em.createQuery(jpqlCT, ChiTietDonHang.class);
                    queryCT.setParameter("orderId", orderId);
                    List<ChiTietDonHang> listCT = queryCT.getResultList();

                    for (ChiTietDonHang ct : listCT) {
                        SanPham sp = em.find(SanPham.class, ct.getChiTietDonHangPK().getMaSP());
                        if (sp != null) {
                            sp.setSoLuongTon(sp.getSoLuongTon() + ct.getSoLuong());
                            em.merge(sp);
                        }
                    }
                }
            }

            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Thống kê doanh thu theo tháng[cite: 3]
     */
    public List<Double[]> getRevenueByMonth() {
        EntityManager em = emf.createEntityManager();
        List<Double[]> revenueList = new ArrayList<>();
        try {
            int currentYear = java.time.LocalDate.now().getYear();
            // SỬA LỖI: DB lưu TrangThai không dấu ('Da giao'), so sánh với 'Đã giao'
            // (có dấu) sẽ luôn KHÔNG khớp -> query luôn trả về rỗng -> biểu đồ
            // doanh thu trên Dashboard luôn trống dù đã có đơn giao thành công.
            // Đúng theo quy ước đã chốt: doanh thu chỉ tính đơn TrangThai = 'Da giao'.
            String jpql = "SELECT FUNCTION('MONTH', d.ngayDat), SUM(d.tongTien) "
                    + "FROM DonHang d "
                    + "WHERE d.trangThai = 'Da giao' AND FUNCTION('YEAR', d.ngayDat) = :currentYear "
                    + "GROUP BY FUNCTION('MONTH', d.ngayDat) "
                    + "ORDER BY FUNCTION('MONTH', d.ngayDat)";

            Query query = em.createQuery(jpql);
            query.setParameter("currentYear", currentYear);
            List<Object[]> results = query.getResultList();

            for (Object[] row : results) {
                Double[] data = new Double[2];
                data[0] = ((Number) row[0]).doubleValue();
                data[1] = ((Number) row[1]).doubleValue();
                revenueList.add(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return revenueList;
    }

    /**
     * Thống kê Top 5 sản phẩm bán chạy[cite: 3]
     */
    public List<Object[]> getTopSellingProducts() {
        EntityManager em = emf.createEntityManager();
        List<Object[]> topProducts = new ArrayList<>();
        try {
            // SỬA LỖI: 2 vấn đề cùng lúc:
            // 1. Giá trị 'Đã hủy' (có dấu) không khớp DB ('Da huy' không dấu),
            //    nên điều kiện != gần như vô nghĩa (luôn đúng, không lọc được gì).
            // 2. Theo quy ước đã chốt, Top sản phẩm bán chạy CHỈ tính đơn đã
            //    giao thành công (TrangThai = 'Da giao'), không tính đơn đang xử lý.
            String sql = "SELECT TOP 5 sp.TenSP, SUM(ct.SoLuong) AS TongDaBan "
                    + "FROM ChiTietDonHang ct JOIN SanPham sp ON ct.MaSP = sp.MaSP "
                    + "JOIN DonHang dh ON ct.MaDH = dh.MaDH "
                    + "WHERE dh.TrangThai = N'Da giao' "
                    + "GROUP BY sp.TenSP "
                    + "ORDER BY TongDaBan DESC";

            Query query = em.createNativeQuery(sql);
            List<Object[]> results = query.getResultList();

            for (Object[] row : results) {
                Object[] item = new Object[2];
                item[0] = row[0];
                item[1] = ((Number) row[1]).intValue();
                topProducts.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return topProducts;
    }

//    public static void main(String[] args) {
//        final int USER_ID_TEST = 1; // Đổi thành MaND có dữ liệu trong ChiTietGioHang
//        final String DELIVERY_ADDRESS = "123 Đường Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh";
//        final String PAYMENT_METHOD = "COD";
//         Chỉ dùng: "COD", "Chuyển khoản", hoặc "Ví điện tử".
//
//        DonHangDAO dao = new DonHangDAO();
//
//        try {
//            boolean success = dao.createOrder(
//                    USER_ID_TEST,
//                    DELIVERY_ADDRESS,
//                    PAYMENT_METHOD
//            );
//
//            if (success) {
//                System.out.println("Đặt hàng thành công.");
//            } else {
//                System.out.println("Đặt hàng thất bại. Kiểm tra giỏ hàng, tồn kho và phương thức thanh toán.");
//            }
//        } catch (Exception ex) {
//            System.err.println("Lỗi khi kiểm tra createOrder:");
//            ex.printStackTrace();
//        }
//    }
}
