package dao;

import entity.DonHang;
import entity.ChiTietDonHang;
import entity.ChiTietDonHangPK;
import entity.SanPham;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;
import util.DBContext;

public class DonHangDAO extends DBContext {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");
    private EntityManager em = emf.createEntityManager();

    /**
     * Tạo đơn hàng mới (Sử dụng Transaction để đảm bảo toàn vẹn dữ liệu)
     */
    public boolean createOrder(DonHang donHang, List<ChiTietDonHang> listChiTiet) {
        try {
            em.getTransaction().begin();

            // 1. Lưu DonHang
            donHang.setTrangThai("Chờ xác nhận");
            em.persist(donHang);
            em.flush(); // Bắt buộc flush để database generate MaDH, sau đó gán lại vào donHang

            // 2. Lưu ChiTietDonHang và Trừ Tồn Kho
            for (ChiTietDonHang ct : listChiTiet) {
                // Do dùng EmbeddedId, ta phải gán MaDH vào chiTietDonHangPK
                ChiTietDonHangPK pk = ct.getChiTietDonHangPK();
                if (pk != null) {
                    pk.setMaDH(donHang.getMaDH());
                } else {
                    // Đề phòng trường hợp chưa khởi tạo PK từ Servlet
                    int maSP = (ct.getSanPham() != null) ? ct.getSanPham().getMaSP() : 0;
                    pk = new ChiTietDonHangPK(donHang.getMaDH(), maSP);
                    ct.setChiTietDonHangPK(pk);
                }

                em.persist(ct);

                // Lấy sản phẩm và trừ tồn kho (thông qua mã SP nằm trong khóa PK)
                SanPham sp = em.find(SanPham.class, pk.getMaSP());
                if (sp != null) {
                    sp.setSoLuongTon(sp.getSoLuongTon() - ct.getSoLuong());
                    em.merge(sp);
                }
            }

            // 3. Xóa giỏ hàng bằng Native Query 
            // Giả định getMaKhachHang() trả về int hoặc đối tượng NguoiDung (cần xử lý lấy id)
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
        }
    }

    /**
     * Lấy danh sách đơn hàng theo người dùng
     */
    public List<DonHang> getOrdersByUser(int userId) {
        try {
            // Lưu ý: Nếu thuộc tính MaKhachHang trong DonHang được map thành đối tượng NguoiDung
            // thì câu JPQL phải là: WHERE d.maKhachHang.maND = :userId
            String jpql = "SELECT d FROM DonHang d WHERE d.maKhachHang = :userId ORDER BY d.ngayDat DESC";
            TypedQuery<DonHang> query = em.createQuery(jpql, DonHang.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    /**
     * Lấy chi tiết của một đơn hàng cụ thể
     */
    public List<ChiTietDonHang> getOrderDetails(int orderId) {
        try {
            // Truy vấn vào trường thuộc EmbeddedId chiTietDonHangPK
            String jpql = "SELECT c FROM ChiTietDonHang c WHERE c.chiTietDonHangPK.maDH = :orderId";
            TypedQuery<ChiTietDonHang> query = em.createQuery(jpql, ChiTietDonHang.class);
            query.setParameter("orderId", orderId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    /**
     * Lấy toàn bộ danh sách đơn hàng cho Admin
     */
    public List<DonHang> getAllOrders() {
        try {
            String jpql = "SELECT d FROM DonHang d ORDER BY d.ngayDat DESC";
            TypedQuery<DonHang> query = em.createQuery(jpql, DonHang.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    /**
     * Cập nhật trạng thái đơn hàng (Có rollback tồn kho nếu hủy đơn)
     */
    public boolean updateOrderStatus(int orderId, String status) {
        try {
            em.getTransaction().begin();

            // Tìm kiếm đơn hàng
            DonHang dh = em.find(DonHang.class, orderId);
            if (dh != null) {
                dh.setTrangThai(status);
                em.merge(dh);

                // Nếu trạng thái là Đã hủy, tiến hành cộng lại tồn kho
                if ("Đã hủy".equals(status)) {
                    String jpqlCT = "SELECT c FROM ChiTietDonHang c WHERE c.chiTietDonHangPK.maDH = :orderId";
                    TypedQuery<ChiTietDonHang> queryCT = em.createQuery(jpqlCT, ChiTietDonHang.class);
                    queryCT.setParameter("orderId", orderId);
                    List<ChiTietDonHang> listCT = queryCT.getResultList();

                    for (ChiTietDonHang ct : listCT) {
                        // Lấy mã SP thông qua EmbeddedId
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
        }
    }

    /**
     * Thống kê doanh thu theo tháng
     */
    public List<Double[]> getRevenueByMonth() {
        List<Double[]> revenueList = new ArrayList<>();
        try {
            String jpql = "SELECT FUNCTION('MONTH', d.ngayDat), SUM(d.tongTien) "
                    + "FROM DonHang d "
                    + "WHERE d.trangThai = 'Đã giao' AND FUNCTION('YEAR', d.ngayDat) = FUNCTION('YEAR', CURRENT_DATE) "
                    + "GROUP BY FUNCTION('MONTH', d.ngayDat) "
                    + "ORDER BY FUNCTION('MONTH', d.ngayDat)";

            Query query = em.createQuery(jpql);
            List<Object[]> results = query.getResultList();

            for (Object[] row : results) {
                Double[] data = new Double[2];
                data[0] = ((Number) row[0]).doubleValue();
                data[1] = ((Number) row[1]).doubleValue();
                revenueList.add(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return revenueList;
    }

    /**
     * Thống kê Top 5 sản phẩm bán chạy (Sử dụng NativeQuery giữ nguyên thiết kế
     * bảng và join vật lý của SQL Server)
     */
    public List<Object[]> getTopSellingProducts() {
        List<Object[]> topProducts = new ArrayList<>();
        try {
            String sql = "SELECT TOP 5 sp.TenSP, SUM(ct.SoLuong) AS TongDaBan "
                    + "FROM ChiTietDonHang ct JOIN SanPham sp ON ct.MaSP = sp.MaSP "
                    + "JOIN DonHang dh ON ct.MaDH = dh.MaDH "
                    + "WHERE dh.TrangThai != N'Đã hủy' "
                    + "GROUP BY sp.TenSP "
                    + "ORDER BY TongDaBan DESC";

            Query query = em.createNativeQuery(sql);
            List<Object[]> results = query.getResultList();

            for (Object[] row : results) {
                Object[] item = new Object[2];
                item[0] = row[0]; // TenSP
                item[1] = ((Number) row[1]).intValue(); // TongDaBan
                topProducts.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return topProducts;
    }
}
